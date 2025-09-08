#!/bin/bash

# =============================================================================
# 电脑迁移自动化脚本 - 优化版本
# 用途: 新电脑快速配置开发环境和常用软件
# 作者: Mr.Li
# 版本: 2.0 - 完全优化版本
# =============================================================================

# 严格模式设置
set -euo pipefail
IFS=$'\n\t'

# =============================================================================
# 全局配置
# =============================================================================

# 基础配置
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_DIR="/tmp/install_logs"
readonly LOG_FILE="${LOG_DIR}/install_$(date +%Y%m%d_%H%M%S).log"
readonly PROGRESS_FILE="${LOG_DIR}/.install_progress"
readonly CONFIG_FILE="${SCRIPT_DIR}/install.conf"

# 运行时配置
readonly MAX_RETRIES=3
readonly TIMEOUT=30
readonly PARALLEL_JOBS=4

# 颜色定义
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# 默认配置
DOTFILES_REPO="https://github.com/dashabi99/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
DOWNLOADS_DIR="$HOME/Desktop/111/"

# 步骤状态
declare -A STEP_STATUS=()
declare -a TOTAL_STEPS=(
    "pre_flight_check"
    "update_system"
    "install_basic_packages"
    "clone_dotfiles"
    "create_symlinks"
    "install_oh_my_zsh"
    "download_software"
    "install_additional_tools"
)

# =============================================================================
# 核心工具函数
# =============================================================================

# 初始化环境
init_environment() {
    # 创建必要目录
    mkdir -p "$LOG_DIR" "$DOWNLOADS_DIR"

    # 初始化日志
    echo "=== 安装脚本开始执行 $(date) ===" >"$LOG_FILE"

    # 加载配置文件
    [[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

    # 加载进度状态
    load_progress
}

# 日志函数
log() {
    local level="$1"
    local msg="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local color=""

    case "$level" in
    "INFO") color="$BLUE" ;;
    "SUCCESS") color="$GREEN" ;;
    "WARNING") color="$YELLOW" ;;
    "ERROR") color="$RED" ;;
    "DEBUG") color="$PURPLE" ;;
    esac

    echo -e "${color}[$level]${NC} $msg" | tee -a "$LOG_FILE"
    echo "[$timestamp] [$level] $msg" >>"$LOG_FILE"
}

log_info() { log "INFO" "$1"; }
log_success() { log "SUCCESS" "$1"; }
log_warning() { log "WARNING" "$1"; }
log_error() { log "ERROR" "$1"; }
log_debug() { log "DEBUG" "$1"; }

# 进度管理
save_progress() {
    local step="$1"
    local status="$2"
    echo "${step}=${status}" >>"$PROGRESS_FILE"
    STEP_STATUS["$step"]="$status"
}

load_progress() {
    [[ -f "$PROGRESS_FILE" ]] || return 0

    while IFS='=' read -r step status; do
        [[ -n "$step" && -n "$status" ]] && STEP_STATUS["$step"]="$status"
    done <"$PROGRESS_FILE"
}

is_step_completed() {
    local step="$1"
    [[ "${STEP_STATUS[$step]:-}" == "completed" ]]
}

# 进度显示
show_progress() {
    local current=$1
    local total=$2
    local task="$3"
    local percent=$((current * 100 / total))

    # 创建进度条
    local bar_length=50
    local filled_length=$((percent * bar_length / 100))
    local bar=$(printf "%-${bar_length}s" "$(printf '%*s' "$filled_length" | tr ' ' '▓')")

    printf "\r${CYAN}[%d/%d]${NC} [%s] (%d%%) %s" \
        "$current" "$total" "${bar// /░}" "$percent" "$task"
}

# 带重试的命令执行
execute_with_retry() {
    local cmd="$1"
    local desc="$2"
    local retries=0

    log_debug "执行命令: $cmd"

    while [ $retries -lt $MAX_RETRIES ]; do
        if timeout "$TIMEOUT" bash -c "$cmd" >>"$LOG_FILE" 2>&1; then
            return 0
        else
            retries=$((retries + 1))
            if [ $retries -lt $MAX_RETRIES ]; then
                log_warning "$desc 失败，正在重试 ($retries/$MAX_RETRIES)..."
                sleep $((retries * 2)) # 指数退避
            else
                log_error "$desc 在 $MAX_RETRIES 次重试后仍然失败"
                return 1
            fi
        fi
    done
}

# 并行执行函数
execute_parallel() {
    local -a pids=()
    local -a commands=()
    local -a descriptions=()

    # 解析参数
    while [[ $# -gt 0 ]]; do
        commands+=("$1")
        descriptions+=("$2")
        shift 2
    done

    # 启动并行任务
    for i in "${!commands[@]}"; do
        (
            execute_with_retry "${commands[$i]}" "${descriptions[$i]}"
            echo $? >"/tmp/parallel_result_$$_$i"
        ) &
        pids+=($!)

        # 控制并发数
        if ((${#pids[@]} >= PARALLEL_JOBS)); then
            wait "${pids[0]}"
            pids=("${pids[@]:1}")
        fi
    done

    # 等待所有任务完成
    for pid in "${pids[@]}"; do
        wait "$pid"
    done

    # 检查结果
    local failed=0
    for i in "${!commands[@]}"; do
        local result_file="/tmp/parallel_result_$$_$i"
        if [[ -f "$result_file" ]]; then
            local result=$(cat "$result_file")
            [[ "$result" != "0" ]] && ((failed++))
            rm -f "$result_file"
        fi
    done

    return "$failed"
}

# 检查命令是否存在
check_command() {
    command -v "$1" &>/dev/null
}

# 检查网络连接
check_network() {
    local test_urls=("8.8.8.8" "1.1.1.1" "google.com")

    for url in "${test_urls[@]}"; do
        if ping -c 1 -W 3 "$url" &>/dev/null; then
            return 0
        fi
    done
    return 1
}

# 错误处理
handle_error() {
    local error_msg="$1"
    local line_no="${2:-unknown}"

    log_error "脚本执行失败: $error_msg (行号: $line_no)"
    log_error "详细日志请查看: $LOG_FILE"

    # 显示恢复建议
    show_recovery_options
    exit 1
}

show_recovery_options() {
    echo
    log_info "恢复选项:"
    echo "  1. 重新运行脚本将跳过已完成的步骤"
    echo "  2. 查看日志文件: $LOG_FILE"
    echo "  3. 手动执行失败的步骤"
    echo "  4. 清除进度文件重新开始: rm $PROGRESS_FILE"
}

# 设置错误陷阱
trap 'handle_error "意外错误" $LINENO' ERR

# 清理函数
cleanup() {
    log_debug "执行清理操作..."
    # 杀死所有后台进程
    jobs -p | xargs -r kill 2>/dev/null || true
    # 清理临时文件
    rm -f /tmp/parallel_result_$$_* 2>/dev/null || true
}
trap cleanup EXIT

# =============================================================================
# 预检查函数
# =============================================================================

pre_flight_check() {
    local step="pre_flight_check"
    if is_step_completed "$step"; then
        log_info "跳过已完成的步骤: 预检查"
        return 0
    fi

    log_info "开始系统预检查..."
    local checks_passed=0
    local total_checks=6

    # 检查操作系统
    show_progress 1 $total_checks "检查操作系统..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        log_success "✓ 操作系统检查通过 (Linux)"
        ((checks_passed++))
    else
        log_error "✗ 不支持的操作系统: $OSTYPE"
    fi

    # 检查是否为Ubuntu/Debian
    show_progress 2 $total_checks "检查发行版..."
    if check_command apt-get; then
        log_success "✓ 发行版检查通过 (Debian/Ubuntu)"
        ((checks_passed++))
    else
        log_error "✗ 需要基于Debian的发行版"
    fi

    # 检查sudo权限
    show_progress 3 $total_checks "检查sudo权限..."
    if sudo -n true 2>/dev/null; then
        log_success "✓ sudo权限检查通过"
        ((checks_passed++))
    else
        log_warning "需要sudo权限，请确保当前用户在sudoers中"
        if sudo true; then
            log_success "✓ sudo权限验证通过"
            ((checks_passed++))
        fi
    fi

    # 检查网络连接
    show_progress 4 $total_checks "检查网络连接..."
    if check_network; then
        log_success "✓ 网络连接检查通过"
        ((checks_passed++))
    else
        log_error "✗ 网络连接失败，请检查网络设置"
    fi

    # 检查磁盘空间 (至少2GB)
    show_progress 5 $total_checks "检查磁盘空间..."
    local available_space=$(df "$HOME" | tail -1 | awk '{print $4}')
    local required_space=$((2 * 1024 * 1024)) # 2GB in KB

    if [[ "$available_space" -gt "$required_space" ]]; then
        log_success "✓ 磁盘空间充足 ($(($available_space / 1024 / 1024))GB 可用)"
        ((checks_passed++))
    else
        log_error "✗ 磁盘空间不足，需要至少2GB空间"
    fi

    # 检查必需命令
    show_progress 6 $total_checks "检查必需工具..."
    local required_commands=("curl" "wget" "git")
    local missing_commands=()

    for cmd in "${required_commands[@]}"; do
        if ! check_command "$cmd"; then
            missing_commands+=("$cmd")
        fi
    done

    if [[ ${#missing_commands[@]} -eq 0 ]]; then
        log_success "✓ 必需工具检查通过"
        ((checks_passed++))
    else
        log_warning "缺少工具: ${missing_commands[*]}，将在后续步骤中安装"
        ((checks_passed++)) # 允许继续，稍后安装
    fi

    echo # 换行

    if [[ $checks_passed -eq $total_checks ]]; then
        log_success "预检查完成，所有检查通过 ($checks_passed/$total_checks)"
        save_progress "$step" "completed"
    else
        log_error "预检查失败 ($checks_passed/$total_checks 通过)"
        return 1
    fi
}

# =============================================================================
# 主要安装函数
# =============================================================================

update_system() {
    local step="update_system"
    if is_step_completed "$step"; then
        log_info "跳过已完成的步骤: 系统更新"
        return 0
    fi

    log_info "开始系统更新..."

    show_progress 1 2 "更新软件包列表..."
    execute_with_retry "sudo apt update" "apt update" || return 1

    show_progress 2 2 "升级系统软件包..."
    execute_with_retry "sudo apt upgrade -y" "apt upgrade" || return 1

    echo
    log_success "系统更新完成"
    save_progress "$step" "completed"
}

install_basic_packages() {
    local step="install_basic_packages"
    if is_step_completed "$step"; then
        log_info "跳过已完成的步骤: 基础软件包安装"
        return 0
    fi

    log_info "安装基础软件包..."

    local packages=(
        "git" "wget" "curl" "tree" "meld" "ssh" "zsh" "vim" "tmux"
        "build-essential" "xsel" "unzip" "zip" "htop" "ripgrep" "fd-find"
    )

    local installed=0
    local total=${#packages[@]}

    for package in "${packages[@]}"; do
        ((installed++))
        show_progress $installed $total "安装 $package..."

        if execute_with_retry "sudo apt install -y $package" "安装 $package"; then
            log_debug "✓ $package 安装成功"
        else
            log_warning "✗ $package 安装失败，将跳过"
        fi
    done

    echo
    log_success "基础软件包安装完成"
    save_progress "$step" "completed"
}

clone_dotfiles() {
    local step="clone_dotfiles"
    if is_step_completed "$step"; then
        log_info "跳过已完成的步骤: dotfiles克隆"
        return 0
    fi

    log_info "准备dotfiles配置..."

    if [[ -d "$DOTFILES_DIR" ]]; then
        log_warning "dotfiles目录已存在，更新仓库..."
        show_progress 1 2 "更新dotfiles仓库..."
        execute_with_retry "cd '$DOTFILES_DIR' && git pull origin main" "更新dotfiles"
    else
        show_progress 1 2 "克隆dotfiles仓库..."
        execute_with_retry "git clone '$DOTFILES_REPO' '$DOTFILES_DIR'" "克隆dotfiles"
    fi

    show_progress 2 2 "克隆tmux插件..."
    execute_with_retry "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm" "克隆tmux插件" || {
        log_warning "tmux插件克隆失败，可能已存在"
    }

    echo
    log_success "dotfiles准备完成"
    save_progress "$step" "completed"
}

create_symlinks() {
    local step="create_symlinks"
    if is_step_completed "$step"; then
        log_info "跳过已完成的步骤: 符号链接创建"
        return 0
    fi

    log_info "创建配置文件符号链接..."

    # 创建备份目录
    local backup_dir="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"

    # 配置文件映射
    declare -A config_files=(
        ["$DOTFILES_DIR/zsh/.zshrc"]="$HOME/.zshrc"
        ["$DOTFILES_DIR/vim/.vimrc"]="$HOME/.vimrc"
        ["$DOTFILES_DIR/tmux/.tmux.conf"]="$HOME/.tmux.conf"
        ["$DOTFILES_DIR/wezterm"]="$HOME/.config/wezterm"
        ["$DOTFILES_DIR/nvim"]="$HOME/.config/nvim"
        ["$DOTFILES_DIR/ghostty"]="$HOME/.config/ghostty"
    )

    local processed=0
    local total=${#config_files[@]}

    for src in "${!config_files[@]}"; do
        ((processed++))
        local dest="${config_files[$src]}"
        local filename=$(basename "$dest")

        show_progress $processed $total "链接 $filename..."

        if [[ -e "$src" ]]; then
            # 备份现有配置
            if [[ -e "$dest" ]]; then
                log_debug "备份现有配置: $dest"
                mv "$dest" "$backup_dir/"
            fi

            # 创建目标目录
            mkdir -p "$(dirname "$dest")"

            # 创建符号链接
            ln -sf "$src" "$dest"
            log_debug "✓ 已链接: $src -> $dest"
        else
            log_warning "✗ 源文件不存在: $src"
        fi
    done

    echo
    log_success "符号链接创建完成"
    log_info "原配置已备份到: $backup_dir"
    save_progress "$step" "completed"
}

install_oh_my_zsh() {
    local step="install_oh_my_zsh"
    if is_step_completed "$step"; then
        log_info "跳过已完成的步骤: Oh My Zsh安装"
        return 0
    fi

    log_info "安装Oh My Zsh..."

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        show_progress 1 3 "安装Oh My Zsh..."
        execute_with_retry 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended' "安装Oh My Zsh"

        show_progress 2 3 "安装zsh插件..."
        local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

        execute_parallel \
            "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $plugins_dir/zsh-syntax-highlighting" \
            "安装zsh-syntax-highlighting" \
            "git clone https://github.com/zsh-users/zsh-autosuggestions $plugins_dir/zsh-autosuggestions" \
            "安装zsh-autosuggestions"

        show_progress 3 3 "设置默认shell..."
        if [[ "$SHELL" != "$(which zsh)" ]]; then
            log_info "设置zsh为默认shell..."
            execute_with_retry "chsh -s $(which zsh)" "设置默认shell"
        fi
    else
        log_info "Oh My Zsh已安装，跳过"
    fi

    echo
    log_success "Oh My Zsh安装完成"
    save_progress "$step" "completed"
}

download_software() {
    local step="download_software"
    if is_step_completed "$step"; then
        log_info "跳过已完成的步骤: 软件下载"
        return 0
    fi

    log_info "开始并行下载软件包..."
    mkdir -p "$DOWNLOADS_DIR"

    # 定义下载任务
    declare -A downloads=(
        ["google-chrome-stable_current_amd64.deb"]="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
        ["vscode_amd64.deb"]="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
        ["spark-store_amd64.deb"]="https://d.store.deepinos.org.cn/store/chat/spark-store_3.0.5-842_amd64.deb"
        ["wezterm-nightly.deb"]="https://github.com/wezterm/wezterm/releases/download/nightly/wezterm-nightly.Ubuntu24.04.deb"
    )

    local download_commands=()
    local download_descriptions=()

    for filename in "${!downloads[@]}"; do
        local url="${downloads[$filename]}"
        local filepath="$DOWNLOADS_DIR/$filename"

        # 检查是否已存在
        if [[ -f "$filepath" ]]; then
            log_info "文件已存在，跳过: $filename"
            continue
        fi

        download_commands+=("wget -q --show-progress '$url' -O '$filepath'")
        download_descriptions+=("下载 $filename")
    done

    if [[ ${#download_commands[@]} -gt 0 ]]; then
        log_info "开始并行下载 ${#download_commands[@]} 个文件..."

        if execute_parallel "${download_commands[@]}" "${download_descriptions[@]}"; then
            log_success "所有软件包下载完成"
        else
            log_warning "部分软件包下载失败，请检查网络连接"
        fi
    else
        log_info "所有文件已存在，无需下载"
    fi

    log_success "软件包准备完成"
    log_info "下载位置: $DOWNLOADS_DIR"
    save_progress "$step" "completed"
}

install_additional_tools() {
    local step="install_additional_tools"
    if is_step_completed "$step"; then
        log_info "跳过已完成的步骤: 附加工具安装"
        return 0
    fi

    log_info "安装附加开发工具..."

    show_progress 1 3 "安装Node.js..."
    if ! check_command node; then
        # Download and install nvm
        execute_with_retry "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash" "安装nvm"
        
        # in lieu of restarting the shell
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        
        if check_command nvm; then
            # Download and install Node.js
            execute_with_retry "nvm install 22" "安装Node.js 22"
            execute_with_retry "nvm use 22" "设置Node.js 22为默认版本"
            
            # Verify the installation
            if check_command node; then
                local node_version=$(node -v)
                local npm_version=$(npm -v)
                log_success "Node.js安装成功: $node_version"
                log_success "npm版本: $npm_version"
            fi
        else
            log_warning "nvm安装失败，请手动安装"
        fi
    else
        log_info "Node.js已安装 ($(node --version))"
    fi

    show_progress 2 3 "安装Python工具..."
    execute_with_retry "sudo apt install -y python3-pip" "安装pip" || log_warning "pip安装失败"

    show_progress 3 3 "安装其他工具..."
    execute_with_retry "sudo apt install -y ripgrep fd-find" "安装ripgrep和fd" || log_warning "部分工具安装失败"

    echo
    log_success "附加工具安装完成"
    save_progress "$step" "completed"
}

# =============================================================================
# 摘要和收尾
# =============================================================================

show_summary() {
    echo
    log_success "=== 🎉 安装完成摘要 ==="
    echo

    # 显示完成的步骤
    local completed_steps=0
    for step in "${TOTAL_STEPS[@]}"; do
        if is_step_completed "$step"; then
            echo "✅ $(get_step_description "$step")"
            ((completed_steps++))
        else
            echo "❌ $(get_step_description "$step")"
        fi
    done

    echo
    echo "📊 完成情况: $completed_steps/${#TOTAL_STEPS[@]} 步骤"

    if [[ $completed_steps -eq ${#TOTAL_STEPS[@]} ]]; then
        log_success "🎉 所有步骤均已完成！"
    else
        log_warning "部分步骤未完成，可重新运行脚本继续"
    fi

    echo
    echo "📦 已下载的软件包 (需手动安装):"
    for file in "$DOWNLOADS_DIR"/*.deb; do
        [[ -f "$file" ]] && echo "   • $(basename "$file")"
    done

    echo
    echo "💡 后续建议:"
    echo "   1. 重启终端或执行: source ~/.zshrc"
    echo "   2. 安装deb包: sudo dpkg -i $DOWNLOADS_DIR/*.deb"
    echo "   3. 配置SSH密钥和Git凭据"
    echo "   4. 检查配置文件并根据需要调整"
    echo
    echo "📋 详细日志: $LOG_FILE"
    echo "📁 下载目录: $DOWNLOADS_DIR"

    # 生成安装报告
    generate_report
}

get_step_description() {
    case "$1" in
    "pre_flight_check") echo "系统预检查" ;;
    "update_system") echo "系统更新" ;;
    "install_basic_packages") echo "基础软件包安装" ;;
    "clone_dotfiles") echo "配置文件同步" ;;
    "create_symlinks") echo "符号链接创建" ;;
    "install_oh_my_zsh") echo "Oh My Zsh安装" ;;
    "download_software") echo "软件包下载" ;;
    "install_additional_tools") echo "附加工具安装" ;;
    *) echo "$1" ;;
    esac
}

generate_report() {
    local report_file="${LOG_DIR}/install_report_$(date +%Y%m%d_%H%M%S).txt"

    {
        echo "========================================"
        echo "  电脑迁移脚本执行报告"
        echo "========================================"
        echo "执行时间: $(date)"
        echo "脚本版本: 2.0"
        echo "系统信息: $(uname -a)"
        echo
        echo "步骤执行情况:"
        for step in "${TOTAL_STEPS[@]}"; do
            local status="${STEP_STATUS[$step]:-未执行}"
            printf "  %-20s: %s\n" "$(get_step_description "$step")" "$status"
        done
        echo
        echo "日志文件: $LOG_FILE"
        echo "下载目录: $DOWNLOADS_DIR"
        echo "========================================"
    } >"$report_file"

    log_info "安装报告已生成: $report_file"
}

# =============================================================================
# 交互式菜单 (可选)
# =============================================================================

show_interactive_menu() {
    echo
    log_info "选择安装模式:"
    echo "  1. 完整安装 (推荐)"
    echo "  2. 自定义安装"
    echo "  3. 仅下载软件包"
    echo "  4. 查看已完成步骤"
    echo "  5. 重置进度"
    echo

    read -p "请选择 (1-5): " choice

    case "$choice" in
    1) return 0 ;; # 继续完整安装
    2) show_custom_menu ;;
    3) download_only_mode ;;
    4) show_progress_status ;;
    5) reset_progress ;;
    *) log_warning "无效选择，使用完整安装模式" ;;
    esac
}

show_custom_menu() {
    echo "自定义安装选项 (输入步骤编号，用空格分隔):"
    for i in "${!TOTAL_STEPS[@]}"; do
        echo "  $((i + 1)). $(get_step_description "${TOTAL_STEPS[$i]}")"
    done

    read -p "选择步骤: " -a selected_indices

    local custom_steps=()
    for index in "${selected_indices[@]}"; do
        if [[ $index -ge 1 && $index -le ${#TOTAL_STEPS[@]} ]]; then
            custom_steps+=("${TOTAL_STEPS[$((index - 1))]}")
        fi
    done

    if [[ ${#custom_steps[@]} -gt 0 ]]; then
        TOTAL_STEPS=("${custom_steps[@]}")
        log_info "将执行 ${#custom_steps[@]} 个选定步骤"
    else
        log_warning "无有效选择，执行完整安装"
    fi
}

download_only_mode() {
    log_info "仅下载模式"
    download_software
    log_success "下载完成，脚本退出"
    exit 0
}

show_progress_status() {
    echo
    log_info "当前进度状态:"
    for step in "${TOTAL_STEPS[@]}"; do
        local status="${STEP_STATUS[$step]:-未执行}"
        local desc="$(get_step_description "$step")"
        printf "  %-20s: %s\n" "$desc" "$status"
    done
    echo
    read -p "按Enter键继续..."
}

reset_progress() {
    read -p "确定要重置所有进度吗？(y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        rm -f "$PROGRESS_FILE"
        unset STEP_STATUS
        declare -gA STEP_STATUS=()
        log_success "进度已重置"
    fi
}

# =============================================================================
# 主程序
# =============================================================================

show_banner() {
    echo
    echo "============================================="
    echo "     🚀 电脑迁移自动化脚本 v2.0"
    echo "============================================="
    echo
}

main() {
    # 初始化
    init_environment
    show_banner

    # 显示基本信息
    log_info "脚本特性:"
    echo "  ✅ 智能跳过已完成步骤"
    echo "  ✅ 并行下载和安装"
    echo "  ✅ 自动重试和错误恢复"
    echo "  ✅ 详细日志和进度跟踪"
    echo "  ✅ 交互式安装选项"
    echo

    log_info "配置信息:"
    echo "  📁 dotfiles仓库: $DOTFILES_REPO"
    echo "  📁 下载目录: $DOWNLOADS_DIR"
    echo "  📝 日志文件: $LOG_FILE"
    echo

    # 显示预估时间
    log_info "预估执行时间: 10-20分钟 (取决于网络速度)"
    echo

    # 交互式菜单 (可选)
    if [[ "${1:-}" != "--auto" ]]; then
        read -p "是否显示安装选项菜单？(y/N): " show_menu
        [[ "$show_menu" == "y" || "$show_menu" == "Y" ]] && show_interactive_menu
    fi

    # 确认执行
    if [[ "${1:-}" != "--auto" ]]; then
        echo
        log_warning "即将开始安装，请确保:"
        echo "  🌐 网络连接稳定"
        echo "  🔐 具有sudo权限"
        echo "  💾 至少2GB可用空间"
        echo
        read -p "确认开始安装？(Y/n): " confirm
        if [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
            log_info "安装已取消"
            exit 0
        fi
    fi

    # 执行安装步骤
    local start_time=$(date +%s)
    local step_count=0
    local total_steps=${#TOTAL_STEPS[@]}

    log_info "开始执行安装流程..."
    echo

    for step in "${TOTAL_STEPS[@]}"; do
        ((step_count++))
        echo
        log_info "=== 步骤 $step_count/$total_steps: $(get_step_description "$step") ==="

        if "$step"; then
            log_success "步骤完成: $(get_step_description "$step")"
        else
            log_error "步骤失败: $(get_step_description "$step")"
            log_warning "可以重新运行脚本继续剩余步骤"
            exit 1
        fi
    done

    # 计算执行时间
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))

    echo
    log_success "🎉 所有步骤执行完成！"
    log_info "总执行时间: ${minutes}分${seconds}秒"

    # 显示摘要
    show_summary
}

# =============================================================================
# 脚本入口点
# =============================================================================

# 处理命令行参数
case "${1:-}" in
--help | -h)
    echo "用法: $0 [选项]"
    echo "选项:"
    echo "  --auto    自动模式，不显示交互菜单"
    echo "  --help    显示此帮助信息"
    echo "  --reset   重置安装进度"
    echo "  --status  显示当前进度"
    exit 0
    ;;
--reset)
    rm -f "$PROGRESS_FILE" 2>/dev/null || true
    echo "安装进度已重置"
    exit 0
    ;;
--status)
    [[ -f "$PROGRESS_FILE" ]] && cat "$PROGRESS_FILE" || echo "无进度记录"
    exit 0
    ;;
esac

# 主程序入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

