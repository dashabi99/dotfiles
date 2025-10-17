return {
  "folke/noice.nvim",
  opts = {
    -- 关闭所有不需要的功能
    -- presets = {
    --   bottom_search = false,
    --   command_palette = false,
    --   long_message_to_split = false,
    --   inc_rename = false,
    --   lsp_doc_border = false,
    -- },

    -- 关闭 cmdline 和 messages
    cmdline = { enabled = false },
    messages = { enabled = false },
    -- popupmenu = { enabled = false }, -- 也关闭弹出菜单

    init = function()
      -- 恢复原生样式
      vim.opt.cmdheight = 1
      -- vim.opt.laststatus = 3
    end,
  },
}
