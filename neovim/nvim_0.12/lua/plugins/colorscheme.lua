vim.pack.add({
    {
        src = 'https://github.com/catppuccin/nvim',
        name = 'catppuccin',
    },
})

local catppuccin = require('catppuccin')

catppuccin.setup({
    -- 设置终端颜色。
    term_colors = true,

    -- true：显示缓冲区末尾的 ~ 符号。
    -- false：隐藏缓冲区末尾的 ~ 符号。
    show_end_of_buffer = true,

    -- 使用终端自身的背景。
    transparent_background = true,

    integrations = {
        treesitter = true,
        gitsigns = true,
        flash = true,
        blink_cmp = true,
        mason = true,
        snacks = true,
    },
})

local transparent_groups = {
    -- 编辑区。
    'Normal',
    'NormalNC',
    'EndOfBuffer',

    -- 浮动窗口。
    'NormalFloat',
    'FloatBorder',

    -- 标记列。
    'SignColumn',

    -- 状态栏。
    'StatusLine',
    'StatusLineNC',

    -- 标签栏。
    'TabLine',
    'TabLineFill',
    'TabLineSel',

    -- colorcolumn 参考列。
    'ColorColumn',
}

local function remove_background(group)
    local highlight = vim.api.nvim_get_hl(0, {
        name = group,
        link = false,
    })

    -- nvim_set_hl() 会重新定义整个高亮组，因此先读取原有配置，
    -- 只删除背景色，保留前景色、粗体和下划线等属性。
    highlight.bg = nil
    highlight.ctermbg = nil

    vim.api.nvim_set_hl(0, group, highlight)
end

local function set_transparent()
    for _, group in ipairs(transparent_groups) do
        remove_background(group)
    end

    -- 设置标签栏空白区域的前景色，同时保持背景透明。
    local tabline_fill = vim.api.nvim_get_hl(0, {
        name = 'TabLineFill',
        link = false,
    })

    tabline_fill.bg = nil
    tabline_fill.ctermbg = nil
    tabline_fill.fg = '#767676'

    vim.api.nvim_set_hl(0, 'TabLineFill', tabline_fill)
end

local transparent_group = vim.api.nvim_create_augroup('TransparentBackground', { clear = true })

-- 每次切换配色后，重新应用透明背景。
vim.api.nvim_create_autocmd('ColorScheme', {
    group = transparent_group,
    callback = set_transparent,
})

-- 必须在 setup() 之后启用配色。
vim.cmd.colorscheme('catppuccin-frappe')

-- 确保重新加载这个配置文件时也能立即生效。
set_transparent()
