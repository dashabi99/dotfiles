vim.pack.add({
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') },
})
-- 只在插入模式或者命令模式加载
-- vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
--     group = vim.api.nvim_create_augroup("SetupCompletion", { clear = true }),
--     once = true,
--     callback = function()
--         require("blink.cmp").setup({
--             keymap = { preset = "enter" },
--             appearance = {
--                 nerd_font_variant = "mono",
--             },
--             completion = { documentation = { auto_show = false } },
--             sources = {
--                 default = { "lsp", "path", "snippets", "buffer" },
--             },
--             fuzzy = { implementation = "lua" },
--         })
--     end,
-- })
require("blink.cmp").setup({
    keymap = { preset = "enter" },
    appearance = {
        nerd_font_variant = "mono",
    },
    completion = { documentation = { auto_show = false } },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "lua" },
})
