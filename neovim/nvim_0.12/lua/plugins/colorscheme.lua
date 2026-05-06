vim.pack.add({
    { src = 'https://github.com/catppuccin/nvim' },
})

require('catppuccin').setup({
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
vim.cmd.colorscheme('catppuccin')

-- 透明背景 和 StatusLine有冲突
-- local function set_transparent() -- set UI component to transparent
--   local groups = {
--     "Normal",
--     "NormalNC",
--     "EndOfBuffer",
--     "NormalFloat",
--     "FloatBorder",
--     "SignColumn",
--     "StatusLine",
--     "StatusLineNC",
--     "TabLine",
--     "TabLineFill",
--     "TabLineSel",
--     "ColorColumn",
--   }
--   for _, g in ipairs(groups) do
--     vim.api.nvim_set_hl(0, g, { bg = "none" })
--   end
--   vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
-- end
-- set_transparent()
