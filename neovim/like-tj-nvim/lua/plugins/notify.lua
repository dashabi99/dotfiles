return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      stages = "fade", -- 动画效果: fade, slide, fade_in_slide_out, static
      render = "minimal", -- 渲染样式: default, minimal, simple, compact
      timeout = 3000, -- 默认显示时间(毫秒)
      max_width = 50,
      max_height = 10,
      background_colour = "#000000",
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      -- 设置为vim的默认通知函数
      vim.notify = notify
    end,
  },
  {
    -- 完全禁用 noice.nvim
    {
      "folke/noice.nvim",
      enabled = false,
    },
  },
}
