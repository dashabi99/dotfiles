local map = vim.keymap.set

-- 更好的上下移动
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- 窗口导航
map("n", "<C-h>", "<C-w>h", { desc = "移动到左边窗口" })
map("n", "<C-j>", "<C-w>j", { desc = "移动到下边窗口" })
map("n", "<C-k>", "<C-w>k", { desc = "移动到上边窗口" })
map("n", "<C-l>", "<C-w>l", { desc = "移动到右边窗口" })

-- 窗口大小调整
map("n", "<C-Up>", ":resize +2<CR>", { desc = "增加窗口高度" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "减少窗口高度" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "减少窗口宽度" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "增加窗口宽度" })

-- 缓冲区导航
-- map("n", "<S-h>", ":bprevious<CR>", { desc = "上一个缓冲区" })
-- map("n", "<S-l>", ":bnext<CR>", { desc = "下一个缓冲区" })
-- 配合oil.nvim插件使用
map("n", "<S-h>", ":tabp<CR>", { desc = "上一个tab" })
map("n", "<S-l>", ":tabn<CR>", { desc = "下一个tab" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "删除缓冲区" })
map("n", "<leader>tn", ":tabnew<CR>", { desc = "打开一个空白的tab" })

-- 更好的缩进
map("v", "<", "<gv", { desc = "向左缩进" })
map("v", ">", ">gv", { desc = "向右缩进" })

-- 移动文本
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "向下移动文本" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "向上移动文本" })

-- 清除搜索高亮
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "清除搜索高亮" })

-- 保存和退出
-- map("n", "<leader>w", ":w<CR>", { desc = "保存文件" })
-- map("n", "<leader>q", ":q<CR>", { desc = "退出" })
-- map("n", "<leader>Q", ":qa<CR>", { desc = "全部退出" })

--如果你使用了wezterm终端，且用ctrl+v粘贴，那么改建可视化块模式的键位 vv
map("n", "vv", "<C-v>", { noremap = true })
-- 插入模式下，将 'jk' 映射为 'Esc'
map("i", "jk", "<Esc>", { noremap = true, silent = true })

-- 命令行模式下，将 'jk' 映射为 'Esc'
map("c", "jk", "<Esc>", { noremap = true, silent = true })

-- 窗口
-- map("n", "<leader>sv", "<C-w>v") -- 水平新增窗口
-- map("n", "<leader>sh", "<C-w>s") -- 垂直新增窗口

-- 下面这两个注释掉，不然会导致在视觉模式下选择卡顿
-- 视觉模式下，将 'jk' 映射为 'Esc'
-- map("v", "jk", "<Esc>", { noremap = true, silent = true })
-- 选择模式下，将 'jk' 映射为 'Esc'
-- map("x", "jk", "<Esc>", { noremap = true, silent = true })

-- 更好的粘贴
-- map("v", "p", '"_dP', { desc = "粘贴不覆盖寄存器" })
