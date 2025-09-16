# 参考配置：https://github.com/codeopshq/dotfiles

# 使用P10k就把starship注释掉
# # 启用 Powerlevel10k 即时提示。应该保持在 ~/.zshrc 的顶部附近。
# # 可能需要控制台输入的初始化代码（密码提示、[y/n] 确认等）必须放在此块之上；其他所有内容可以放在下面。
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 设置我们想要存储 zinit 和插件的目录
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# 如果 Zinit 还不存在，则下载它
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
# 源码/加载 zinit
source "${ZINIT_HOME}/zinit.zsh"

# # 添加 Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# 加载补全系统
autoload -Uz compinit && compinit
# autoload -Uz compinit
# # 只在必要时重新生成补全缓存（每天一次）
# if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
#     compinit
# else
#     compinit -C
# fi

# 添加 OMZ 插件
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# 添加 zsh 插件 (按加载顺序优化)
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting

# 重新加载补全
zinit cdreplay -q

# # 要自定义提示符，请运行 `p10k configure` 或编辑 ~/.p10k.zsh。
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#######################################################
# ZSH 基础选项
#######################################################
# 按tab,区分大小写
# CASE_SENSITIVE="true"

# 按tab,区分连字符(比如-和_)
# HYPHEN_INSENSITIVE="true"

# 如果在终端中粘贴 URL 或文本时出现问题，可以启用此选项来禁用某些魔术函数
# DISABLE_MAGIC_FUNCTIONS="true"

# 显示命令执行时间（如果命令执行超过指定秒数）
# HIST_STAMPS="yyyy-mm-dd"

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
# ZSH 键绑定
#######################################################

bindkey -v
# bindkey '^p' history-search-backward
# bindkey '^n' history-search-forward
# bindkey '^[w' kill-region
# bindkey ' ' magic-space                           # 在空格上进行历史扩展
bindkey "^[[A" history-beginning-search-backward  # 使用上键搜索历史
bindkey "^[[B" history-beginning-search-forward   # 使用下键搜索历史

#######################################################
# 历史记录配置
#######################################################

HISTSIZE=10000
HISTFILE=~~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
# HISTSIZE=10000
# SAVEHIST=10000
# setopt HIST_IGNORE_DUPS          # 不记录重复命令
# setopt HIST_IGNORE_ALL_DUPS      # 删除旧的重复命令
# setopt HIST_SAVE_NO_DUPS         # 不保存重复命令
# setopt HIST_FIND_NO_DUPS         # 查找时不显示重复
# setopt HIST_IGNORE_SPACE         # 忽略以空格开头的命令
# setopt SHARE_HISTORY             # 多个终端共享历史

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
# zstyle ':completion:*:*:docker:*' option-stacking yes
# zstyle ':completion:*:*:docker-*:*' option-stacking yes

# 补全缓存
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# 补全分组
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'

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

# FZF 的别名
# 链接: https://github.com/junegunn/fzf
if [[ -x "$(command -v fzf)" ]]; then
    alias fzf='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
    # 模糊查找当前文件夹中的文件、预览并在编辑器中启动的别名
	if [[ -x "$(command -v xdg-open)" ]]; then
		alias preview='open $(fzf --info=inline --query="${@}")'
	else
		alias preview='edit $(fzf --info=inline --query="${@}")'
	fi
fi

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
# ZSH 语法高亮
#######################################################
[[ -f ~/.zsh/zsh-syntax-highlightin-tokyonight.zsh ]] && source ~/.zsh/zsh-syntax-highlightin-tokyonight.zsh

#######################################################
# Shell 集成
#######################################################

# 设置 fzf 键绑定和模糊补全
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# node.js (安装nvim的插件前要安装这个)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export PATH="$NVM_DIR/versions/node/$(nvm version)/bin:$PATH"

# 加载 zinit 附加组件以提升性能，没使用Turbo模式
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ==========starship配置==========
# eval "$(starship init zsh)"

