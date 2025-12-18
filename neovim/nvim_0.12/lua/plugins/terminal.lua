-- ========= 终端通用设置 =========
-- TermOpen 时针对终端 buffer 做本地设置
vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("user_term_open", { clear = true }),
    pattern = "term://*",
    callback = function()
        local opt = vim.opt_local
        opt.number = false         -- 不要行号
        opt.relativenumber = false -- 不要相对行号
        opt.signcolumn = "no"      -- 不要 signcolumn
        opt.cursorline = false     -- 不高亮当前行
        opt.scrolloff = 0          -- 终端尽量多显示内容
        opt.sidescrolloff = 0
        vim.bo.filetype = "terminal"
        vim.cmd("startinsert") -- 打开终端后自动进入插入模式
    end,
})

-- 终端模式下：按 jk 回到 Normal 模式

-- vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true })
vim.keymap.set("t", "jk", [[<C-\><C-n>]], { silent = true })

-- st是在下面打开终端，vt是在右边打开终端
vim.keymap.set("n", "<leader>st", function()
    vim.cmd.new()
    vim.cmd.wincmd "J"
    vim.api.nvim_win_set_height(0, 16)
    vim.wo.winfixheight = true
    vim.cmd.term()
end)
vim.keymap.set("n", "<leader>vt", function()
    vim.cmd.vnew()
    vim.cmd.wincmd "L"
    vim.api.nvim_win_set_width(0, 80)
    vim.wo.winfixheight = true
    vim.cmd.term()
end)
-- 终端模式下：用 <C-h/j/k/l> 在窗口间移动
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { silent = true })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { silent = true })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { silent = true })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { silent = true })

-- 当只有两个窗口的时候，切换布局
vim.keymap.set("n", "<leader>ww", function()
    vim.cmd("1wincmd w")
    if vim.fn.winwidth(0) == vim.o.columns then
        vim.cmd("wincmd H") -- 上下 -> 左右
    else
        vim.cmd("wincmd K") -- 左右 -> 上下
    end
end, { desc = "Toggle split direction" })
