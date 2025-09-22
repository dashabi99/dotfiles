--可视化V模式下，用J,K整体移动
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- 窗口
vim.keymap.set("n", "<leader>sv", "<C-w>v") -- 水平新增窗口
vim.keymap.set("n", "<leader>sh", "<C-w>s") -- 垂直新增窗口

--如果你使用了wezterm终端，且用ctrl+v粘贴，那么改建可视化块模式的键位 vv
vim.keymap.set("n", "vv", "<C-v>", { noremap = true })
-- 插入模式下，将 'jk' 映射为 'Esc'
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

-- 命令行模式下，将 'jk' 映射为 'Esc'
vim.keymap.set("c", "jk", "<Esc>", { noremap = true, silent = true })

-- 下面这两个注释掉，不然会导致在视觉模式下选择卡顿
-- 视觉模式下，将 'jk' 映射为 'Esc'
-- vim.keymap.set("v", "jk", "<Esc>", { noremap = true, silent = true })
-- 选择模式下，将 'jk' 映射为 'Esc'
-- vim.keymap.set("x", "jk", "<Esc>", { noremap = true, silent = true })
