return {
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true, -- #RGB 十六进制颜色
          RRGGBB = true, -- #RRGGBB 十六进制颜色
          names = true, -- "Name" 颜色代码如 Blue 或 blue
          RRGGBBAA = true, -- #RRGGBBAA 十六进制颜色
          AARRGGBB = true, -- 0xAARRGGBB 十六进制颜色
          rgb_fn = true, -- CSS rgb() 和 rgba() 函数
          hsl_fn = true, -- CSS hsl() 和 hsla() 函数
          css = true, -- 启用所有 CSS 功能
          css_fn = true, -- 启用所有 CSS *函数*
          mode = "background", -- 可选值: foreground, background, virtualtext
          tailwind = false, -- 启用 tailwind 颜色
          sass = { enable = false }, -- 启用 sass 颜色
          virtualtext = "■",
          always_update = false,
        },
        buftypes = {},
      })
    end,
  },
}
