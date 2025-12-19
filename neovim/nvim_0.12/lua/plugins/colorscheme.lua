vim.pack.add({
    { src = "https://github.com/catppuccin/nvim" },
})

require("catppuccin").setup({
    term_colors = true,
    show_end_of_buffer = true, -- 是否显示缓冲区末尾多余行的 '~' 符号
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
vim.cmd.colorscheme("catppuccin")

-- 背景设为黑色
vim.api.nvim_set_hl(0, "Normal", { bg = "#111111" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "#111111" })

-- 状态栏背景设为 #9e95c7
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#9e95c7" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#9e95c7" })

-- 窗口分割线颜色（竖线）
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#5b547f", bg = "#000000" })
vim.api.nvim_set_hl(0, "VertSplit", { fg = "#5b547f", bg = "#000000" })
