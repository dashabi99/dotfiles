# 参考配置：https://github.com/codeopshq/dotfiles

# 使用P10k就把starship注释掉
# 启用 Powerlevel10k 即时提示。应该保持在 ~/.zshrc 的顶部附近。
# 可能需要控制台输入的初始化代码（密码提示、[y/n] 确认等）必须放在此块之上；其他所有内容可以放在下面。
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### zinit初始化开始
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### zinit初始化结束

# 添加 Powerlevel10k 主题
zinit ice depth=1; zinit light romkatv/powerlevel10k
# 添加 starship 主题
# zinit ice as"command" from"gh-r" \
#           atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
#           atpull"%atclone" src"init.zsh"
# zinit light starship/starship

# 添加 zsh 插件 (按加载顺序优化)--方法一
# zinit ice blockf atpull'zinit creinstall -q .'
# zinit light zsh-users/zsh-completions
# # 加载 completions 以提升补全内容(暂时没感受到这个插件的提升)
# autoload -Uz compinit
# compinit -C
# zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab
# # zinit light zsh-users/zsh-syntax-highlighting
# zinit light zdharma-continuum/fast-syntax-highlighting

# 使用turbo来优化插件速度--方法二
zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
     zdharma-continuum/fast-syntax-highlighting \
  blockf \
     zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
     zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
autoload -Uz compinit
compinit -C

# 添加 OMZ 插件(git感觉用不上，还会导致时间变长)
# zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
# 这两个是把终端窗口显示的标题栏改成omz的样式 -> 为了让我设置的wezterm的图标能匹配上
zinit snippet OMZ::lib/functions.zsh
zinit snippet OMZ::lib/termsupport.zsh

#######################################################
# ZSH 基础选项
#######################################################
setopt autocd              # 只需输入目录名即可更改目录
# setopt correct             # 自动纠正错误(有点频繁了，给关掉了)
setopt interactivecomments # 在交互模式下允许注释
setopt magicequalsubst     # 为形式为 'anything=expression' 的参数启用文件名扩展
setopt nonomatch           # 如果模式没有匹配项，则隐藏错误消息
setopt notify              # 立即报告后台作业的状态
setopt numericglobsort     # 在有意义时按数字对文件名进行排序
setopt promptsubst         # 在提示符中启用命令替换

#######################################################
# 环境变量
#######################################################
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export FCEDIT=nvim
# export TERMINAL=wezterm
# export BROWSER=com.chrome

# 设置终端类型支持 256 色
[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color

# fzf 显示美化
if [[ -x "$(command -v fzf)" ]]; then
	export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
	  --info=inline-right \
	  --ansi \
	  --layout=reverse \
	  --border=rounded \
	  --color=border:#27a1b9 \
	  --color=fg:#c0caf5 \
	  --color=gutter:#16161e \
	  --color=header:#ff9e64 \
	  --color=hl+:#2ac3de \
	  --color=hl:#2ac3de \
	  --color=info:#545c7e \
	  --color=marker:#ff007c \
	  --color=pointer:#ff007c \
	  --color=prompt:#2ac3de \
	  --color=query:#c0caf5:regular \
	  --color=scrollbar:#27a1b9 \
	  --color=separator:#ff9e64 \
	  --color=spinner:#ff007c \
	"
fi

#######################################################
# 历史记录配置
#######################################################
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase     # 删除旧的重复项
setopt appendhistory    # 追加到历史文件，而不是覆盖
setopt sharehistory     # 在多个终端会话之间共享历史记录
setopt hist_ignore_space    # 忽略以空格开头的命令
setopt hist_ignore_all_dups    # 忽略所有重复的命令
setopt hist_save_no_dups        # 保存时忽略重复项
setopt hist_ignore_dups     # 忽略连续重复的命令
setopt hist_find_no_dups    # 在搜索历史时忽略重复项
# setopt hist_reduce_blanks  # 将多个连续的空格缩减为一个

#######################################################
# 补全样式配置
#######################################################
# 大小写不敏感补全
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# 使用颜色显示补全列表
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# 禁用默认补全菜单，使用 fzf-tab
zstyle ':completion:*' menu no

# fzf-tab 预览配置
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Docker 补全优化
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# 补全缓存
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# 补全分组
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'

#######################################################
# 别名配置
#######################################################
# 基础别名
# alias c='clear'
# alias q='exit'
alias ll='ls -lF'
alias la='ls -A'
alias l='ls -CF'

# 目录导航
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# 安全操作别名
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

# 颜色支持
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls='ls --color=auto'

# 编辑器别名
alias vi='nvim'
# alias vim='nvim'
alias v='nvim'
alias ec='exec zsh'
alias ti='time zsh -i -c exit'

#######################################################
# 将常用二进制目录添加到路径
#######################################################
# 如果目录存在且尚未在路径中，则将目录添加到路径末尾
# 链接: https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
function pathappend() {
    for ARG in "$@"
    do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="${PATH:+"$PATH:"}$ARG"
        fi
    done
}

# 如果目录存在且尚未在路径中，则将目录添加到路径开头
function pathprepend() {
    for ARG in "$@"
    do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="$ARG${PATH:+":$PATH"}"
        fi
    done
}

# y shell 包装器，提供在退出 Yazi 时更改当前工作目录的功能。
# function y() {
# 	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
# 	yazi "$@" --cwd-file="$tmp"
# 	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
# 		builtin cd -- "$cwd"
# 	fi
# 	rm -f -- "$tmp"
# }

# 路径的环境变量
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
pathprepend "$HOME/bin" "$HOME/sbin" "$HOME/.local/bin" "$HOME/local/bin" "$HOME/.bin"

#######################################################
# 函数
#######################################################

# 启动程序并从终端分离
function runfree() {
	"$@" > /dev/null 2>&1 & disown
}

# 带进度的文件复制
function cpp() {
	if command -v rsync > /dev/null; then
		rsync -ah --info=progress2 "${1}" "${2}"
	else
		cp "${1}" "${2}"
	fi
}

# 复制并切换到目录
function cpg() {
	cp "$1" "$2" && [[ -d "$2" ]] && cd "$2"
}

# 移动并切换到目录
function mvg() {
	mv "$1" "$2" && [[ -d "$2" ]] && cd "$2"
}

# 创建目录并切换进入
function mkdirg() {
	mkdir -p "$1" && cd "$1"
}

# 快速查找并编辑文件
function fe() {
	local file
	file=$(find . -type f -name "*$1*" | head -1)
	[[ -n "$file" ]] && ${EDITOR:-nvim} "$file"
}

# 快速创建备份
function backup() {
	cp "$1" "${1}.backup.$(date +%Y%m%d_%H%M%S)"
}

#######################################################
# ZSH 语法高亮，如果用fast语法高亮插件，这个就不用了
#######################################################
# [[ -f ~/.zsh/zsh-syntax-highlightin-tokyonight.zsh ]] && source ~/.zsh/zsh-syntax-highlightin-tokyonight.zsh

#######################################################
# 个人配置
#######################################################
# 加载 Powerlevel10k 自定义配置
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# 加载fzf配置
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# 加载node.js (安装nvim的插件前要安装这个)
export NVM_DIR="$HOME/.nvm"
# 懒加载 nvm
load_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm_lazy_load() {
    # Load NVM only if it's not already loaded
    if ! command -v nvm &> /dev/null; then
        load_nvm
    fi
}
# Add any commands that require Node.js here
nvm_commands=(node npm npx claude)
for cmd in "${nvm_commands[@]}"; do
    eval "
    function $cmd {
        nvm_lazy_load
        unset -f $cmd
        $cmd \"\$@\"
    }"
done
# 立即加载 nvm（如果你更喜欢这样,会导致启动多400ms）
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# export PATH="$NVM_DIR/versions/node/$(nvm version)/bin:$PATH"

# 加载 zinit 附加组件以提升性能，没使用Turbo模式
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ==========starship配置==========
# eval "$(starship init zsh)"
