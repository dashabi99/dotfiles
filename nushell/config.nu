# Nushell config for Windows
# 查看路径:
# $nu.config-path
# $nu.env-path
#
# 编辑:
# vim $nu.config-path
# vim $nu.env-path

$env.config = {
    # show_banner: false
    show_banner: true

    edit_mode: emacs
    bracketed_paste: true
    use_ansi_coloring: true
    error_style: "fancy"
    highlight_resolved_externals: true

    history: {
        max_size: 100000
        sync_on_enter: true
        file_format: sqlite
        isolation: false
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
        external: {
            enable: true
            max_results: 100
        }
    }

    table: {
        mode: rounded
        index_mode: auto
        show_empty: true
        padding: {
            left: 1
            right: 1
        }
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
        }
    }

    ls: {
        use_ls_colors: true
        clickable_links: true
    }

    rm: {
        always_trash: false
    }

    footer_mode: auto
    float_precision: 2

    shell_integration: {
        osc2: true
        osc7: true
        osc8: true
        osc9_9: false
        osc133: true
        osc633: true
        reset_application_mode: true
    }

    hooks: {
        pre_prompt: []
        pre_execution: []
        env_change: {
            PWD: []
        }
        display_output: "if (term size).columns >= 100 { table -e } else { table }"
        command_not_found: { |cmd|
            print $"Command not found: ($cmd)"
        }
    }

    menus: [
        {
            name: completion_menu
            only_buffer_difference: false
            marker: "| "
            type: {
                layout: columnar
                columns: 4
                col_width: 20
                col_padding: 2
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
        {
            name: history_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: list
                page_size: 20
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
    ]

    keybindings: [
        # Tab: 菜单补全，类似 PowerShell 的 MenuComplete
        {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menu name: completion_menu }
                    { send: menunext }
                ]
            }
        }

        # Ctrl+r: 历史记录搜索，类似 PSFzf ReverseHistory
        {
            name: history_menu
            modifier: control
            keycode: char_r
            mode: [emacs vi_normal vi_insert]
            event: { send: menu name: history_menu }
        }

        # Ctrl+f: 使用 fzf 选择文件并插入命令行
        {
            name: fzf_file_widget
            modifier: control
            keycode: char_f
            mode: [emacs vi_normal vi_insert]
            event: {
                send: executehostcommand
                cmd: "fzf-file-widget"
            }
        }

        # Ctrl+p: 历史向上搜索
        {
            name: history_or_menu_previous
            modifier: control
            keycode: char_p
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menuprevious }
                    { send: up }
                ]
            }
        }

        # Ctrl+n: 菜单/历史向下
        {
            name: history_or_menu_next
            modifier: control
            keycode: char_n
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menunext }
                    { send: down }
                ]
            }
        }

        # Ctrl+a: 行首
        {
            name: beginning_of_line
            modifier: control
            keycode: char_a
            mode: [emacs vi_normal vi_insert]
            event: { edit: movetolinestart }
        }

        # Ctrl+e: 行尾
        {
            name: end_of_line
            modifier: control
            keycode: char_e
            mode: [emacs vi_normal vi_insert]
            event: { edit: movetolineend }
        }

        # Ctrl+z: 撤销
        {
            name: undo
            modifier: control
            keycode: char_z
            mode: [emacs vi_normal vi_insert]
            event: { edit: undo }
        }
    ]
}

# starship 命令行美化
let autoload = ($nu.data-dir | path join "vendor/autoload")
mkdir $autoload
starship init nu | save --force ($autoload | path join "starship.nu")


# o 打开文件管理器/文件
def o [path: path = "."] {
    ^explorer.exe ($path | path expand)
}


# 常用别名
alias ll = ls -la
alias la = ls -a
alias cat = open --raw

alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..

# alias g = git
# alias gs = git status
# alias ga = git add
# alias gc = git commit
# alias gcm = git commit -m
# alias gp = git push
# alias gl = git log --oneline --graph --decorate -n 20
# alias gd = git diff

# fzf 文件选择，类似 PSFzf 的 Ctrl+f provider
def fzf-file-widget [] {
    if (which fzf | is-empty) {
        print --stderr "fzf not found"
        print --stderr "Install: winget install junegunn.fzf"
        return
    }

    let fzf_args = [
        "--height=40%"
        "--min-height=10"
        "--layout=reverse"
        "--border=rounded"
        "--cycle"
        # "--select-1"
        "--exit-0"
        "--prompt=Files> "
    ]

    let selected = if (which fd | is-not-empty) {
        ^fd --type=file --hidden --follow --exclude=.git
        | ^fzf ...$fzf_args
        | str trim
    } else {
        ls **/*
        | where type == file
        | get name
        | each { path expand }
        | to text
        | ^fzf ...$fzf_args
        | str trim
    }

    if ($selected | is-not-empty) {
        # 转成合法的 Nushell 字符串，确保带空格或特殊字符的
        # Windows 路径能够正常插入命令行
        commandline edit --insert ($selected | to nuon)
    }
}

def --env yy [...args] {
    if (which yazi | is-empty) {
        print --stderr "yazi not found; install it with: winget install sxyazi.yazi"
        return
    }

    let tmp = (mktemp -t "yazi-cwd.XXXXXX")

    ^yazi ...$args --cwd-file $tmp

    let cwd = try {
        open --raw $tmp | str trim
    } catch {
        ""
    }

    rm --force --permanent $tmp

    if (
        ($cwd | is-not-empty)
        and ($cwd != $env.PWD)
        and ($cwd | path exists)
    ) {
        cd $cwd
    }
}
