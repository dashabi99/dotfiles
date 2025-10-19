-- LSP 配置模块
local LspConfig = {}

-- 引入必要的 Neovim API 和 LSP 模块
local lsp = vim.lsp
local api = vim.api
local util = lsp.util
local ms = vim.lsp.protocol.Methods  -- LSP 协议方法
local hover_ns = api.nvim_create_namespace 'hover'  -- 创建用于悬停高亮的命名空间

-- 创建位置参数的辅助函数（兼容不同 Neovim 版本）
local function make_position_params()
    if vim.fn.has 'nvim-0.11' == 1 then
        -- Neovim 0.11+ 版本：需要传入 offset_encoding 参数
        return function(client)
            return vim.lsp.util.make_position_params(nil, client.offset_encoding)
        end
    else
        -- 旧版本：不需要额外参数
        ---@diagnostic disable-next-line: missing-parameter
        return vim.lsp.util.make_position_params()
    end
end

-- 重写 vim.lsp.hover 函数，提供增强的悬停信息显示
local hover = function(config)
    config = config or {}
    config.border = config.border or 'rounded'  -- 设置浮动窗口边框样式
    config.focus_id = ms.textDocument_hover  -- 设置焦点 ID

    local params = make_position_params()  -- 获取当前光标位置参数
    
    -- 向所有活跃的 LSP 客户端发送悬停请求
    lsp.buf_request_all(0, ms.textDocument_hover, params, function(results, ctx)
        local bufnr = assert(ctx.bufnr)  -- 获取缓冲区编号
        
        -- 如果当前缓冲区已改变，直接返回
        if api.nvim_get_current_buf() ~= bufnr then
            return
        end

        -- 处理所有客户端的响应结果
        local results1 = {}
        for client_id, resp in pairs(results) do
            local err, result = resp.err, resp.result
            if err then
                lsp.log.error(err.code, err.message)  -- 记录错误
            elseif result then
                results1[client_id] = result  -- 保存有效结果
            end
        end

        -- 如果没有任何结果，显示提示信息
        if vim.tbl_isempty(results1) then
            if config.silent ~= true then
                vim.notify 'No information available'
            end
            return
        end

        local contents = {}
        local nresults = #vim.tbl_keys(results1)  -- 结果数量
        local format = 'markdown'  -- 默认格式

        -- 遍历每个客户端的结果
        for client_id, result in pairs(results1) do
            local client = assert(lsp.get_client_by_id(client_id))
            
            -- 如果有多个结果，添加客户端名称作为标题
            if nresults > 1 then
                contents[#contents + 1] = string.format('# %s', client.name)
            end

            -- 处理纯文本内容
            if type(result.contents) == 'table' and result.contents.kind == 'plaintext' then
                if #results1 == 1 then
                    format = 'plaintext'
                    contents = vim.split(result.contents.value or '', '\n', { trimempty = true })
                else
                    -- 多个结果时用代码块包裹纯文本
                    contents[#contents + 1] = '```'
                    vim.list_extend(contents, vim.split(result.contents.value or '', '\n', { trimempty = true }))
                    contents[#contents + 1] = '```'
                end
            else
                -- 转换为 Markdown 格式
                vim.list_extend(contents, util.convert_input_to_markdown_lines(result.contents))
            end

            -- 如果结果包含范围信息，高亮显示该范围
            if result.range then
                local start = result.range.start
                local end_ = result.range['end']
                local start_idx = util._get_line_byte_from_position(bufnr, start, client.offset_encoding)
                local end_idx = util._get_line_byte_from_position(bufnr, end_, client.offset_encoding)
                vim.hl.range(bufnr, hover_ns, 'LspReferenceTarget', { start.line, start_idx }, { end_.line, end_idx }, {
                    priority = vim.hl.priorities.user,
                })
            end

            contents[#contents + 1] = '---'  -- 添加分隔线
        end
        contents[#contents] = nil  -- 移除最后一个分隔线

        -- 再次检查内容是否为空
        if vim.tbl_isempty(contents) then
            if config.silent ~= true then
                vim.notify 'No information available'
            end
            return
        end

        -- 打开浮动预览窗口
        local _, winid = util.open_floating_preview(contents, format, config)

        -- 当浮动窗口关闭时，清除高亮
        api.nvim_create_autocmd('WinClosed', {
            pattern = tostring(winid),
            once = true,
            callback = function()
                api.nvim_buf_clear_namespace(bufnr, hover_ns, 0, -1)
            end,
        })
    end)
end

-- 应用 LSP 配置的主函数
function LspConfig.apply()
    -- 要启用的 LSP 服务器列表
    local lsp_list = {
        'lua_ls',           -- Lua 语言服务器
        'shellcheck',       -- Shell 脚本语言服务器
        -- 'clangd',           -- C/C++ 语言服务器
        -- 'rust_analyzer',    -- Rust 语言服务器
        'pyright',          -- Python 语言服务器
        -- 'neocmake',         -- CMake 语言服务器
        -- 'clice',         -- 已注释的服务器
    }

    -- 启用所有配置的语言服务器
    for _, name in ipairs(lsp_list) do
        vim.lsp.enable(name)
    end

    -- 使用自定义的 hover 函数替换默认行为
    vim.lsp.buf.hover = hover

    -- 当 LSP 附加到缓冲区时触发的自动命令
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
            ---@diagnostic disable: unused-local
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            local bufnr = event.buf
            
            -- 设置键盘映射
            -- gd: 跳转到定义
            vim.keymap.set(
                'n',
                'gd',
                vim.lsp.buf.definition,
                { desc = 'LSP Goto Definition', noremap = true, silent = true }
            )
            
            -- gD: 跳转到声明
            vim.keymap.set(
                'n',
                'gD',
                vim.lsp.buf.declaration,
                { desc = 'LSP Goto Declaration', noremap = true, silent = true }
            )
            
            -- <leader>lr: 重命名符号
            vim.keymap.set(
                'n',
                '<leader>lr',
                vim.lsp.buf.rename,
                { desc = 'LSP Rename Symbol', noremap = true, silent = true }
            )
            
            -- <leader>lh: 切换内联提示
            vim.keymap.set('n', '<leader>lh', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
            end, { buffer = bufnr, desc = 'Toggle inlay hints' })
        end,
    })

    -- LspInfo 命令：显示活跃的 LSP 客户端信息
    vim.api.nvim_create_user_command('LspInfo', function()
        local clients = vim.lsp.get_clients()
        if #clients == 0 then
            print 'No active LSP clients.'
            return
        end

        for _, client in ipairs(clients) do
            print(
                string.format(
                    'Client ID: %d | Name: %s | Attached Buffers: %s',
                    client.id,
                    client.name,
                    vim.inspect(client.attached_buffers)
                )
            )
        end
    end, {})

    -- LspStatus 命令：检查 LSP 健康状态（别名）
    vim.api.nvim_create_user_command('LspStatus', ':checkhealth vim.lsp', { desc = 'Alias to checkhealth lsp' })

    -- LspLog 命令：在新标签页中打开 LSP 日志文件
    vim.api.nvim_create_user_command('LspLog', function()
        vim.cmd(string.format('tabnew %s', vim.lsp.get_log_path()))
    end, {
        desc = 'Opens the Nvim LSP client log.',
    })

    -- LspStart 命令：启动指定的语言服务器
    vim.api.nvim_create_user_command('LspStart', function(info)
        local servers = info.fargs
        if #servers == 0 then
            -- 如果未指定服务器，根据当前文件类型自动启动
            local ft = vim.bo.filetype
            ---@diagnostic disable:invisible
            for name, _ in pairs(vim.lsp.config._configs) do
                local fts = vim.lsp.config[name].filetypes
                if fts and vim.tbl_contains(fts, ft) then
                    table.insert(servers, name)
                    print('Started LSP: [' .. name .. ']')
                end
            end
        end
        vim.lsp.enable(servers)
    end, {
        desc = 'Enable and launch a language server',
        nargs = '?',
        complete = function()
            return lsp_list  -- 命令补全
        end,
    })

    -- LspStop 命令：停止当前缓冲区的所有 LSP 客户端
    vim.api.nvim_create_user_command('LspStop', function()
        local bufnr = vim.api.nvim_get_current_buf()
        for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
            ---@diagnostic disable-next-line: param-type-mismatch
            client.stop(true)
            print('Stopped LSP: [' .. client.name .. ']')
        end
    end, {})

    -- LspRestart 命令：重启当前缓冲区的所有 LSP 客户端
    vim.api.nvim_create_user_command('LspRestart', function()
        local bufnr = vim.api.nvim_get_current_buf()
        for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
            local config = client.config
            ---@diagnostic disable-next-line: param-type-mismatch
            client.stop(true)  -- 停止客户端
            vim.defer_fn(function()
                vim.lsp.start(config)  -- 延迟 100ms 后重新启动
                print('Restarted LSP: [' .. client.name .. ']')
            end, 100)
        end
    end, {})
end

return LspConfig