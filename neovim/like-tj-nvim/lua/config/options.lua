-- ========== 编码设置 ==========
vim.g.encoding = "UTF-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "gbk", "gb2312", "cp936" } -- 支持中文编码检测

-- ========== 滚动和显示设置 ==========
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- ========== 行号设置 ==========
vim.opt.number = true
vim.opt.relativenumber = true

-- ========== 光标和列设置 ==========
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.signcolumn = "yes"
-- 可选：代码对齐线（按需启用）
-- vim.opt.colorcolumn = "80"

-- ========== 缩进设置 ==========
-- 修复：tabstop 和 shiftwidth 应该保持一致，否则会导致缩进混乱
vim.opt.tabstop = 4 -- tab 显示宽度
vim.opt.softtabstop = 4 -- 按下 tab 键时的宽度
vim.opt.shiftwidth = 4 -- 自动缩进宽度（改为4，与tabstop保持一致）
vim.opt.expandtab = true -- 用空格替代tab
vim.opt.autoindent = true -- 自动缩进
vim.opt.smartindent = true -- 智能缩进
vim.opt.shiftround = true -- 缩进取整到shiftwidth的倍数

-- ========== 搜索设置 ==========
vim.opt.ignorecase = true -- 搜索忽略大小写
vim.opt.smartcase = true -- 包含大写字母时精确匹配
vim.opt.hlsearch = false -- 不高亮搜索结果
vim.opt.incsearch = true -- 增量搜索

-- ========== 命令行和界面设置 ==========
vim.opt.cmdheight = 1 -- 命令行高度
vim.opt.showmode = true -- 隐藏模式提示（使用statusline显示）
vim.opt.showcmd = true -- 隐藏模式提示（使用statusline显示）
vim.opt.showtabline = 2 -- 始终显示标签行
vim.opt.pumheight = 15 -- 弹出菜单最大高度（增加到15，显示更多选项）

-- ========== 文件处理设置 ==========
vim.opt.autoread = true -- 自动读取外部修改
vim.opt.hidden = true -- 允许隐藏未保存的缓冲区

-- ========== 文本换行设置 ==========
vim.opt.wrap = true -- 自动换行
vim.opt.whichwrap:append("<,>,[,]") -- 行首行尾移动到上下行

-- ========== 鼠标和输入设备 ==========
vim.opt.mouse = "a" -- 启用鼠标支持

-- ========== 备份和交换文件 ==========
vim.opt.backup = false -- 禁用备份文件
vim.opt.writebackup = false -- 禁用写入备份
vim.opt.swapfile = false -- 禁用交换文件
-- 启用持久化撤销（推荐）
vim.opt.undofile = true -- 启用撤销文件
vim.opt.undolevels = 10000 -- 撤销级别

-- ========== 时间设置 ==========
vim.opt.updatetime = 250 -- 减少到250ms，提高响应速度
vim.opt.timeoutlen = 300 -- 减少按键超时时间

-- ========== 窗口分割 ==========
vim.opt.splitbelow = true -- 水平分割在下方
vim.opt.splitright = true -- 垂直分割在右方

-- ========== 颜色和外观 ==========
vim.opt.termguicolors = true -- 启用真彩色
vim.opt.fillchars:append({ eob = "~" }) -- 使没有用的行像原生vim一样显示~

-- ========== 不可见字符 ==========
-- vim.opt.list = false -- 默认不显示不可见字符
vim.opt.list = true -- 启用不可见字符显示
vim.opt.listchars = {
  -- space = "·", -- 注释掉以避免太多视觉干扰
  tab = "→ ", -- 制表符
  eol = "↲", -- 这会显示行尾的换行符
  trail = "␣", -- 行尾空格
  extends = "❯", -- 右侧截断标记
  precedes = "❮", -- 左侧截断标记
}

-- ========== 自动补全设置 ==========
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
vim.opt.wildmenu = true -- 增强命令行补全
vim.opt.shortmess:append("c") -- 避免补全消息干扰

-- ========== 剪贴板设置 ==========
vim.opt.clipboard = "unnamedplus" -- 使用系统剪贴板

-- ========== 文件管理器设置 ==========
vim.g.loaded_netrw = 1 -- 禁用netrw
vim.g.loaded_netrwPlugin = 1

-- ========== 编辑增强 ==========
vim.opt.virtualedit = "block" -- 块选择模式下自由移动
vim.opt.inccommand = "split" -- 实时预览替换效果
vim.opt.confirm = true -- 退出前确认未保存的更改

-- ========== 性能优化 ==========
vim.opt.lazyredraw = false -- 不延迟重绘（新版本nvim已优化）
vim.opt.ttyfast = true -- 快速终端连接
vim.opt.synmaxcol = 240 -- 限制语法高亮的列数，提高性能
