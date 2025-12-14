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
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
            },
            format = { enable = true }, -- 启用格式化
        },
    },
})
-- pyright不支持格式化，建议下载pylsp或者python专门的格式化工具例如isort，ruff等
vim.lsp.enable({ "lua_ls", "pyright" })
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
