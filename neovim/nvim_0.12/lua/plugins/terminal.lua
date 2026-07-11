local api = vim.api
local keymap = vim.keymap.set

-- ============================================================
-- PowerShell
-- ============================================================

if vim.fn.has('win32') == 1 then
    if vim.fn.executable('pwsh') == 1 then
        vim.opt.shell = 'pwsh'
    else
        vim.opt.shell = 'powershell.exe'
    end

    vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'

    vim.opt.shellquote = ''
    vim.opt.shellxquote = ''

    -- 支持 :make、:grep 和命令输出重定向
    vim.opt.shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
    vim.opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s'
end

-- ============================================================
-- 终端 buffer 设置
-- ============================================================

api.nvim_create_autocmd('TermOpen', {
    group = api.nvim_create_augroup('UserTerminal', { clear = true }),
    pattern = 'term://*',
    desc = '设置内置终端窗口',
    callback = function(event)
        local win = vim.fn.bufwinid(event.buf)

        if win ~= -1 then
            vim.wo[win].number = false -- 不要行号
            vim.wo[win].relativenumber = false -- 不要相对行号
            vim.wo[win].signcolumn = 'no' -- 不要 signcolumn
            vim.wo[win].cursorline = false -- 不高亮当前行
            vim.wo[win].scrolloff = 0 -- 终端尽量多显示内容
            vim.wo[win].sidescrolloff = 0
        end

        -- 一般没有必要修改终端 filetype。
        -- 如果其他配置依赖 terminal filetype，可以取消下一行注释。
        -- vim.bo[event.buf].filetype = 'terminal'

        -- 打开终端后自动进入插入模式
        vim.schedule(function()
            if api.nvim_buf_is_valid(event.buf) and api.nvim_get_current_buf() == event.buf then
                vim.cmd.startinsert()
            end
        end)
    end,
})

-- ============================================================
-- 创建终端
-- ============================================================

local function open_terminal(direction)
    if direction == 'horizontal' then
        vim.cmd.new()
        vim.cmd.wincmd('J')
        api.nvim_win_set_height(0, 16)
        vim.wo.winfixheight = true
    elseif direction == 'vertical' then
        vim.cmd.vnew()
        vim.cmd.wincmd('L')
        api.nvim_win_set_width(0, 80)
        vim.wo.winfixwidth = true
    end

    vim.cmd.term()
end

keymap('n', '<leader>st', function()
    open_terminal('horizontal')
end, {
    silent = true,
    desc = '在下方打开终端',
})

keymap('n', '<leader>vt', function()
    open_terminal('vertical')
end, {
    silent = true,
    desc = '在右侧打开终端',
})

-- ============================================================
-- 终端模式映射
-- ============================================================

local terminal_opts = {
    silent = true,
}

keymap('t', 'jk', [[<C-\><C-n>]], {
    silent = true,
    desc = '退出终端模式',
})

keymap('t', '<C-h>', [[<C-\><C-n><C-w>h]], terminal_opts)
keymap('t', '<C-j>', [[<C-\><C-n><C-w>j]], terminal_opts)
keymap('t', '<C-k>', [[<C-\><C-n><C-w>k]], terminal_opts)
keymap('t', '<C-l>', [[<C-\><C-n><C-w>l]], terminal_opts)

-- ============================================================
-- 两个窗口之间切换布局
-- ============================================================

keymap('n', '<leader>ww', function()
    -- 排除浮动窗口
    local windows = vim.tbl_filter(function(win)
        return api.nvim_win_get_config(win).relative == ''
    end, api.nvim_tabpage_list_wins(0))

    if #windows ~= 2 then
        vim.notify('切换布局要求当前标签页恰好有两个普通窗口', vim.log.levels.WARN)
        return
    end

    local first_position = api.nvim_win_get_position(windows[1])
    local second_position = api.nvim_win_get_position(windows[2])

    -- 行号相同表示左右布局，否则表示上下布局
    local side_by_side = first_position[1] == second_position[1]

    if side_by_side then
        -- 左右布局变成上下布局
        vim.cmd.wincmd('K')
    else
        -- 上下布局变成左右布局
        vim.cmd.wincmd('H')
    end
end, {
    silent = true,
    desc = '切换两个窗口的上下或左右布局',
})
