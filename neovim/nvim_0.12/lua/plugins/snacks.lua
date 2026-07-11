vim.pack.add({
    { src = 'https://github.com/folke/snacks.nvim' },
})

local Snacks = require('snacks')
Snacks.setup({
    -- 检测大文件，并关闭一些高开销功能
    bigfile = { enabled = true },
    -- 缩进线 使用了mini插件
    -- indent = { enabled = true, animate = { enabled = false } },
    input = { enabled = true },
    -- 模糊查找器
    picker = {
        enabled = true,
        matcher = { frecency = true, cwd_bonus = true, history_bonus = true },
        formatters = { icon_width = 3 },
        -- telescope的风格
        layout = {
            preset = 'telescope',
        },
        win = {
            input = {
                keys = {
                    -- ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
                    -- ctrl+n 打开选择文件到一个tab
                    ['<C-n>'] = { 'edit_tab', mode = { 'n', 'i' } },
                    ['<C-s>'] = { 'edit_split', mode = { 'i', 'n' } },
                    ['<C-\\>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
                },
            },
            list = {
                keys = {
                    ['<C-s>'] = 'edit_split',
                    ['<C-\\>'] = 'edit_vsplit',
                },
            },
        },
    },
    -- 优化普通文件的首次显示速度
    quickfile = { enabled = true },
})
-- 模糊查找器快捷键
local function map(key, func, desc)
    vim.keymap.set('n', key, func, {
        desc = desc,
        silent = true,
    })
end

map('<leader>fg', Snacks.picker.grep, 'Find Grep')
map('<leader>ff', Snacks.picker.smart, 'Smart Find Files')
map('<leader>fb', Snacks.picker.buffers, 'Find Buffers')
