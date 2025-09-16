## 注释
ZSH_HIGHLIGHT_STYLES[comment]='fg=#565f89'
## 常量
## 函数/方法
ZSH_HIGHLIGHT_STYLES[alias]='fg=#7aa2f7'                    # 别名 - 蓝色
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#7aa2f7',underline   # 后缀别名 - 蓝色下划线
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#7aa2f7',bold        # 全局别名 - 蓝色粗体
ZSH_HIGHLIGHT_STYLES[function]='fg=#7aa2f7'                 # 自定义函数 - 蓝色
ZSH_HIGHLIGHT_STYLES[command]='fg=#7aa2f7'                  # 外部命令 - 蓝色
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#7aa2f7,italic'        # 前置命令（如 sudo, time） - 蓝色斜体
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#ff9e64,italic,bold' # 自动目录（直接输入路径） - 橙色斜体粗体
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#ff9e64'     # 单短横线选项（-l, -a） - 橙色
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#ff9e64'     # 双短横线选项（--help, --version） - 橙色
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#bb9af7'     # 反引号命令替换（`command`） - 紫色
## 关键字
## 内置命令
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#7dcfff',bold             # Shell内置命令（cd, echo） - 青色粗体
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#7dcfff',bold       # 保留字（if, for, while） - 青色粗体
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#7dcfff',bold      # 哈希命令 - 青色粗体
## 标点符号
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f7768e'         # 命令分隔符（&&, ||, ;） - 红色
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#c0caf5'           # 命令替换分隔符（$()的括号） - 浅蓝色
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#c0caf5'  # 无引号命令替换分隔符 - 浅蓝色
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#c0caf5'           # 进程替换分隔符（<(), >()） - 浅蓝色
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#f7768e'           # 反引号分隔符 - 红色
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#f7768e'              # 反向双引号参数 - 红色
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#f7768e'              # 反向美元引号参数 - 红色
## 可序列化/配置语言
## 存储
## 字符串
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#9ece6a'              # 引号内命令替换 - 绿色
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#9ece6a'    # 引号内命令替换分隔符 - 绿色
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#9ece6a'                   # 单引号字符串 - 绿色
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#f7768e'          # 未闭合单引号字符串 - 红色（错误）
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#9ece6a'                   # 双引号字符串 - 绿色
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#f7768e'          # 未闭合双引号字符串 - 红色（错误）
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#9ece6a'                                 # RC引用风格 - 绿色
## 变量
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#c0caf5'                   # 美元引号参数（$'...'） - 浅蓝色
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#f7768e'          # 未闭合美元引号 - 红色（错误）
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#c0caf5'            # 双引号内美元参数 - 浅蓝色
ZSH_HIGHLIGHT_STYLES[assign]='fg=#c0caf5'                                   # 变量赋值（VAR=value） - 浅蓝色
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#c0caf5'                                 # 命名文件描述符 - 浅蓝色
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#c0caf5'                               # 数字文件描述符 - 浅蓝色
## 规范中无相关类别
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e'                            # 未知标记 - 红色（错误）
ZSH_HIGHLIGHT_STYLES[path]='fg=#c0caf5',bold                                # 文件路径 - 浅蓝色粗体
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#f7768e'                       # 路径分隔符（/） - 红色
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#c0caf5'                              # 路径前缀 - 浅蓝色
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#f7768e'                # 路径前缀分隔符 - 红色
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#c0caf5'                                 # 通配符（*, ?, []） - 浅蓝色
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#bb9af7'                        # 历史扩展（!!, !n） - 紫色
#ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'                          # 命令替换 - 未定义
#ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'                 # 无引号命令替换 - 未定义
#ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'                          # 进程替换 - 未定义
#ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'                          # 算术扩展 - 未定义
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#f7768e'            # 未闭合反引号 - 红色（错误）
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#c0caf5'                              # 重定向操作符（>, <, >>） - 浅蓝色
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#c0caf5'                                     # 第一个参数 - 浅蓝色
ZSH_HIGHLIGHT_STYLES[default]='fg=#c0caf5'                                  # 默认文本颜色 - 浅蓝色
ZSH_HIGHLIGHT_STYLES[cursor]='standout'                                     # 光标高亮 - 反色显示
