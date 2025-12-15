vim.pack.add({
    { src = 'https://github.com/mason-org/mason.nvim' },  -- LSP 安装管理器
    { src = 'https://github.com/neovim/nvim-lspconfig' }, -- LSP 配置
})
require("mason").setup()
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') }, -- Lua 运行时
            diagnostics = { globals = { 'vim' } },                                 -- 忽略全局变量 vim 的警告
            workspace = {
                checkThirdParty = false,
            },
            -- format = { enable = true }, -- 启用lua_ls作为格式化工具
            stylua = { enabled = true }, -- 启用stylua作为格式化工具
        },
    },
})
vim.lsp.config('pylsp', {
    settings = {
        pylsp = {
            plugins = {
                -- 补全相关,两个留一个
                -- rope_completion = { enabled = true },
                jedi_completion = { enabled = true },
                -- 变量诊断
                pyflakes = { enabled = true },
                pycodestyle = { enabled = true, maxLineLength = 120 },
                yapf = { enabled = true }, -- 使用 pylsp 的 yapf 插件
            },
        },
    },
})
-- 只启动lua的, python或者别的lsp放到after目录下启动
vim.lsp.enable("lua_ls")
-- 诊断
vim.diagnostic.config({ virtual_text = true }) -- 行内文本提示
-- vim.diagnostic.config({ virtual_lines = true }) -- 虚拟行提示（可选）

-- 格式化快捷键
vim.keymap.set('n', '<leader>lf', function()
    vim.lsp.buf.format()
end, { desc = 'format' })

-- 保存前自动格式化
vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
        vim.lsp.buf.format()
    end,
    pattern = '*',
})
