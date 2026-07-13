vim.pack.add({
    -- snippet 引擎
    { src = 'https://github.com/L3MON4D3/LuaSnip' },
    -- snippet 集合（friendly-snippets）
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
    -- 补全引擎
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') },
})

-- 先配置 LuaSnip 和 friendly-snippets
-- LuaSnip 是后续配置的必要依赖，因此直接 require，让错误尽早暴露。
local luasnip = require('luasnip')

luasnip.config.setup({
    -- 如果当前 LuaSnip 版本不识别该名称，再改回 updateevents。
    update_events = 'TextChanged,TextChangedI',
    enable_autosnippets = true,
})

require('luasnip.loaders.from_vscode').lazy_load()

-- 再配置 blink.cmp
require('blink.cmp').setup({
    keymap = {
        preset = 'enter',
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    },
    appearance = {
        nerd_font_variant = 'mono',
    },
    -- 自动显示当前函数的信息
    completion = {
        documentation = { auto_show = true, scrollbar = false },
        list = {
            selection = {
                -- 不预选第一个
                preselect = false,
                -- 选中时自动插入
                -- auto_insert = false,
            },
        },
    },
    -- 命令模式不自动显示补全，tab显示，回车确认
    cmdline = {
        completion = {
            menu = {
                auto_show = false,
                scrollbar = false,
            },
        },
        keymap = {
            ['<CR>'] = { 'select_and_accept', 'fallback' },
            ['<Tab>'] = { 'show', 'select_next', 'fallback' },
        },
    },
    -- 编辑代码时自动显示信息
    signature = {
        enabled = true,
        scrollbar = false,
    },
    -- 使用 LuaSnip 预设
    snippets = {
        preset = 'luasnip',
    },
    sources = {
        -- 'snippets' 源会从 LuaSnip 中取片段
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = 'lua' },
})
