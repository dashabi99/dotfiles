# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# =====主题配置=====
# Set name of the theme to load --- if set to "random" 随机主题
ZSH_THEME="robbyrussell"
# ZSH_THEME="powerlevel10k/powerlevel10k"  # 推荐更强大的主题
# ZSH_THEME="essembeh"
# ZSH_THEME="lukerandall"
# ZSH_THEME="maran"

# =====基础配置=====
# 按tab,区分大小写
# CASE_SENSITIVE="true"

# 按tab,区分连字符(比如-和_)
# HYPHEN_INSENSITIVE="true"

# 命令拼写错误时,提示是否要校正(有点频繁了，给关掉)
# ENABLE_CORRECTION="true"

# 如果在终端中粘贴 URL 或文本时出现问题，可以启用此选项来禁用某些魔术函数
# DISABLE_MAGIC_FUNCTIONS="true"

# 显示命令执行时间（如果命令执行超过指定秒数）
HIST_STAMPS="yyyy-mm-dd"

# =====更新配置=====
# 自动更新行为
zstyle ':omz:update' mode reminder  # 提醒用户更新
# zstyle ':omz:update' mode auto      # 自动更新不询问
# zstyle ':omz:update' mode disabled  # 禁用自动更新

# 自动更新频率(按照天为单位)
zstyle ':omz:update' frequency 7

# =====历史记录配置=====
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS          # 不记录重复命令
setopt HIST_IGNORE_ALL_DUPS      # 删除旧的重复命令
setopt HIST_SAVE_NO_DUPS         # 不保存重复命令
setopt HIST_FIND_NO_DUPS         # 查找时不显示重复
setopt HIST_IGNORE_SPACE         # 忽略以空格开头的命令
setopt SHARE_HISTORY             # 多个终端共享历史

# =====插件配置=====
# 插件位于 $ZSH/plugins/ 和 $ZSH_CUSTOM/plugins/ 中
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    # 推荐添加的插件
    # web_search                    #  可以在终端打开浏览器搜索关键词
    # z                           # 快速跳转目录
    # extract                     # 万能解压缩
    # colored-man-pages          # 彩色 man 页面
    # command-not-found          # 命令未找到时的建议
    # sudo                       # 双击 ESC 添加 sudo
    # copypath                   # 复制当前路径
    # copyfile                   # 复制文件内容
    # aliases                   # 显示所有别名
    # docker                    # Docker 补全（如果你用 Docker）
    # docker-compose            # Docker Compose 补全
)

# 自定义插件目录
# ZSH_CUSTOM=/path/to/new-custom-folder

source $ZSH/oh-my-zsh.sh

# =====环境变量=====
# 编辑器配置
export EDITOR='nvim'
export VISUAL='nvim'

# 语言环境
# export LANG=en_US.UTF-8
# export LC_ALL=en_US.UTF-8
#
# 设置终端类型支持 256 色
# export TERM=xterm-256color
[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color

# =====路径配置=====
# 添加常用路径到 PATH
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# =====别名配置=====
# 系统别名
# alias ll='ls -lF'
# alias ls='ls -A'
# alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git 别名
# alias gs='git status'
# alias ga='git add'
# alias gc='git commit'
# alias gp='git push'
# alias gl='git pull'
# alias gco='git checkout'
# alias gb='git branch'
# alias gd='git diff'
# alias glog='git log --oneline --graph --decorate'

# 编辑器别名
alias vi='nvim'
# alias vim='nvim'
alias v='nvim'

# 系统工具别名
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias cls='clear'
# alias h='history'
# alias j='jobs'

# 目录操作
# alias md='mkdir -p'
# alias rd='rmdir'

# 网络工具
alias ping='ping -c 5'
# alias myip='curl http://ipecho.net/plain; echo'

# 配置文件快速编辑
# alias zshrc='nvim ~/.zshrc'
# alias nvimrc='nvim ~/.config/nvim'
# alias reload='source ~/.zshrc'

# =====第三方工具配置=====
# fzf_config (模糊查找工具)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# node.js (安装nvim的插件前要安装这个)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$NVM_DIR/versions/node/$(nvm version)/bin:$PATH"

# =====加载本地配置=====
# 加载本地特定配置（如果存在）
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# =====性能优化=====
# 禁用不需要的功能以提高性能
# unsetopt correct_all
# unsetopt share_history  # 同步窗口的命令

# echo "🚀 Zsh configuration loaded successfully!"
