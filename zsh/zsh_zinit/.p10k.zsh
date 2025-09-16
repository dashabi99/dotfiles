# 由 Powerlevel10k 配置向导生成于 2024-06-09 03:55 EAT。
# 基于 romkatv/powerlevel10k/config/p10k-pure.zsh，校验和 07533。
# 向导选项: nerdfont-v3 + powerline, 大图标, pure 风格, 原始, 右提示符,
# 2 行, 稀疏, 瞬态提示符, 即时提示符=详细。
# 输入 `p10k configure` 生成另一个配置。
#
# Powerlevel10k 配置文件，采用 Pure 风格 (https://github.com/sindresorhus/pure)。
#
# 与 Pure 的区别:
#
#   - Git:
#     - 在分离 HEAD 状态时显示 `@c4d3ec2c` 而不是类似 `v1.4.0~11` 的内容。
#     - 没有自动 `git fetch`（与设置 `PURE_GIT_PULL=0` 的 Pure 相同）。
#
# 除了上面列出的区别外，Pure 提示符的复制是完全精确的。这甚至包括
# 有争议的部分。例如，就像在 Pure 中一样，没有 Git 状态陈旧的指示；
# 在命令、可视和覆写 vi 模式中提示符号是相同的；当提示符不适合一行时，
# 它会换行而不尝试缩短它。
#
# 如果你喜欢 Pure 的总体风格但不特别喜欢它的所有怪癖，输入
# `p10k configure` 并选择 "Lean" 风格。这将给你一个简洁的极简主义提示符，
# 同时利用 Pure 中没有的 Powerlevel10k 功能。

# 临时更改选项。
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # 取消设置所有配置选项。
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # 需要 Zsh >= 5.1。
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  # 提示符颜色定义。
  local grey='242'      # 灰色
  local red='1'         # 红色
  local yellow='3'      # 黄色
  local blue='4'        # 蓝色
  local magenta='5'     # 洋红色
  local cyan='6'        # 青色
  local white='7'       # 白色

  # 左侧提示符段。
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # =========================[ 第 1 行 ]=========================
    # context                 # 用户@主机名
    dir                       # 当前目录
    vcs                       # git 状态
    # command_execution_time  # 上一个命令持续时间
    # =========================[ 第 2 行 ]=========================
    newline                   # 换行符 \n
    # virtualenv              # python 虚拟环境
    prompt_char               # 提示符符号
  )

  # 右侧提示符段。
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    # =========================[ 第 1 行 ]=========================
    command_execution_time    # 上一个命令持续时间
    virtualenv                # python 虚拟环境
    context                   # 用户@主机名
    # time                    # 当前时间
    # =========================[ 第 2 行 ]=========================
    newline                   # 换行符 \n
  )

  # 定义整体提示符外观的基本样式选项。
  typeset -g POWERLEVEL9K_BACKGROUND=                            # 透明背景
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # 没有周围的空白
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # 用空格分隔段
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # 没有行尾符号
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=           # 没有段图标

  # 在每个提示符前添加空行，除了第一个。这不会模拟 Pure 中的错误，
  # 即每当你使用 fzf 或类似工具的 Alt-C 绑定时，提示符会向下漂移。
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  # 如果上一个命令成功，提示符符号为洋红色。
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS}_FOREGROUND=$magenta
  # 如果上一个命令失败，提示符符号为红色。
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS}_FOREGROUND=$red
  # 默认提示符符号。
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  # 命令 vi 模式下的提示符符号。
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  # 可视 vi 模式下的提示符符号与命令模式相同。
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='❮'
  # 覆写 vi 模式下的提示符符号与命令模式相同。
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false

  # 灰色 Python 虚拟环境。
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$grey
  # 不显示 Python 版本。
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

  # 蓝色当前目录。
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$blue

  # root 用户时的上下文格式: user@host。第一部分白色，其余灰色。
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE="%F{$white}%n%f%F{$grey}@%m%f"
  # 非 root 用户时的上下文格式: user@host。整个内容灰色。
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE="%F{$grey}%n@%m%f"
  # 除非是 root 用户或在 SSH 中，否则不显示上下文。
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_CONTENT_EXPANSION=

  # 只有当上一个命令持续时间 >= 5秒时才显示。
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
  # 不显示小数秒。因此显示 7s 而不是 7.3s。
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  # 持续时间格式: 1d 2h 3m 4s。
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  # 黄色上一个命令持续时间。
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$yellow

  # 灰色 Git 提示符。这使得陈旧的提示符与最新的提示符无法区分。
  typeset -g POWERLEVEL9K_VCS_FOREGROUND=$grey

  # 禁用异步加载指示器，使不是 Git 仓库的目录
  # 与状态未知的大型 Git 仓库无法区分。
  typeset -g POWERLEVEL9K_VCS_LOADING_TEXT=

  # 即使一毫秒也不等待 Git 状态，这样当 Git 状态改变时
  # 提示符总是异步更新。
  typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=0

  # 青色前进/落后箭头。
  typeset -g POWERLEVEL9K_VCS_{INCOMING,OUTGOING}_CHANGESFORMAT_FOREGROUND=$cyan
  # 不显示远程分支、当前标签或存储。
  typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind)
  # 不显示分支图标。
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  # 当处于分离 HEAD 状态时，在通常显示分支的位置显示 @commit。
  typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='@'
  # 不显示暂存、未暂存、未跟踪指示器。
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED}_ICON=
  # 当有暂存、未暂存或未跟踪文件时显示 '*'。
  typeset -g POWERLEVEL9K_VCS_DIRTY_ICON='*'
  # 如果本地分支落后于远程分支，显示 '⇣'。
  typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=':⇣'
  # 如果本地分支领先于远程分支，显示 '⇡'。
  typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=':⇡'
  # 不在前进/落后箭头旁边显示提交数量。
  typeset -g POWERLEVEL9K_VCS_{COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=1
  # 移除 '⇣' 和 '⇡' 之间的空格以及所有尾随空格。
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${${${P9K_CONTENT/⇣* :⇡/⇣⇡}// }//:/ }'

  # 灰色当前时间。
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$grey
  # 当前时间的格式: 09:51:02。参见 `man 3 strftime`。
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  # 如果设置为 true，当你按回车时时间会更新。这样过去
  # 命令的提示符将包含其命令的开始时间而不是其前面
  # 命令的结束时间。
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false

  # 瞬态提示符的工作方式类似于内置的 transient_rprompt 选项。它在
  # 接受命令行时修剪提示符。支持的值:
  #
  #   - off:      接受命令行时不更改提示符。
  #   - always:   接受命令行时修剪提示符。
  #   - same-dir: 接受命令行时修剪提示符，除非这是更改当前
  #               工作目录后输入的第一个命令。
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

  # 即时提示符模式。
  #
  #   - off:     禁用即时提示符。如果你尝试过即时提示符并发现
  #              它与你的 zsh 配置文件不兼容，请选择此选项。
  #   - quiet:   启用即时提示符，在 zsh 初始化期间检测到控制台输出时
  #              不打印警告。如果你已经阅读并理解了
  #              https://github.com/romkatv/powerlevel10k#instant-prompt，请选择此选项。
  #   - verbose: 启用即时提示符，在 zsh 初始化期间检测到控制台输出时
  #              打印警告。如果你从未尝试过即时提示符、没有看到过警告，
  #              或者不确定这一切意味着什么，请选择此选项。
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # 热重载允许你在 Powerlevel10k 初始化后更改 POWERLEVEL9K 选项。
  # 例如，你可以输入 POWERLEVEL9K_BACKGROUND=red 并看到你的提示符变红。
  # 热重载可能会使提示符慢 1-2 毫秒，所以除非你真的需要它，
  # 最好保持关闭状态。
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # 如果 p10k 已经加载，重新加载配置。
  # 即使 POWERLEVEL9K_DISABLE_HOT_RELOAD=true 这也会工作。
  (( ! $+functions[p10k] )) || p10k reload
}

# 告诉 `p10k configure` 它应该覆盖哪个文件。
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
