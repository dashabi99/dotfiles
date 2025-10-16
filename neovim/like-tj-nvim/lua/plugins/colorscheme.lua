-- 上面的颜色比下面的好看一点
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
