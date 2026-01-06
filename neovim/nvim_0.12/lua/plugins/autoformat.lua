vim.pack.add({
    { src = 'https://github.com/stevearc/conform.nvim' },
})
require('conform').setup({
    formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'yapf' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
    },
})

-- 格式化快捷键
vim.keymap.set({ 'n' }, '<leader>lf', function()
    require('conform').format({
        async = true,
        lsp_fallback = true,
        timeout_ms = 500,
    })
end, { desc = 'Format file' })
