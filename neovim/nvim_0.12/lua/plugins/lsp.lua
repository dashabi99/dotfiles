vim.pack.add({
    { src = 'https://github.com/mason-org/mason.nvim' }, -- LSP 安装管理器
    { src = 'https://github.com/neovim/nvim-lspconfig' }, -- LSP 配置
})
require('mason').setup()

-- 文档网站：https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') }, -- Lua 运行时
            diagnostics = { globals = { 'vim' } }, -- 忽略全局变量 vim 的警告
            workspace = {
                checkThirdParty = false,
            },
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
            },
        },
    },
})
vim.lsp.config('bashls', {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'sh', 'bash', 'zsh' }, -- 需要 zsh 就加上
    root_dir = vim.fs.root(0, { '.git', '.bashrc', '.zshrc' }),
    single_file_support = true,
})
-- 启动lsp
vim.lsp.enable('lua_ls')
vim.lsp.enable('pylsp')
vim.lsp.enable('bashls')
-- 诊断
vim.diagnostic.config({ virtual_text = true }) -- 行内文本提示
-- vim.diagnostic.config({ virtual_lines = true }) -- 虚拟行提示（可选）

-- lsp快捷键
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Find references' })
