" 基本设置
set number              " 显示行号
set relativenumber      " 显示相对行号
set scrolloff=5         " 永远显示最下面5行
set cursorline          " 高亮当前行

set ruler               " 显示光标位置
set title               " 设置窗口标题
set tabstop=4           " tab为4个空格
set shiftwidth=4        " 每一级缩进长度为4个空格
set expandtab           " 把tab转换为空格
set autoindent          " 自动缩进
set smartindent         " 智能缩进
set belloff=all         " 禁止响铃
set wrap                " 如果一行超过了屏幕显示就自动换行
set linebreak           " 换行时不截断单词

set nocompatible        " 启用 Vim 扩展功能
syntax on               " 打开语法高亮
set hlsearch            " 搜索高亮
set incsearch           " 增量搜索
set ignorecase          " 忽略大小写
set smartcase           " 在搜索模式中智能处理大小写
set background=dark     " 使用暗色背景
set wildmenu            " 启用命令补全菜单
set showmode            " 显示模式
set showcmd          " 显示命令
"set mouse=a          " 启用鼠标支持
set backspace=indent,eol,start " 修复退格键行为
set clipboard=unnamedplus   " 使用系统剪贴板（需要 Vim 支持 +clipboard）

" 编码设置
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936

" ========== 性能优化 - 修复按键延迟 ==========
set timeout           " 启用超时
set ttimeout          " 启用终端按键超时
set timeoutlen=300    " 键序列超时时间（毫秒）
set ttimeoutlen=50    " 键码序列超时时间（毫秒）
                      " 注意：-1 会导致使用timeoutlen的值，造成延迟

" 按键映射
let mapleader = " "      " 设置 <Leader> 键为空格建
inoremap jk <esc>       " 将 'jk' 映射为 'esc'
cnoremap jk <c-c>       " 命令行模式下 'jk' 映射为 'c-c'
" 命令行中按 '空格+b' 打开缓冲区列表
cnoremap <Leader>b :buffers<cr>:b<space>
nnoremap <C-h> <C-w>h     " 窗口导航：左
nnoremap <C-j> <C-w>j     " 窗口导航：下
nnoremap <C-k> <C-w>k     " 窗口导航：上
nnoremap <C-l> <C-w>l     " 窗口导航：右
nnoremap <C-Up>    :resize +2<CR>
nnoremap <C-Down>  :resize -2<CR>
nnoremap <C-Left>  :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>
nnoremap <Leader>nh :nohl<CR> " 清除搜索高亮

" 文件检测
filetype on          " 启用文件类型检测
filetype plugin on      " 启用文件类型插件
filetype indent on      " 启用文件类型缩进

" 主题和颜色
set termguicolors       " 启用真彩色（需要终端支持）
colorscheme desert      " 默认主题（可替换为插件主题）


" Vim 9.1 特性（可选）
" 如果你想尝试一些 Vim 9.1 的新特性，可以查看更新日志，并根据需要添加到配置中。

" 重载 .vimrc 以应用更改
" 执行 :source ~/.vimrc 后重启 Vim
