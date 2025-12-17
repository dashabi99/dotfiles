vim.pack.add({
    { src = "https://github.com/tpope/vim-fugitive" },
})
-- 定义状态栏
vim.o.statusline = '[ %F ] %{FugitiveStatusline()} %h%m%r%= -FileType=%y- [ %c : %l ][ %P ]'
vim.o.laststatus = 3
