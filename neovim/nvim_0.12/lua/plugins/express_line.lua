vim.pack.add({
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/wesleimp/express_line.nvim', version = 'update-mode-highlights' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
})

vim.opt.laststatus = 3

require('gitsigns').setup({
    signs = {
        add = { text = '\u{2590}' }, -- ▏
        change = { text = '\u{2590}' }, -- ▐
        delete = { text = '\u{2590}' }, -- ◦
        topdelete = { text = '\u{25e6}' }, -- ◦
        changedelete = { text = '\u{25cf}' }, -- ●
        untracked = { text = '\u{25cb}' }, -- ○
    },
    signcolumn = true,
    current_line_blame = false,
})

local builtin = require('el.builtin')
local extensions = require('el.extensions')
local subscribe = require('el.subscribe')
local sections = require('el.sections')

require('el').setup({
    generator = function()
        local segments = {}

        -- 左侧
        -- 带括号 [模式]
        table.insert(segments, extensions.mode)
        -- 去掉[]
        -- table.insert(
        --   segments,
        --   extensions.gen_mode({
        --     format_string = " %s ",
        --   })
        -- )
        table.insert(segments, ' ')
        table.insert(
            segments,
            subscribe.buf_autocmd('el-git-branch', 'BufEnter', function(win, buf)
                local branch = extensions.git_branch(win, buf)
                if branch and branch ~= '' then
                    return ' ' .. extensions.git_icon(win, buf) .. ' ' .. branch
                end
                -- return ''
            end)
        )
        table.insert(
            segments,
            subscribe.buf_autocmd('el-git-changes', 'BufWritePost', function(win, buf)
                local changes = extensions.git_changes(win, buf)
                if changes then
                    return changes
                end
            end)
        )
        table.insert(segments, function()
            local task_count = #require('misery.scheduler').tasks
            if task_count == 0 then
                return ''
            else
                return string.format(' (Queued Events: %d)', task_count)
            end
        end)

        -- 中间
        table.insert(segments, sections.split)
        table.insert(
            segments,
            subscribe.buf_autocmd('el_file_icon', 'BufRead', function(_, buffer)
                return extensions.file_icon(_, buffer)
            end)
        )
        -- 显示%f文件名,%F显示完整的路径和文件名
        table.insert(segments, ' %F')
        table.insert(segments, builtin.modified)

        -- 右侧
        table.insert(segments, sections.split)
        table.insert(segments, builtin.filetype)
        table.insert(segments, ' [')
        table.insert(segments, builtin.line_with_width(3))
        table.insert(segments, ':')
        table.insert(segments, builtin.column_with_width(2))
        table.insert(segments, ']')

        return segments
    end,
})
