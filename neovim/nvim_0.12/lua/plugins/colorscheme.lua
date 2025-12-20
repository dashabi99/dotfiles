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
