vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})
require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'python', 'json', 'vim', 'markdown', 'bash', 'vimdoc', 'toml' }, -- 安装的语言
    highlight = { enable = true },                                                               -- 语法高亮
    indent = { enable = true },                                                                  -- 缩进
})
