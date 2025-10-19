-- 基于 OSC52 的远程剪贴板支持

local SSHMode = {
    on = false,
    old_clipboard = vim.g.clipboard,
    auto_enable = true,
    debug = false,
}

-- 切换模式
local switch_mode = function()
    if SSHMode.on then
        vim.g.clipboard = SSHMode.old_clipboard
        SSHMode.on = false
        vim.notify('剪贴板 SSH 模式 关闭', vim.log.levels.INFO)
    else
        if SSHMode.debug then
            vim.notify(
                string.format(
                    '启用 OSC52\nSSH_TTY: %s\nTERM: %s',
                    vim.env.SSH_TTY or 'not set',
                    vim.env.TERM or 'not set'
                ),
                vim.log.levels.DEBUG
            )
        end
        
        vim.g.clipboard = {
            name = 'OSC 52',
            copy = {
                ['+'] = require('vim.ui.clipboard.osc52').copy '+',
                ['*'] = require('vim.ui.clipboard.osc52').copy '*',
            },
            paste = {
                ['+'] = require('vim.ui.clipboard.osc52').paste '+',
                ['*'] = require('vim.ui.clipboard.osc52').paste '*',
            },
            cache_enabled = false,
        }
        SSHMode.on = true
        vim.notify('剪贴板 SSH 模式 开启', vim.log.levels.INFO)
    end
end

-- 应用配置
SSHMode.apply = function()
    -- 切换命令
    vim.api.nvim_create_user_command('ClipboardSshModeSwitch', switch_mode, {
        desc = '切换剪贴板 SSH 模式'
    })

    -- 状态查询命令
    vim.api.nvim_create_user_command('ClipboardSshModeInfo', function()
        local status = SSHMode.on and '开启' or '关闭'
        vim.notify('剪贴板 SSH 模式：' .. status, vim.log.levels.INFO)
    end, { desc = '查看 SSH 模式状态' })

    -- 自动启用
    if SSHMode.auto_enable 
        and not SSHMode.on 
        and vim.fn.exists '$SSH_TTY' == 1 
    then
        switch_mode()
    end
end

-- 获取状态（用于状态栏）
SSHMode.get_status = function()
    return SSHMode.on and ' SSH' or ''
end

return SSHMode