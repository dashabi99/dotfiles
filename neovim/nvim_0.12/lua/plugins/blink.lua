vim.pack.add({
    -- snippet 引擎
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    -- snippet 集合（friendly-snippets）
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    -- 补全引擎
    { src = "https://github.com/saghen/blink.cmp",            version = vim.version.range("1.*") },
})

-- 先配置 LuaSnip 和 friendly-snippets
local ok_luasnip, luasnip = pcall(require, "luasnip")
if ok_luasnip then
    -- 加载 friendly-snippets（VSCode 风格）
    require("luasnip.loaders.from_vscode").lazy_load()

    -- 可选：LuaSnip 一些基础设置
    luasnip.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
    })
end

-- 再配置 blink.cmp
require("blink.cmp").setup({
    keymap = {
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        preset = "enter"
    },
    appearance = {
        nerd_font_variant = "mono",
    },
    -- 不自动显示当前函数的信息，按K查看
    completion = {
        documentation = { auto_show = false },
    },
    -- 命令模式自动显示补全
    cmdline = {
        completion = {
            menu = {
                auto_show = true,
                -- border = "none",
            },
        },
    },
    -- 编辑代码时自动显示信息
    signature = {
        enabled = true
    },
    -- 使用 LuaSnip 预设
    snippets = {
        preset = "luasnip",
    },
    sources = {
        -- 'snippets' 源会从 LuaSnip 中取片段
        default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "lua" },
})
