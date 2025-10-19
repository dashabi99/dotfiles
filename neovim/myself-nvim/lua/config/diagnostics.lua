-- 诊断配置模块
local DiagnosticConfig = {}

DiagnosticConfig.apply = function()
    -- 获取 Catppuccin Mocha 主题调色板
    local mocha = require('catppuccin.palettes').get_palette 'mocha'

    -- 为每种诊断类型设置图标
    for type, icon in pairs {
        Error = ' ',
        Warn = ' ',
        Info = ' ',
        Hint = ' ',
    } do
        local hl = 'DiagnosticSign' .. type  -- 生成高亮组名
        -- 定义符号列标记
        vim.fn.sign_define(hl, {
            text = icon,      -- 显示的图标
            texthl = hl,      -- 图标的高亮组
            numhl = ''        -- 行号的高亮组（空表示不高亮）
        })
    end

    -- 设置符号列为自动模式（有诊断时显示）
    vim.opt.signcolumn = 'auto'

    -- 基础诊断配置
    vim.diagnostic.config {
        signs = { priority = 5 },  -- 符号优先级
        virtual_text = false,      -- 禁用虚拟文本（行尾提示）
        underline = true,          -- 启用下划线标记
    }

    -- 自定义错误和警告的颜色
    vim.api.nvim_set_hl(0, 'DiagnosticSignError', { fg = mocha.red })
    vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { fg = mocha.yellow })
    vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { fg = mocha.sky })
    vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { fg = mocha.teal })

    -- 详细诊断配置
    vim.diagnostic.config {
        virtual_text = true,        -- 禁用行尾虚拟文本
        virtual_lines = {            -- 虚拟行配置
            only_current_line = true,  -- 只在当前行显示
            -- severity = { min = vim.diagnostic.severity.WARN }  -- 最低严重级别
        },
        underline = true,            -- 启用下划线
        signs = true,                -- 启用符号列标记
        update_in_insert = false,    -- 插入模式下不更新诊断
        float = {                    -- 悬浮窗配置
            border = 'rounded',        -- 圆角边框
            header = '',               -- 无标题
            source = true,             -- 显示诊断来源
            -- 自定义前缀函数（已注释）
            -- prefix = function(diag)
            --   local icons = require("core.icons").diagnostics
            --   return icons[diag.severity] .. " "
            -- end
        },
    }

    -- 自动更新诊断信息
    -- 在光标移动时触发
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        callback = function()
            -- 显示当前行的诊断信息
            vim.diagnostic.show(nil, 0, nil, {
                virtual_lines = { only_current_line = true }
            })
        end,
    })

    -- 悬停显示诊断快捷键
    vim.keymap.set('n', '<Leader>ld', vim.diagnostic.open_float, { desc = '显示诊断' })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = '下一个诊断' })
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = '上一个诊断' })
    vim.keymap.set('n', '<Leader>lq', vim.diagnostic.setloclist, { desc = '诊断列表' })
end

return DiagnosticConfig
