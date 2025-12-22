vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

-- 全局状态栏（laststatus = 3）
vim.o.laststatus = 3

----------------------------------------------------------------------
-- 单独设置背景，状态栏，分割线颜色，与主题插件解耦
----------------------------------------------------------------------

-- 当前窗口背景设为黑色
vim.api.nvim_set_hl(0, "Normal", { bg = "#181818" })
-- vim.api.nvim_set_hl(0, "Normal", { bg = "#2D2A2E" })
-- 非活动窗口背景设为灰色
-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "#222222" })

-- 当前状态栏背景和非活动的状态栏背景(因为我是全局状态栏所有颜色是一样的)
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#9e95c7" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#9e95c7" })

-- 窗口分割线颜色
-- 简单粗暴：白线 + 黑背景
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "VertSplit", { fg = "#ffffff" })

----------------------------------------------------------------------
-- 根据模式切换文件名高亮：Normal / Insert / Visual / Terminal / Command /
----------------------------------------------------------------------

local function update_stl_filename_hl()
    -- 当前模式，第一个字符：n / i / v / R / c / t ...
    local m = vim.fn.mode():sub(1, 1)

    local link

    if m == "n" then
        -- Normal 模式：文件名背景 = Normal（跟编辑区背景一致）
        link = "Normal"
    elseif m == "i" then
        -- 插入模式：用 ModeMsg 做示例（一般比较显眼），你可以改成别的
        link = "ModeMsg"
    elseif m == "v" or m == "V" or m == "\22" then
        -- 可视模式（包括 V 和 Ctrl-V）：用 Visual 高亮
        link = "Visual"
    elseif m == "t" then
        -- 终端模式：这里示例用 StatusLine（你可以换成 TermCursor / MoreMsg 等）
        link = "StatusLine"
    elseif m == "c" then
        -- 命令模式：这里示例用 WarningMsg（一般是黄色），可按喜好调整
        link = "WarningMsg"
    else
        -- 其它模式（替换、选择等）：统一用 StatusLine
        link = "StatusLine"
    end

    vim.api.nvim_set_hl(0, "StlFilename", { link = link })
end

local grp = vim.api.nvim_create_augroup("StlFilenameModeColor", { clear = true })

vim.api.nvim_create_autocmd({ "ModeChanged", "WinEnter", "BufEnter" }, {
    group = grp,
    callback = update_stl_filename_hl,
})

-- 启动时先执行一次，确保 StlFilename 已有正确 link
update_stl_filename_hl()

-- 让 statusline 里「文件名后面的部分」统一用黑色前景
local function setup_stl_rest_hl()
    -- 取当前 StatusLine 的背景，这样不会破坏主题的背景颜色
    local ok, stl = pcall(vim.api.nvim_get_hl, 0, { name = "StatusLine", link = false })
    local bg = ok and stl.bg or nil

    vim.api.nvim_set_hl(0, "StlRest", {
        fg = "#111111", -- 黑色字体
        bg = bg,        -- 背景沿用 StatusLine 的背景
    })
end

local rest_grp = vim.api.nvim_create_augroup("StlRestColor", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
    group = rest_grp,
    callback = setup_stl_rest_hl,
})

-- 启动时先设置一次
setup_stl_rest_hl()

----------------------------------------------------------------------
-- statusline 各个组件
----------------------------------------------------------------------

-- 路径：始终显示（带截断）
local function filepath()
    local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")

    if fpath == "" or fpath == "." then
        return ""
    end

    -- %< 让过长路径可截断
    return string.format("%%<%s/", fpath)
end

-- git 信息：依赖 gitsigns 的 vim.b.gitsigns_status_dict
local function git()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == "" then
        return ""
    end

    local head    = git_info.head
    local added   = git_info.added and (" +" .. git_info.added) or ""
    local changed = git_info.changed and (" ~" .. git_info.changed) or ""
    local removed = git_info.removed and (" -" .. git_info.removed) or ""
    if git_info.added == 0 then added = "" end
    if git_info.changed == 0 then changed = "" end
    if git_info.removed == 0 then removed = "" end

    return table.concat({
        "[ ",
        head,
        added, changed, removed,
        "]",
    })
end

-- 诊断汇总：依赖 vim.diagnostic.status()
local function diagnostics()
    local status = vim.diagnostic.status()

    if not status or status == "" then
        return ""
    end

    return "[" .. status .. "]"
end

-- 文件名块：用 StlFilename 高亮包裹
-- %#StlFilename#[ 路径%t ]%*
local function filename_block()
    return table.concat {
        "%#StlFilename#",
        "[ ",
        filepath(),
        "%t",
        " ]",
        "%* ",
    }
end

----------------------------------------------------------------------
-- Statusline 对象（只需要 active 一个接口）
----------------------------------------------------------------------

Statusline = {}

function Statusline.active()
    return table.concat {
        filename_block(), -- [ 路径 + 文件名 ]，带动态高亮
        git(),
        " ",
        diagnostics(),
        -- 从这里开始，全部用 StlRest（黑色字体）
        "%#StlRest#",
        " ",
        "%h%m%r",
        " ",
        "%=",
        " ",
        "%y [ %c : %l ] < %P > ",
    }
end

vim.o.statusline = "%!v:lua.Statusline.active()"
