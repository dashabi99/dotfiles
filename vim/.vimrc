vim9script

# ============================================================
# 基本设置
# ============================================================

# 启用 Vim 扩展功能
set nocompatible

# 编码设置
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,latin1

# 显示行号
set number
# 显示相对行号
set norelativenumber
# 高亮当前行
set cursorline
# 显示光标位置
set ruler
# 设置窗口标题
set title
# 显示命令
set showcmd
# 显示模式
set showmode
# 始终显示状态栏
set laststatus=2
# 显示括号匹配
set showmatch
# 始终显示 Vim 左侧的“标志列”
# set signcolumn=yes

# 滚动设置
set scrolloff=5
set sidescrolloff=8

# 如果一行超过了屏幕显示就自动换行
set wrap
# 如果一行超过了屏幕显示就自动换行，但保留单词的完整性
set linebreak
# 换出来的第二行会跟着前面的缩进对齐
set breakindent

# 缩进设置
set tabstop=4
set shiftwidth=4
set softtabstop=4
# 把tab转换为空格
set expandtab
# 自动缩进
set autoindent
# 使用C风格缩进
set smartindent

# 退格键行为
set backspace=indent,eol,start

# 禁止响铃
set belloff=all
# 禁止闪烁
set novisualbell
# 禁止光标闪烁
set t_vb=
# 不启用鼠标支持
# set mouse=a

# 高亮搜索结果
set hlsearch
# 输入搜索内容时实时显示匹配结果
set incsearch
# 搜索时忽略大小写
set ignorecase
# 搜索时如果包含大写字母，则自动改为大小写敏感
set smartcase

# 启用命令行补全
set wildmenu
# 启用文件名补全
set wildmode=longest:full,full
# 启用文件名补全时忽略大小写
set wildignorecase

# 忽略文件类型
set wildignore+=*.o,*.obj,*.pyc,*.class
# 忽略文件
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.bmp
# 忽略目录
set wildignore+=*.zip,*.tar,*.gz,*.rar
# 忽略隐藏文件
set wildignore+=*/node_modules/*,*/.git/*

# 设置分割窗口时，光标会自动移动到新窗口
set splitbelow
set splitright
# 允许你在当前 buffer 有未保存修改时，切换到其他 buffer，而不强制你先保存或放弃修改
set hidden

# ============================================================
# 性能优化
# ============================================================
# 启用超时
set timeout
# 启用终端按键超时
set ttimeout
# 键序列超时时间（毫秒）
set timeoutlen=300
# 键码序列超时时间（毫秒）
set ttimeoutlen=100
set updatetime=300
set lazyredraw

# 使用系统剪贴板（需要 Vim 支持 +clipboard）,下面这两个哪个能用用哪个
# set clipboard=unnamedplus   
set clipboard=unnamed

set autoread
# 当你要执行可能丢失修改的操作时，Vim 会弹出确认选项，而不是直接报错
set confirm
# 不保留备份文件
set nobackup
# 写文件时不生成临时写入备份文件
set nowritebackup
# 不生成交换文件
set noswapfile

# 自动检测文件类型
filetype plugin indent on
# 启用文件类型插件
syntax enable

# ============================================================
# 内置代码补全
# ============================================================
set complete=.,w,b,u,t,i
set completeopt=menu,menuone,noselect
# 隐藏屏幕底部命令行区域那些烦人的补全提示信息
set shortmess+=c

# 补全菜单中 Tab / Shift-Tab 选择
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

# 回车确认补全
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

# Ctrl-Space 触发普通关键词补全
# inoremap <C-Space> <C-n>

# 定义自动触发补全的函数
def AutoComplete()
    # 如果补全菜单已经处于显示状态，则不重复触发
    if pumvisible()
        return
    endif

    # 获取当前光标所在的列号和当前行的内容
    var col = col('.')
    var line = getline('.')

    # 触发条件拦截：
    # 1. 如果光标在行首 (col <= 1)
    # 2. 或者光标前一个字符是空格 (\s)
    # 3. 或者光标前一个字符不是关键字字符 (\k，比如标点符号)
    # 满足以上任意条件，都不触发补全，避免干扰正常打字
    if col <= 1 || line[col - 2] =~ '\s' || line[col - 2] !~ '\k'
        return
    endif

    # 使用 feedkeys 模拟按下 <C-n>
    # 'i' 表示在插入模式中执行，'n' 表示不触发其他的按键映射
    feedkeys("\<C-n>", "in")
enddef

# 监听插入模式下的文本改变事件，自动调用该函数
augroup AutoCompleteGroup
    autocmd!
    # TextChangedI 意味着：在插入模式下，只要文本发生变化就会触发
    autocmd TextChangedI * AutoComplete()
augroup END

# ============================================================
# 颜色主题
# ============================================================

if has('termguicolors')
    set termguicolors
endif

set background=dark
colorscheme desert

# ============================================================
# Leader 键
# ============================================================

g:mapleader = ' '
g:maplocalleader = ' '

# ============================================================
# 按键映射
# ============================================================

# 插入模式下 jk 退出插入模式
inoremap jk <Esc>
# 命令行模式下 jk 取消命令
cnoremap jk <C-c>
# 普通模式下 vv 进入可视块模式
nnoremap vv <C-v>
# 清除搜索高亮
nnoremap <silent> <Leader>nh <ScriptCmd>nohlsearch<CR>

# ============================================================
# 窗口导航
# ============================================================

# 移动到左侧窗口
nnoremap <silent> <C-h> <C-w>h
# 移动到下方窗口
nnoremap <silent> <C-j> <C-w>j
# 移动到上方窗口
nnoremap <silent> <C-k> <C-w>k
# 移动到右侧窗口
nnoremap <silent> <C-l> <C-w>l

# 调整窗口大小
nnoremap <silent> <C-Up> <ScriptCmd>resize +2<CR>
nnoremap <silent> <C-Down> <ScriptCmd>resize -2<CR>
nnoremap <silent> <C-Left> <ScriptCmd>vertical resize -2<CR>
nnoremap <silent> <C-Right> <ScriptCmd>vertical resize +2<CR>

# ============================================================
# 标签页管理
# ============================================================

# 新建标签页
nnoremap <Leader>tn :tabnew<Space>
# 关闭当前标签页
nnoremap <silent> <Leader>tc <ScriptCmd>tabclose<CR>
# 上一个标签页
nnoremap <silent> <S-h> <ScriptCmd>tabprevious<CR>
# 下一个标签页
nnoremap <silent> <S-l> <ScriptCmd>tabnext<CR>

# ============================================================
# Buffer 管理
# ============================================================

# 查看 buffer 列表并输入 buffer 编号跳转
nnoremap <Leader>bb <ScriptCmd>buffers<CR>:buffer<Space>
# 删除当前 buffer
nnoremap <silent> <Leader>bd <ScriptCmd>bdelete<CR>
# 强制删除当前 buffer
# nnoremap <silent> <Leader>bD <ScriptCmd>bdelete!<CR>
# 上一个 buffer
nnoremap <silent> <Leader>bp <ScriptCmd>bprevious<CR>
# 下一个 buffer
nnoremap <silent> <Leader>bn <ScriptCmd>bnext<CR>

# ============================================================
# 自带的Ntree文件管理器
# ============================================================
# 隐藏顶部说明栏
g:netrw_banner = 0
# 树状显示
g:netrw_liststyle = 3
# 当前窗口打开文件
g:netrw_browse_split = 0
# netrw 预览窗口使用垂直分屏
g:netrw_preview = 1
# 垂直分屏时放到右侧
g:netrw_altv = 1
# netrw 尽量不要改变 Vim 的当前工作目录
g:netrw_keepdir = 1

# 打开当前文件所在目录
nnoremap <silent> <Leader>e :Explore .<CR>
# 快捷键
# |               左右分屏打开
# _               上下分屏打开
# K               预览
# Backspace       上一级目录
# -               回到当前工作目录
# n               新标签页打开
# Enter           打开文件 / 目录
# q               关闭
# x              外部打开
augroup netrw_oil_like_keymaps
    autocmd!
    autocmd FileType netrw nmap <buffer><silent> <Bar> v
    autocmd FileType netrw nmap <buffer><silent> _ o
    autocmd FileType netrw nmap <buffer><silent> K p
    autocmd FileType netrw nmap <buffer><silent> <BS> -
    autocmd FileType netrw nmap <buffer><silent> n t
    autocmd FileType netrw nnoremap <buffer><silent> q :<C-U>Rexplore<CR>
    autocmd FileType netrw nnoremap <buffer><silent> - <ScriptCmd>execute 'Explore ' .. fnameescape(getcwd())<CR>
augroup END

# ============================================================
# FZF files without plugin
# Optional: fd / rg / fzf 需要安装这些
# ============================================================
def FzfPsQuote(s: string): string
    return "'" .. substitute(s, "'", "''", 'g') .. "'"
enddef

def FzfFilesSource(): string
    if executable('fd')
        return 'fd --type f --hidden --follow --exclude .git'
    elseif executable('fdfind')
        return 'fdfind --type f --hidden --follow --exclude .git'
    elseif executable('rg')
        return "rg --files --hidden --follow -g '!.git'"
    elseif has('win32') || has('win64')
        return "Get-ChildItem -LiteralPath . -Recurse -File -Force -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch '\\.git\\' } | ForEach-Object { if ($_.FullName.StartsWith($pwdPath)) { $_.FullName.Substring($pwdPath.Length).TrimStart('\','/') } else { $_.FullName } }"
    else
        return 'find . -type f -not -path "*/.git/*" | sed "s#^\./##"'
    endif
enddef

def FzfFiles()
    if executable('fzf') == 0
        echohl ErrorMsg
        echom 'fzf not found. 请先安装 fzf，并确认 fzf.exe 在 PATH 里。'
        echohl None
        return
    endif

    var tmp = tempname()
    var origin_win = win_getid()
    var source = FzfFilesSource()

    var ps = ''

    ps ..= "[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new(); "
    ps ..= "$OutputEncoding = [Console]::OutputEncoding; "
    ps ..= "$pwdPath = (Get-Location).ProviderPath; "

    ps ..= "$result = @( "
    ps ..= source
    ps ..= " | fzf"
    ps ..= " --ansi"
    ps ..= " --layout=reverse"
    ps ..= " --border"
    ps ..= " --prompt 'Files> '"
    ps ..= " --expect=enter,ctrl-v,ctrl-x,ctrl-t"
    ps ..= " ); "

    ps ..= "[System.IO.File]::WriteAllLines("
    ps ..= FzfPsQuote(tmp)
    ps ..= ", [string[]]$result, [System.Text.UTF8Encoding]::new($false))"

    botright new
    resize 15

    var shell_cmd = 'powershell.exe'

    if executable('pwsh')
        shell_cmd = 'pwsh'
    endif

    term_start([shell_cmd, '-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', ps], {
        'curwin': v:true,
        'term_finish': 'close',
        'exit_cb': (job, status) => FzfFilesExit(tmp, origin_win, job, status)
    })

    startinsert
enddef

def FzfFilesExit(tmp: string, origin_win: number, job: any, status: number)
    timer_start(20, (_) => FzfFilesOpen(tmp, origin_win))
enddef

def FzfFilesOpen(tmp: string, origin_win: number)
    if filereadable(tmp) == 0
        return
    endif

    var lines = readfile(tmp)

    try
        delete(tmp)
    catch
    endtry

    if len(lines) < 2
        return
    endif

    var key = lines[0]
    var file = lines[1]

    file = substitute(file, '^\%ufeff', '', '')
    file = substitute(file, '^\.\\', '', '')
    file = substitute(file, '^\./', '', '')

    if empty(file)
        return
    endif

    if win_id2win(origin_win) > 0
        win_gotoid(origin_win)
    endif

    file = fnameescape(file)

    execute 'edit ' .. file
enddef

command! FzfFiles call FzfFiles()

nnoremap <silent> ff :<C-U>FzfFiles<CR>


# ============================================================
# 可视模式增强
# ============================================================

# 左右缩进后保持选区
vnoremap < <gv
vnoremap > >gv

# 上下移动选中文本
vnoremap J <ScriptCmd>move '>+1<CR>gv=gv
vnoremap K <ScriptCmd>move '<-2<CR>gv=gv

# ============================================================
# 编辑体验优化
# ============================================================

# 普通模式下 Y 复制到行尾
nnoremap Y y$
# Ctrl-a 全选
nnoremap <C-a> ggVG

# ============================================================
# 自动命令 Vim9script 函数
# ============================================================
def RestoreCursorPosition()
    var lastPos = line("'\"")

    if lastPos > 1 && lastPos <= line('$')
        execute 'normal! g`"'
    endif
enddef

def DisableAutoComment()
    setlocal formatoptions-=c
    setlocal formatoptions-=r
    setlocal formatoptions-=o
enddef

augroup my_vimrc
    autocmd!
    # 返回上次编辑位置
    autocmd BufReadPost * RestoreCursorPosition()
    # 关闭自动注释续行
    autocmd FileType * DisableAutoComment()
    # Python 使用 4 空格
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    # HTML/CSS/JS/JSON/YAML 使用 2 空格
    autocmd FileType html,css,javascript,json,yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
augroup END

# 重载 .vimrc 以应用更改
# 执行 :source ~/.vimrc 后重启 Vim
