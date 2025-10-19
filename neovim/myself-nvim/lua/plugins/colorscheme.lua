-- 如果使用lazyvim用第一个，自己配置用第二个或第三个
-- return {
--   -- add gruvbox
--   { "tjdevries/colorbuddy.nvim" },
--
--   -- Configure LazyVim to load gruvbox
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "gruvbuddy",
--       -- Shatur/neovim-ayu
--     },
--   },
-- }
return {
  lazy = false,
  priority = 1000,
  -- dir = "~/plugins/colorbuddy.nvim",
  "tjdevries/colorbuddy.nvim",
  config = function()
    vim.cmd.colorscheme("gruvbuddy")
  end,
}
-- return {
--   "everviolet/nvim",
--   name = "evergarden",
--   priority = 1000,
--   opt = {
--     theme = {
--       variant = "winter", -- 'winter'|'fall'|'spring'|'summer'
--       accent = "green",
--     },
--     editor = {
--       transparent_background = false,
--       override_terminal = true,
--       sign = { color = "none" },
--       float = {
--         color = "mantle",
--         solid_border = false,
--       },
--       completion = {
--         color = "surface0",
--       },
--     },
--     style = {
--       tabline = { "reverse" },
--       search = { "italic", "reverse" },
--       incsearch = { "italic", "reverse" },
--       types = { "italic" },
--       keyword = { "italic" },
--       comment = { "italic" },
--     },
--     overrides = {},
--     color_overrides = {},
--   },
-- }
