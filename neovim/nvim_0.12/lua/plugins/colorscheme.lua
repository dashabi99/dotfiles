vim.pack.add({
    { src = 'https://github.com/catppuccin/nvim' },
})

require('catppuccin').setup({
    term_colors = true,
    show_end_of_buffer = true, -- 是否显示缓冲区末尾多余行的 '~' 符号
    -- 使用终端背景
    -- transparent_background = true,
    integrations = {
        treesitter = true,
        gitsigns = true,
        flash = true,
        blink_cmp = true,
        mason = true,
        snacks = true,
    },
})

-- 设置 colorscheme
vim.cmd.colorscheme('catppuccin-frappe')
-- vim.cmd.colorscheme('unokai')

--[[
-- 当使用express_line插件时，取消注释

-- 当前窗口背景设为淡黑色
-- 先获取当前 Normal 的高亮设置
local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
-- 合并，保留原来的 fg 等字段，只覆盖 bg
normal.bg = '#2c2c34'
-- normal.bg = 'none'
vim.api.nvim_set_hl(0, 'Normal', normal)

-- 当前状态栏背景和非活动的状态栏背景(因为我是全局状态栏所有颜色是一样的)
-- vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#00d4ff' })
-- vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#00d4ff' })

-- 窗口分割线颜色
-- 简单粗暴：白线 + 黑背景
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#ffffff' })
vim.api.nvim_set_hl(0, 'VertSplit', { fg = '#ffffff' })
]]
