# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random" 随机主题
ZSH_THEME="robbyrussell"
# ZSH_THEME="essembeh"
# ZSH_THEME="lukerandall"
# ZSH_THEME="maran"
# ZSH_THEME=""

# 按tab,区分大小写
# CASE_SENSITIVE="true"

# 按tab,区分连字符(比如-和_)
# HYPHEN_INSENSITIVE="true"

# 自动更新行为
# zstyle ':omz:update' mode disabled  # 禁用自动更新
# zstyle ':omz:update' mode auto      # 自动更新不询问
# zstyle ':omz:update' mode reminder  # 提醒用户更新

# 自动更新频率(按照天为单位)
# zstyle ':omz:update' frequency 13

# 如果在终端中粘贴 URL 或文本时出现问题，可以启用此选项来禁用某些魔术函数
# DISABLE_MAGIC_FUNCTIONS="true"

# 启用命令拼写错误时的自动校正功能
ENABLE_CORRECTION="true"

# 自定义插件目录
# ZSH_CUSTOM=/path/to/new-custom-folder

# 插件位于 $ZSH/plugins/ 和 $ZSH_CUSTOM/plugins/ 中
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# =====User configuration=====

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# fzf_config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# node.js (安装nvim的插件前要安装这个)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

