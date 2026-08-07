vim.pack.add({
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
})

require('nvim-web-devicons').setup()

require('gitsigns').setup({
    signs = {
        add = { text = '+' }, ---@diagnostic disable-line: missing-fields
        change = { text = '~' }, ---@diagnostic disable-line: missing-fields
        delete = { text = '-' }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = '^' }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = '!' }, ---@diagnostic disable-line: missing-fields
        untracked = { text = '?' }, ---@diagnostic disable-line: missing-fields
    },

    signcolumn = true,
    -- 光标行显示提交信息
    current_line_blame = true,
})
