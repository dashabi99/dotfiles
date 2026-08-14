-- lua/plugins/statusline.lua

local M = {}

local function statusline_escape(value)
    return tostring(value or ''):gsub('%%', '%%%%')
end

local mode_names = {
    n = 'NORMAL',
    no = 'OPERATOR',
    nov = 'OPERATOR',
    noV = 'OPERATOR',
    ['no\22'] = 'OPERATOR',
    niI = 'NORMAL',
    niR = 'NORMAL',
    niV = 'NORMAL',

    v = 'VISUAL',
    V = 'V-LINE',
    ['\22'] = 'V-BLOCK',

    s = 'SELECT',
    S = 'S-LINE',
    ['\19'] = 'S-BLOCK',

    i = 'INSERT',
    ic = 'INSERT',
    ix = 'INSERT',

    R = 'REPLACE',
    Rc = 'REPLACE',
    Rx = 'REPLACE',
    Rv = 'V-REPLACE',
    Rvc = 'V-REPLACE',
    Rvx = 'V-REPLACE',

    c = 'COMMAND',
    cv = 'EX',
    ce = 'EX',

    r = 'PROMPT',
    rm = 'MORE',
    ['r?'] = 'CONFIRM',

    ['!'] = 'SHELL',
    t = 'TERMINAL',
}

local diagnostic_items = {
    {
        severity = vim.diagnostic.severity.ERROR,
        icon = ' ',
        highlight = 'DiagnosticError',
    },
    {
        severity = vim.diagnostic.severity.WARN,
        icon = ' ',
        highlight = 'DiagnosticWarn',
    },
    {
        severity = vim.diagnostic.severity.INFO,
        icon = ' ',
        highlight = 'DiagnosticInfo',
    },
    {
        severity = vim.diagnostic.severity.HINT,
        icon = ' ',
        highlight = 'DiagnosticHint',
    },
}

local statusline_colors = {
    mode = {
        fg = '#ffffff',
        bg = '#3b82f6',
        bold = true,
    },
    git = {
        fg = '#1f2328',
        bg = '#a7c080',
        bold = true,
    },
    file = {
        fg = '#eceff4',
        bg = '#4c566a',
        bold = true,
    },
    filetype = {
        fg = '#d8dee9',
        bg = '#3b4252',
    },
    position = {
        fg = '#1f2328',
        bg = '#88c0d0',
        bold = true,
    },
}

local function set_highlights()
    vim.api.nvim_set_hl(0, 'StlMode', statusline_colors.mode)
    vim.api.nvim_set_hl(0, 'StlGit', statusline_colors.git)
    vim.api.nvim_set_hl(0, 'StlFile', statusline_colors.file)
    vim.api.nvim_set_hl(0, 'StlFiletype', statusline_colors.filetype)
    vim.api.nvim_set_hl(0, 'StlPosition', statusline_colors.position)
end

local function get_mode()
    local current_mode = vim.api.nvim_get_mode().mode
    return mode_names[current_mode] or current_mode:upper()
end

local function get_git_segment(bufnr)
    local parts = {}

    local head = vim.b[bufnr].gitsigns_head

    if head and head ~= '' then
        parts[#parts + 1] = statusline_escape(head)
    end

    local status = vim.b[bufnr].gitsigns_status_dict

    if status then
        local added = tonumber(status.added) or 0
        local changed = tonumber(status.changed) or 0
        local removed = tonumber(status.removed) or 0

        if added > 0 then
            parts[#parts + 1] = '+' .. added
        end

        if changed > 0 then
            parts[#parts + 1] = '~' .. changed
        end

        if removed > 0 then
            parts[#parts + 1] = '-' .. removed
        end
    end

    if #parts == 0 then
        return ''
    end

    return '%#StlGit# ' .. table.concat(parts, ' ') .. ' %*'
end

local function get_path_max_width()
    -- 路径最多占状态栏宽度的 40%，范围限制为 30 到 80 列。
    local width = math.floor(vim.o.columns * 0.4)
    return math.max(30, math.min(width, 80))
end

local function get_file_path(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)

    if name == '' then
        return '[No Name]'
    end

    -- 默认显示绝对路径。
    local path = vim.fn.fnamemodify(name, ':p')
    local max_width = get_path_max_width()

    -- 路径过长时缩短目录名，文件名保持完整。
    if vim.fn.strdisplaywidth(path) > max_width then
        path = vim.fn.pathshorten(path, 1)
    end

    return statusline_escape(path)
end

local function get_file_segment(bufnr)
    return table.concat({
        '%#StlFile# ',
        get_file_path(bufnr),
        ' %m%r ',
        '%*',
    })
end

local function diagnostics_enabled(bufnr)
    if type(vim.diagnostic.is_enabled) ~= 'function' then
        return true
    end

    local ok, enabled = pcall(vim.diagnostic.is_enabled, {
        bufnr = bufnr,
    })

    return not ok or enabled
end

local function get_diagnostics(bufnr)
    if not diagnostics_enabled(bufnr) then
        return ''
    end

    local parts = {}

    for _, item in ipairs(diagnostic_items) do
        local count = #vim.diagnostic.get(bufnr, {
            severity = item.severity,
        })

        if count > 0 then
            parts[#parts + 1] = string.format('%%#%s#%s%d%%*', item.highlight, item.icon, count)
        end
    end

    if #parts == 0 then
        return ''
    end

    return ' ' .. table.concat(parts, ' ') .. ' '
end

local function get_filetype_segment(bufnr)
    local filetype = vim.bo[bufnr].filetype

    if filetype == '' then
        filetype = 'text'
    end

    return table.concat({
        '%#StlFiletype# ',
        statusline_escape(filetype),
        ' %*',
    })
end

local function get_position_segment()
    return '%#StlPosition# %l:%c %*'
end

function M.render()
    local bufnr = vim.api.nvim_get_current_buf()

    return table.concat({
        '%#StlMode# ',
        statusline_escape(get_mode()),
        ' %*',

        get_git_segment(bufnr),

        -- 空间仍然不足时，允许 Neovim 从文件路径位置截断。
        '%<',
        get_file_segment(bufnr),

        '%=',

        get_diagnostics(bufnr),
        get_filetype_segment(bufnr),
        get_position_segment(),
    })
end

local function redraw_statusline()
    -- vim.cmd('redrawstatus!')
    vim.cmd.redrawstatus()
end

local function setup()
    set_highlights()

    vim.o.laststatus = 3
    vim.o.statusline = "%!v:lua.require('plugins.statusline').render()"

    local group = vim.api.nvim_create_augroup('CustomStatusline', { clear = true })

    vim.api.nvim_create_autocmd({
        'DiagnosticChanged',
        'BufEnter',
        'BufWritePost',
        -- 对snacks插件有影响，先注释掉
        -- 'ModeChanged',
        'VimResized',
    }, {
        group = group,
        callback = redraw_statusline,
    })

    vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'GitsignsUpdate',
        callback = redraw_statusline,
    })

    vim.api.nvim_create_autocmd('ColorScheme', {
        group = group,
        callback = function()
            set_highlights()
            redraw_statusline()
        end,
    })
end

-- init.lua 中执行 require('plugins.statusline') 时自动配置。
setup()

return M
