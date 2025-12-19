vim.pack.add({
    { src = "https://github.com/tpope/vim-fugitive" },
})

local function update_stl_filename_hl()
    -- 当前模式，取第一个字符就够：n / i / v / R ...
    local m = vim.fn.mode():sub(1, 1)

    if m == "n" then
        -- Normal 模式：文件名背景 = Normal 的背景（跟界面一样黑）
        vim.api.nvim_set_hl(0, "StlFilename", { link = "Normal" })
    else
        -- 其它模式（插入 / 可视 / 替换等）：文件名背景 = StatusLine
        vim.api.nvim_set_hl(0, "StlFilename", { link = "StatusLine" })
    end
end

local grp = vim.api.nvim_create_augroup("StlFilenameModeColor", { clear = true })

vim.api.nvim_create_autocmd({ "ModeChanged", "WinEnter", "BufEnter" }, {
    group = grp,
    callback = update_stl_filename_hl,
})

-- 启动时先执行一次
update_stl_filename_hl()
-- 定义状态栏
vim.o.statusline =
'%#StlFilename#[ %F ]%* %{FugitiveStatusline()} %h%m%r%= -FileType=%y- [ %c : %l ][ %P ]'
-- vim.o.statusline = '[ %F ] %{FugitiveStatusline()} %h%m%r%= -FileType=%y- [ %c : %l ][ %P ]'
vim.o.laststatus = 3
