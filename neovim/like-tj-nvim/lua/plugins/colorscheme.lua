-- 如果是使用的lazyvim用上面的，如果使用的自己配置的用下面的
return {
  { "tjdevries/colorbuddy.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbuddy",
    },
  },
}
-- return {
--   lazy = false,
--   priority = 1000,
--   "tjdevries/colorbuddy.nvim",
--   config = function()
--     vim.cmd.colorscheme("gruvbuddy")
--   end,
-- }
