-- ============================================================================
-- 自动命令配置文件
-- 定义编辑器的自动化行为和事件响应
-- 通过自动命令（autocmd）在特定事件触发时执行指定操作
-- ============================================================================

local AutoCmd = {}

-- ----------------------------------------------------------------------------
-- 应用自动命令配置
-- 设置各种编辑器行为的自动化规则
-- ----------------------------------------------------------------------------
function AutoCmd.apply()
    -- 获取 Catppuccin Mocha 主题调色板
    -- 用于设置界面元素的颜色
    local mocha = require('catppuccin.palettes').get_palette 'mocha'
    -- ------------------------------------------------------------------------
    -- 禁用弃用警告
    -- 某些插件可能使用已弃用的 API，产生恼人的警告信息
    -- ------------------------------------------------------------------------
    ---@diagnostic disable: duplicate-set-field
    vim.deprecate = function() end
    -- 注意：这会隐藏所有弃用警告，可能错过重要的更新提示
    -- 仅在确定警告不重要时使用

    -- ------------------------------------------------------------------------
    -- 设置 Blink 补全插件的边框颜色
    -- 统一使用主题的蓝色，保持界面风格一致
    -- ------------------------------------------------------------------------
    -- vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = mocha.blue })
    -- -- 补全菜单边框颜色
    
    -- vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { fg = mocha.blue })
    -- -- 文档窗口边框颜色
    
    -- vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpBorder', { fg = mocha.blue })
    -- -- 函数签名帮助窗口边框颜色
    
    -- vim.api.nvim_set_hl(0, 'BlinkCmpDocSeparator', { fg = mocha.blue })
    -- -- 文档分隔符颜色

    local autocmd = vim.api.nvim_create_autocmd
    local augroup = vim.api.nvim_create_augroup

    -- ========== 光标和文件操作 ==========

    -- 恢复光标位置
    autocmd("BufReadPost", {
    group = augroup("restore_cursor", { clear = true }),
    desc = "恢复上次编辑时的光标位置",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
    })

    -- ========== 复制高亮 ==========

    -- 高亮复制的文本（合并了重复的配置）
    autocmd("TextYankPost", {
    group = augroup("highlight_yank", { clear = true }),
    pattern = "*",
    desc = "高亮复制的文本",
    callback = function()
        vim.highlight.on_yank({
        timeout = 300, -- 高亮持续时间
        visual = true, -- 在visual模式下也高亮
        higroup = "IncSearch", -- 使用IncSearch高亮组，可以自定义
        })
    end,
    })

    -- ========== 文件格式和清理 ==========

    -- 自动删除尾随空格
    autocmd("BufWritePre", {
    group = augroup("trim_whitespace", { clear = true }),
    pattern = { "*.lua", "*.js", "*.ts", "*.py", "*.go", "*.rs", "*.c", "*.cpp", "*.h" },
    desc = "保存前自动删除尾随空格",
    callback = function()
        -- 保存光标位置
        local save_cursor = vim.fn.getpos(".")
        local save_search = vim.fn.getreg("/")
        -- 删除尾随空格
        pcall(function()
        vim.cmd([[keepjumps keeppatterns %s/\s\+$//e]])
        end)
        -- 恢复光标位置和搜索寄存器
        vim.fn.setpos(".", save_cursor)
        vim.fn.setreg("/", save_search)
    end,
    })

    -- 注释不自动换行到下一行
    autocmd("BufEnter", {
    group = augroup("comment_format", { clear = true }),
    pattern = "*",
    desc = "禁用注释自动换行",
    callback = function()
        -- 移除自动注释格式选项
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
    })

    -- ========== 文件类型特定设置 ==========

    -- Markdown 文件特殊设置
    autocmd("FileType", {
    group = augroup("markdown_settings", { clear = true }),
    pattern = "markdown",
    desc = "Markdown 文件特殊设置",
    callback = function()
        vim.opt_local.wrap = true -- 启用换行
        vim.opt_local.linebreak = true -- 按词换行
        vim.opt_local.spell = true -- 启用拼写检查
        vim.opt_local.conceallevel = 2 -- 隐藏markdown语法
    end,
    })

    -- JSON 文件格式化
    autocmd("FileType", {
    group = augroup("json_settings", { clear = true }),
    pattern = "json",
    desc = "JSON 文件设置",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.conceallevel = 0 -- 显示所有JSON语法
    end,
    })

    -- YAML 文件设置
    autocmd("FileType", {
    group = augroup("yaml_settings", { clear = true }),
    pattern = { "yaml", "yml" },
    desc = "YAML 文件设置",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
    end,
    })

    -- 自动关闭某些特殊窗口
    autocmd("FileType", {
    group = augroup("close_with_q", { clear = true }),
    pattern = {
        "help",
        "startuptime",
        "qf",
        "lspinfo",
        "man",
        "checkhealth",
        "tsplayground",
        "notify",
        "noice",
        "Trouble",
    },
    desc = "特殊窗口按q关闭",
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
    })

    -- 自动调整窗口大小
    autocmd("VimResized", {
    group = augroup("resize_splits", { clear = true }),
    desc = "窗口大小改变时自动调整分割",
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
    })
end

-- 返回 AutoCmd 模块
return AutoCmd