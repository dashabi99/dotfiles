# 参考配置：https://github.com/codeopshq/dotfiles

# =========================================================
# 基础：P10k instant prompt（必须在最顶部）
# =========================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =========================================================
# zinit 初始化（插件管理器）
# =========================================================
ZINIT_HOME="${HOME}/.local/share/zinit"
if [[ ! -f "$ZINIT_HOME/zinit.git/zinit.zsh" ]]; then
  print -P "%F{33} %F{220}Installing %F{33}Zinit%F{220}…%f"
  command mkdir -p "$ZINIT_HOME" && command chmod g-rwX "$ZINIT_HOME"
  command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME/zinit.git" \
    && print -P "%F{33} %F{34}Installation successful.%f%b" \
    || print -P "%F{160} The clone has failed.%f%b"
fi

source "$ZINIT_HOME/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# =========================================================
# 主题：Powerlevel10k（快速 + 即时提示）
# =========================================================
zinit ice depth=1
zinit light romkatv/powerlevel10k
# 添加 starship 主题
# zinit ice as"command" from"gh-r" \
#           atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
#           atpull"%atclone" src"init.zsh"
# zinit light starship/starship

# =========================================================
# 插件：使用 zinit turbo 模式加速
# =========================================================
# 提示补全、语法高亮、历史建议等按需懒加载
zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zinit light Aloxaf/fzf-tab

# OMZ 片段（只保留你真正用到的）
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
# 终端标题支持（配合 wezterm，可按需保留）
zinit snippet OMZ::lib/functions.zsh
zinit snippet OMZ::lib/termsupport.zsh

# 手动跑一次 compinit，配合 zinit 的 compinit 优化参数
autoload -Uz compinit
compinit -C

# =========================================================
# Zsh 基础选项
# =========================================================
setopt autocd              # 只需输入目录名即可 cd
setopt interactivecomments # 允许交互式注释
setopt magicequalsubst     # foo=*.txt 这种启用文件名扩展
setopt nonomatch           # 模式无匹配时不报错
setopt notify              # 后台作业状态立刻报告
setopt numericglobsort     # 数字顺序排序
setopt promptsubst         # 提示符中支持命令替换

# =========================================================
# 环境变量
# =========================================================
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export FCEDIT=nvim

# 终端 256 色支持
[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color

# =========================================================
# fzf 美化
# =========================================================
if command -v fzf &>/dev/null; then
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
    --color=spinner:#ff007c"
fi

# =========================================================
# 历史记录配置
# =========================================================
HISTSIZE=10000
HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory        # 追加到历史文件
setopt sharehistory         # 多终端共享历史
setopt hist_ignore_space    # 忽略以空格开头的命令
setopt hist_ignore_all_dups # 忽略所有重复命令
setopt hist_save_no_dups    # 保存时忽略重复项
setopt hist_ignore_dups     # 忽略连续重复的命令
setopt hist_find_no_dups    # 在搜索历史时忽略重复项
# setopt hist_reduce_blanks # 将多个连续的空格缩减为一个

# =========================================================
# 补全样式 & fzf-tab
# =========================================================
# 大小写不敏感
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# 彩色列表
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# 禁用默认补全菜单，交给 fzf-tab
zstyle ':completion:*' menu no

# fzf-tab 预览
zstyle ':fzf-tab:complete:cd:*'          fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*'  fzf-preview 'ls --color $realpath'

# Docker 补全优化
zstyle ':completion:*:*:docker:*'    option-stacking yes
zstyle ':completion:*:*:docker-*:*'  option-stacking yes

# 补全缓存
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"

# 补全分组
zstyle ':completion:*'               group-name ''
zstyle ':completion:*:descriptions'  format '[%d]'

# =========================================================
# 常用别名
# =========================================================
alias ll='ls -lF'
alias la='ls -A'
alias l='ls -CF'

# 目录导航
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# 安全操作
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

# 彩色输出
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls='ls --color=auto'

# 编辑器
alias vi='nvim'
alias v='nvim'

# 重新加载配置 / 测启动时间
alias ec='exec zsh'
alias ti='time zsh -i -c exit'

# =========================================================
# PATH 处理函数 + 常用路径
# =========================================================
# 如果目录存在且尚未在路径中，则将目录添加到路径末尾
# 链接: https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
pathappend() {
  for ARG in "$@"; do
    if [[ -d "$ARG" && ":$PATH:" != *":$ARG:"* ]]; then
      PATH="${PATH:+$PATH:}$ARG"
    fi
  done
}

pathprepend() {
  for ARG in "$@"; do
    if [[ -d "$ARG" && ":$PATH:" != *":$ARG:"* ]]; then
      PATH="$ARG${PATH:+:$PATH}"
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

# 把个人 bin 放前面
pathprepend "$HOME/bin" "$HOME/sbin" "$HOME/.local/bin" "$HOME/local/bin" "$HOME/.bin"

# =========================================================
# 实用函数
# =========================================================
# 后台运行并脱离当前终端
runfree() {
  "$@" >/dev/null 2>&1 & disown
}

# 带进度的复制
cpp() {
  if command -v rsync >/dev/null 2>&1; then
    rsync -ah --info=progress2 "$1" "$2"
  else
    cp "$1" "$2"
  fi
}

# 复制并进入目录
cpg() {
  cp "$1" "$2" && [[ -d "$2" ]] && cd "$2"
}

# 移动并进入目录
mvg() {
  mv "$1" "$2" && [[ -d "$2" ]] && cd "$2"
}

# 创建目录并进入
mkdirg() {
  mkdir -p "$1" && cd "$1"
}

# 快速查找并编辑文件（命中第一个）
fe() {
  local file
  file=$(find . -type f -name "*$1*" 2>/dev/null | head -n 1)
  [[ -n "$file" ]] && "${EDITOR:-nvim}" "$file"
}

# 简单备份
backup() {
  cp "$1" "${1}.backup.$(date +%Y%m%d_%H%M%S)"
}

#######################################################
# ZSH 语法高亮的个人配置文件，如果用fast-syntax-highlighting语法高亮插件，这个就不用了,fast-theme -l 查看主题，然后设置
#######################################################
# [[ -f ~/.zsh/zsh-syntax-highlightin-tokyonight.zsh ]] && source ~/.zsh/zsh-syntax-highlightin-tokyonight.zsh

#######################################################
# 自动设置终端标题,可以取消上面的omz的标题设置，打开下面的自己定义窗口标题
#######################################################
# autoload -Uz add-zsh-hook
#
# # 在命令提示符准备好之前更新标题，只显示用户、主机名和路径
# function xterm_title_precmd () {
#     print -Pn -- '\e]2;%n@%m %~\a'
# }
# # 在命令执行前更新标题，显示完整的信息，包括分隔符 -->
# function xterm_title_preexec () {
#     print -Pn -- '\e]2;%n@%m %~ --> ' && print -n -- "${(q)1}\a"
# }
# add-zsh-hook precmd xterm_title_precmd
# add-zsh-hook preexec xterm_title_preexec

# =========================================================
# 个人附加配置
# =========================================================
# P10k 配置
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# fzf 自带的 shell 集成
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# =========================================================
# nvm 懒加载（减少启动时间）
# =========================================================
export NVM_DIR="$HOME/.nvm"

load_nvm() {
  [[ -s "$NVM_DIR/nvm.sh" ]]          && . "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
}

nvm_lazy_load() {
  if ! command -v nvm &>/dev/null; then
    load_nvm
  fi
}

# 需要 Node 环境的命令（自己可按需增减）
nvm_commands=(node npm npx claude)
for cmd in "${nvm_commands[@]}"; do
  eval "
  function $cmd() {
    nvm_lazy_load
    unset -f $cmd
    $cmd \"\$@\"
  }"
done

# 立即加载 nvm（如果你更喜欢这样,会导致启动多400ms）
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# export PATH="$NVM_DIR/versions/node/$(nvm version)/bin:$PATH"

# =========================================================
# zinit 附加组件（对性能/功能的增强）
# =========================================================
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

# Starship（如果想改用 starship，把 P10k 注释掉并在下行取消注释）
# eval "$(starship init zsh)"
