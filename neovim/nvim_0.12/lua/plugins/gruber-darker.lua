-- gruber-darker.lua
-- 基于 Jason R. Blevins 和 Alexey Kutepov 的 Emacs 主题

local M = {} -- 定义模块表

-- 1. 颜色定义 (调色板)
local c = {
    fg        = "#e4e4ef", -- 前景色 (普通文本)
    fg_p1     = "#f4f4ff", -- 前景色+1 (高亮变量名)
    fg_p2     = "#f5f5f5", -- 前景色+2 (搜索背景)
    white     = "#ffffff", -- 纯白
    black     = "#000000", -- 纯黑
    bg_m1     = "#101010", -- 背景色-1 (更深，用于侧边栏或浮动窗)
    bg        = "#181818", -- 核心背景色 (编辑器主背景)
    bg_p1     = "#282828", -- 背景色+1 (当前行，选区背景)
    bg_p2     = "#453d41", -- 背景色+2 (边框，非活动元素)
    bg_p3     = "#484848", -- 背景色+3 (视觉模式选区)
    bg_p4     = "#52494e", -- 背景色+4 (行号，匹配括号)
    red_m1    = "#c73c3f", -- 红色-1 (深红)
    red       = "#f43841", -- 红色 (错误，删除)
    red_p1    = "#ff4f58", -- 红色+1 (鲜红)
    green     = "#73c936", -- 绿色 (字符串，成功信息，添加)
    yellow    = "#ffdd33", -- 黄色 (关键字，当前行号)
    brown     = "#cc8c3c", -- 褐色 (注释)
    quartz    = "#95a99f", -- 石英色 (青色，用于常量，类型)
    niagara_2 = "#303540", -- 尼亚加拉蓝-2 (深蓝背景)
    niagara_1 = "#565f73", -- 尼亚加拉蓝-1
    niagara   = "#96a6c8", -- 尼亚加拉蓝 (函数名，链接)
    wisteria  = "#9e95c7", -- 紫藤色 (数字，已访问链接)
    none      = "NONE",    -- 无颜色 (用于透传背景)
}

-- 2. 辅助函数：设置高亮组
-- group: 高亮组名称, opts: 样式选项表
local function highlight(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- 3. 主设置函数
function M.setup()
    -- 设置主题名称变量
    vim.g.colors_name = "gruber-darker"

    -- 定义高亮组配置表
    local groups = {
        -- =======================================================
        -- 基础编辑器界面 (Editor UI)
        -- =======================================================
        Normal                   = { fg = c.fg, bg = c.bg },                        -- 普通文本和主背景
        NormalFloat              = { fg = c.fg, bg = c.bg_m1 },                     -- 浮动窗口使用更深的背景 (bg-1)
        FloatBorder              = { fg = c.bg_p2, bg = c.bg_m1 },                  -- 浮动窗口边框
        Cursor                   = { fg = c.bg, bg = c.yellow },                    -- 光标：黄色背景，黑色文字
        CursorLine               = { bg = c.bg_p1 },                                -- 当前行高亮：bg+1
        CursorColumn             = { bg = c.bg_p1 },                                -- 当前列高亮
        LineNr                   = { fg = c.bg_p4 },                                -- 行号：暗淡的灰色 (bg+4)
        CursorLineNr             = { fg = c.yellow, bold = true },                  -- 当前行号：黄色加粗
        VertSplit                = { fg = c.bg_p2, bg = c.none },                   -- 垂直分割线
        WinSeparator             = { fg = c.bg_p2, bg = c.none },                   -- 窗口分割线
        SignColumn               = { bg = c.bg },                                   -- 标记列 (如git状态条) 背景同主背景
        Pmenu                    = { fg = c.fg, bg = c.bg_p1 },                     -- 补全菜单背景
        PmenuSel                 = { fg = c.white, bg = c.niagara_2, bold = true }, -- 补全菜单选中项
        StatusLine               = { fg = c.white, bg = c.bg_p1 },                  -- 状态栏 (活动)
        StatusLineNC             = { fg = c.quartz, bg = c.bg_m1 },                 -- 状态(非活动)
        Visual                   = { bg = c.bg_p3 },                                -- 视觉模式选区 (bg+3)
        Search                   = { fg = c.black, bg = c.fg_p2 },                  -- 搜索结果：浅色背景黑字 (Emacs: isearch)
        IncSearch                = { fg = c.black, bg = c.yellow },                 -- 增量搜索：黄色背景黑字
        MatchParen               = { fg = c.bg_m1, bg = c.wisteria },               -- 括号匹配背景
        TabLine                  = { bg = c.bg_p1, fg = c.niagara },                -- 未选中的 Tab
        TabLineFill              = { bg = c.bg_m1 },                                -- Tab 栏空白背景
        TabLineSel               = { fg = c.yellow, bg = c.bg, bold = true },       -- 选中的 Tab (黄色)

        -- =======================================================
        -- 语法高亮 (Syntax Highlighting)
        -- =======================================================
        Comment                  = { fg = c.niagara_1, italic = true },  -- 注释：褐色斜体
        Constant                 = { fg = c.quartz },                    -- 常量：青色
        String                   = { fg = c.green },                     -- 字符串：绿色
        Character                = { fg = c.green },                     -- 字符：绿色
        Number                   = { fg = c.wisteria },                  -- 数字：紫色 (Emacs: agda2-number)
        Boolean                  = { fg = c.yellow, bold = true },       -- 布尔值：黄色加粗
        Float                    = { fg = c.wisteria },                  -- 浮点数：紫色
        Identifier               = { fg = c.fg_p1 },                     -- 变量名：稍亮的白色
        Function                 = { fg = c.niagara },                   -- 函数名：蓝色
        Statement                = { fg = c.yellow, bold = true },       -- 语句 (if, for)：黄色加粗
        Conditional              = { fg = c.yellow, bold = true },       -- 条件判断：黄色加粗
        Repeat                   = { fg = c.yellow, bold = true },       -- 循环：黄色加粗
        Label                    = { fg = c.yellow },                    -- 标签：黄色
        Operator                 = { fg = c.fg },                        -- 运算符：普通前景色
        Keyword                  = { fg = c.yellow, bold = true },       -- 关键字：黄色加粗
        Exception                = { fg = c.red },                       -- 异常：红色
        PreProc                  = { fg = c.quartz },                    -- 预处理指令：青色
        Type                     = { fg = c.quartz },                    -- 类型定义：青色
        Special                  = { fg = c.yellow },                    -- 特殊字符：黄色
        Underlined               = { fg = c.niagara, underline = true }, -- 下划线 (链接)
        Error                    = { fg = c.red },                       -- 错误
        Todo                     = { fg = c.brown, bold = true },        -- TODO 标签

        -- =======================================================
        -- 目录与文件 (Directory & Files)
        -- 用于 Oil.nvim 和 Netrw
        -- =======================================================
        Directory                = { fg = c.niagara, bold = true }, -- 目录：蓝色加粗 (Emacs: dired-directory)

        -- =======================================================
        -- Oil.nvim 专属适配
        -- =======================================================
        OilDir                   = { link = "Directory" },                -- 文件夹使用 Directory 组
        OilDirIcon               = { fg = c.brown },                      -- 文件夹图标：褐色
        OilFile                  = { fg = c.fg },                         -- 普通文件：前景色
        OilLink                  = { fg = c.wisteria, underline = true }, -- 软链接：紫色下划线
        OilSocket                = { fg = c.red },                        -- Socket 文件：红色

        -- =======================================================
        -- Snacks.picker 专属适配 (替代 Telescope)
        -- 模拟 Emacs Helm/Ido 风格
        -- =======================================================
        SnacksPicker             = { fg = c.fg, bg = c.bg_m1 },     -- Picker 主窗口：深色背景
        SnacksPickerBorder       = { fg = c.bg_p2, bg = c.bg_m1 },  -- Picker 边框
        SnacksPickerInput        = { fg = c.fg, bg = c.bg },        -- 输入框：编辑器背景
        SnacksPickerList         = { fg = c.fg, bg = c.bg_m1 },     -- 列表区域
        SnacksPickerMatch        = { fg = c.yellow, bold = true },  -- 匹配字符：黄色加粗 (Emacs: ido-first-match)
        SnacksPickerSelected     = { bg = c.bg_p1, bold = true },   -- 选中行：bg+1 高亮
        SnacksPickerPreview      = { bg = c.bg_m1 },                -- 预览窗口背景
        SnacksPickerTitle        = { fg = c.niagara, bold = true }, -- 标题颜色

        -- =======================================================
        -- Git 符号 (Gitsigns / Diff)
        -- =======================================================
        DiffAdd                  = { fg = c.green, bg = c.none },  -- Diff 添加
        DiffChange               = { fg = c.yellow, bg = c.none }, -- Diff 修改
        DiffDelete               = { fg = c.red, bg = c.none },    -- Diff 删除
        DiffText                 = { fg = c.bg, bg = c.yellow },   -- Diff 文本变化背景

        GitSignsAdd              = { fg = c.green },               -- 左侧 Git 绿条
        GitSignsChange           = { fg = c.yellow },              -- 左侧 Git 黄条
        GitSignsDelete           = { fg = c.red },                 -- 左侧 Git 红条

        -- =======================================================
        -- 代码诊断 (LSP Diagnostics)
        -- =======================================================
        DiagnosticError          = { fg = c.red },                      -- 错误
        DiagnosticWarn           = { fg = c.yellow },                   -- 警告
        DiagnosticInfo           = { fg = c.green },                    -- 信息
        DiagnosticHint           = { fg = c.quartz },                   -- 提示
        DiagnosticUnderlineError = { sp = c.red, underline = true },    -- 错误下划线
        DiagnosticUnderlineWarn  = { sp = c.yellow, underline = true }, -- 警告下划线

        -- =======================================================
        -- TreeSitter (现代语法分析)
        -- 将 TS 节点映射到上面的标准组
        -- =======================================================
        ["@comment"]             = { link = "Comment" },           -- TS 注释
        ["@string"]              = { link = "String" },            -- TS 字符串
        ["@string.regex"]        = { fg = c.green },               -- 正则表达式
        ["@number"]              = { link = "Number" },            -- TS 数字
        ["@boolean"]             = { link = "Boolean" },           -- TS 布尔值
        ["@float"]               = { link = "Float" },             -- TS 浮点数
        ["@function"]            = { link = "Function" },          -- TS 函数
        ["@function.builtin"]    = { fg = c.yellow },              -- 内置函数：黄色 (Emacs: font-lock-builtin-face)
        ["@function.macro"]      = { link = "PreProc" },           -- 宏
        ["@parameter"]           = { fg = c.fg },                  -- 参数：普通色
        ["@method"]              = { link = "Function" },          -- 方法
        ["@field"]               = { fg = c.fg },                  -- 字段
        ["@property"]            = { fg = c.fg },                  -- 属性
        ["@constructor"]         = { fg = c.quartz },              -- 构造函数：青色
        ["@conditional"]         = { link = "Conditional" },       -- TS 条件
        ["@repeat"]              = { link = "Repeat" },            -- TS 循环
        ["@label"]               = { link = "Label" },             -- TS 标签
        ["@keyword"]             = { link = "Keyword" },           -- TS 关键字
        ["@keyword.function"]    = { fg = c.yellow, bold = true }, -- function 关键字
        ["@operator"]            = { link = "Operator" },          -- TS 运算符
        ["@exception"]           = { link = "Exception" },         -- TS 异常
        ["@type"]                = { link = "Type" },              -- TS 类型
        ["@type.builtin"]        = { fg = c.quartz },              -- 内置类型
        ["@structure"]           = { link = "Type" },              -- 结构体
        ["@variable"]            = { fg = c.fg },                  -- 变量
        ["@variable.builtin"]    = { fg = c.yellow },              -- 内置变量 (如 this, self)
        ["@constant"]            = { link = "Constant" },          -- TS 常量
        ["@constant.builtin"]    = { fg = c.quartz },              -- 内置常量
        ["@tag"]                 = { fg = c.yellow },              -- HTML/JSX 标签：黄色
        ["@tag.delimiter"]       = { fg = c.fg_p2 },               -- 标签尖括号 < >
        ["@tag.attribute"]       = { fg = c.niagara },             -- 标签属性：蓝色
        ["@punctuation"]         = { fg = c.fg_p2 },               -- 标点符号
        ["@punctuation.bracket"] = { fg = c.fg },                  -- 括号
    }

    -- 4. 循环应用所有高亮组
    for group, parameters in pairs(groups) do
        highlight(group, parameters)
    end
end

-- 5. 执行设置
M.setup()

return M
