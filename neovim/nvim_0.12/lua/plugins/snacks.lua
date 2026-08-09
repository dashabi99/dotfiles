vim.pack.add({
    { src = 'https://github.com/folke/snacks.nvim' },
})

-- 第一次要把这个注释掉，让他自己下载dll文件，再把文件移动到这个目录下就行
local data_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'snacks')
vim.fn.mkdir(data_dir, 'p')
local sqlite3_path
if vim.fn.has('win32') == 1 then
    sqlite3_path = vim.fs.joinpath(data_dir, 'sqlite3.dll')
end
if sqlite3_path and vim.fn.filereadable(sqlite3_path) == 0 then
    vim.notify('找不到 SQLite DLL：' .. sqlite3_path, vim.log.levels.WARN)
end

local Snacks = require('snacks')
Snacks.setup({
    -- 检测大文件，并关闭一些高开销功能
    bigfile = { enabled = true },
    -- 缩进线 使用了mini插件
    -- indent = { enabled = true, animate = { enabled = false } },
    input = { enabled = true },
    -- 模糊查找器
    picker = {
        -- 指定win下的dll库文件路径
        db = {
            sqlite3_path = sqlite3_path,
        },
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
                    ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
                    -- alt+t 打开选择文件到一个tab
                    ['<A-t>'] = { 'edit_tab', mode = { 'n', 'i' } },
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

map('<leader>ff', Snacks.picker.smart, 'Smart Find Files')
map('<leader>fg', Snacks.picker.grep, 'Find Grep')
map('<leader>fb', Snacks.picker.buffers, 'Find Buffers')
map('<leader>fd', Snacks.picker.diagnostics, 'Find Diagnostics')
map('<leader>fk', Snacks.picker.keymaps, 'Find Keymaps')
