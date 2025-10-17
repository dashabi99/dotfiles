vim.opt.shortmess:remove("I") -- 移除 'I' 标志以显示 intro 消息
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- 禁用仪表盘
    dashboard = { enabled = false },
    picker = {
      enabled = true, -- 保留 picker 功能
      sources = {
        explorer = { enabled = false }, -- 禁用文件管理器，使用oil插件，但是不禁用快捷键好像没用
      },
    },
  },
}
