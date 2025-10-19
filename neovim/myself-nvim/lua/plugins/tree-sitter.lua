-- Treesitter 语法高亮

return {
    'nvim-treesitter/nvim-treesitter',

    -- ✅ 重要：确保安装命令正确
    build = function()
        require('nvim-treesitter.install').update({ with_sync = true })()
    end,

    -- ✅ 改为立即加载，不要懒加载（排除加载时机问题）
    lazy = false,
    priority = 1000,

    config = function()
        -- ✅ 安全检查
        local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
        if not status_ok then
            vim.notify(
                'Error: nvim-treesitter.configs not found!\n' ..
                'Please run: :Lazy sync\n' ..
                'Then run: :TSUpdate',
                vim.log.levels.ERROR
            )
            return
        end

        configs.setup {
            ensure_installed = {
                'c',
                'lua',
                'vim',
                'vimdoc',
                'cpp',
                'python',
                'json',
                'yaml',
                'bash',
                'markdown',
                'markdown_inline',
            },

            sync_install = false,
            auto_install = true,

            highlight = {
                enable = true,
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<CR>',
                    node_incremental = '<CR>',
                    scope_incremental = '<S-CR>',
                    node_decremental = '<BS>',
                },
            },

            indent = {
                enable = true,
            },
        }
    end,
}
