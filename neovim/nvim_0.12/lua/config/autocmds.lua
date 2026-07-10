local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- 建议加统一前缀，避免与插件的 augroup 重名
local function group(name)
    return augroup('User_' .. name, { clear = true })
end

-- ============================================================
-- 光标和文件操作
-- ============================================================

-- 恢复上次编辑时的光标位置
autocmd('BufReadPost', {
    group = group('restore_cursor'),
    desc = '恢复上次编辑时的光标位置',
    callback = function(event)
        -- 跳过帮助页、终端、快捷列表等特殊 buffer
        if vim.bo[event.buf].buftype ~= '' then
            return
        end

        local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(event.buf)

        if mark[1] > 0 and mark[1] <= line_count then
            -- BufReadPost 通常发生在当前窗口，但使用 pcall 可以避免
            -- 文件内容发生变化后列位置越界导致报错
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- ============================================================
-- 复制高亮
-- ============================================================

autocmd('TextYankPost', {
    group = group('highlight_yank'),
    desc = '高亮复制的文本',
    callback = function()
        vim.hl.on_yank({
            higroup = 'IncSearch',
            timeout = 300,
            on_visual = true,
        })
    end,
})

-- ============================================================
-- 禁止自动延续注释
-- ============================================================

-- FileType 用于处理 ftplugin 设置 formatoptions 的情况；
-- BufEnter 用于在重新进入 buffer 时再次保证配置生效。
autocmd({ 'FileType', 'BufEnter' }, {
    group = group('comment_format'),
    pattern = '*',
    desc = '禁用注释自动换行和自动延续',
    callback = function()
        vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
    end,
})

-- c：在插入模式下自动换行注释
-- r：按 Enter 后自动插入注释符号
-- o：使用 o/O 新建行时自动插入注释符号

-- ============================================================
-- 文件类型特定设置
-- ============================================================

-- Markdown
local markdown_group = group('markdown_settings')

autocmd('FileType', {
    group = markdown_group,
    pattern = { 'markdown', 'markdown.mdx' },
    desc = 'Markdown 文件设置',
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true
        vim.opt_local.conceallevel = 2
    end,
})

-- JSON / JSONC
autocmd('FileType', {
    group = group('json_settings'),
    pattern = { 'json', 'jsonc' },
    desc = 'JSON 文件设置',
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
        vim.opt_local.conceallevel = 0
    end,
})

-- YAML
autocmd('FileType', {
    group = group('yaml_settings'),
    pattern = { 'yaml', 'yml' },
    desc = 'YAML 文件设置',
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
    end,
})

-- ============================================================
-- 特殊窗口按 q 关闭
-- ============================================================

autocmd('FileType', {
    group = group('close_with_q'),
    pattern = {
        'help',
        'startuptime',
        'qf',
        'lspinfo',
        'man',
        'checkhealth',
        'tsplayground',
        'notify',
        'noice',
        'Trouble',
        'trouble',
    },
    desc = '特殊窗口按 q 关闭',
    callback = function(event)
        vim.bo[event.buf].buflisted = false

        vim.keymap.set('n', 'q', '<cmd>close<cr>', {
            buffer = event.buf,
            silent = true,
            nowait = true,
            desc = '关闭当前特殊窗口',
        })
    end,
})
