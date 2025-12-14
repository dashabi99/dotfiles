local map = vim.keymap.set

-- 更好的上下移动
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- 普通模式下，Ctrl+h/j/k/l 切换窗口
map("n", "<C-h>", "<C-w>h", { desc = "移动到左边窗口" })
map("n", "<C-j>", "<C-w>j", { desc = "移动到下边窗口" })
map("n", "<C-k>", "<C-w>k", { desc = "移动到上边窗口" })
map("n", "<C-l>", "<C-w>l", { desc = "移动到右边窗口" })
-- windows下把ctrl+h当成了backspace
map("n", "<BS>", "<Cmd>wincmd h<CR>", { desc = "退格键也移动到左边窗口", silent = true })

-- 窗口大小调整
map("n", "<C-Up>", ":resize +2<CR>", { desc = "增加窗口高度" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "减少窗口高度" })
map("n", "<C-Left>", ":vertical resize +2<CR>", { desc = "减少窗口宽度" })
map("n", "<C-Right>", ":vertical resize -2<CR>", { desc = "增加窗口宽度" })

-- 默认的缓冲区导航
-- map("n", "<S-h>", ":bprevious<CR>", { desc = "上一个缓冲区" })
-- map("n", "<S-l>", ":bnext<CR>", { desc = "下一个缓冲区" })

-- 配合oil.nvim插件使用在tab里导航
map("n", "<S-h>", ":tabp<CR>", { desc = "上一个tab" })
map("n", "<S-l>", ":tabn<CR>", { desc = "下一个tab" })
map("n", "<leader>tn", ":tabnew ", { desc = "命令模式 tabnew " })

map("n", "<leader>bb", ":buffers<CR>:b<Space>", { desc = "预览当前所有的buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "删除当前缓冲区" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "上一个缓冲区" })
map("n", "<leader>bn", ":bnext<CR>", { desc = "下一个缓冲区" })

-- 更好的缩进
map("v", "<", "<gv", { desc = "向左缩进" })
map("v", ">", ">gv", { desc = "向右缩进" })

-- 移动文本
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "向下移动文本" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "向上移动文本" })

-- 清除搜索高亮
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "清除搜索高亮" })

--如果你使用了wezterm终端，且用ctrl+v粘贴，那么改建可视化块模式的键位 vv
map("n", "vv", "<C-v>", { noremap = true })

-- 插入模式下，将 'jk' 映射为 'Esc'
map("i", "jk", "<Esc>", { noremap = true, silent = true })
-- 命令行模式下，将 'jk' 映射为 'Esc'
map("c", "jk", "<Esc>", { noremap = true, silent = true })
