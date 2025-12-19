vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

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
        " ",
        "%h%m%r",
        " ",
        "%=",
        " ",
        "%y [ %c : %l ] < %P > ",
    }
end

-- 全局状态栏（laststatus = 3）
vim.o.laststatus = 3
vim.o.statusline = "%!v:lua.Statusline.active()"
