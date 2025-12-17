vim.pack.add({
    { src = "https://github.com/folke/snacks.nvim" },
})
require("snacks").setup({
    bigfile = { enabled = true },
    -- 缩进线
    indent = { enabled = true, animate = { enabled = false } },
    -- input = { enabled = true },
    -- notifier = { enabled = true },
    -- 模糊查找器
    picker = {
        matcher = { frecency = true, cwd_bonus = true, history_bonus = true },
        formatters = { icon_width = 3 },
        prsset = "bottom",
        win = {
            input = {
                keys = {
                    ["<Esc>"] = { "close", mode = { "n", "i" } },
                    -- ctrl+o 打开选择文件到一个tab
                    ["<C-o>"] = { "edit_tab", mode = { "n", "i" } },
                },
            },
        },
    },
    -- quickfile = { enabled = true },
    -- image = {
    --     enabled = true,
    --     doc = { enabled = true, inline = false, float = true, max_width = 80, max_height = 20 },
    -- },
    -- styles = {
    --     snacks_image = {
    --         border = "rounded",
    --         backdrop = false,
    --     },
    -- },
})
-- 模糊查找器快捷键
local map = function(key, func, desc)
    vim.keymap.set("n", key, func, { desc = desc })
end
map("<leader>fg", Snacks.picker.grep, "Find Grep")
map("<leader>ff", Snacks.picker.smart, "Smart Find Files")
map("<leader>fb", Snacks.picker.buffers, "Find Buffers")
