-- 如果是使用的lazyvim用上面的，如果使用的自己配置的用下面的
return {
  -- add gruvbox
  { "tjdevries/colorbuddy.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbuddy",
      -- Shatur/neovim-ayu
    },
  },
}
-- return {
--   lazy = false,
--   priority = 1000,
--   -- dir = "~/plugins/colorbuddy.nvim",
--   "tjdevries/colorbuddy.nvim",
--   config = function()
--     vim.cmd.colorscheme("gruvbuddy")
--   end,
-- }
