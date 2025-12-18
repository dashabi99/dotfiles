require("config.options")
require("config.keymaps")
require("config.autocmds")
-- unixchad的主题
require("config.colors")
-- 插件主题
-- require("plugins.colorscheme")

-- ===插件===
-- 图标
require("plugins.nvim-web-devicons")
-- 状态栏
require("plugins.statusline")
-- 补全
require("plugins.blink")
-- 文件管理器
require("plugins.oil")
-- lsp
require("plugins.lsp")
-- 语法高亮
--require("plugins.treesitter")
-- 一些小插件（自动括号，显示颜色，快速跳转）
require("plugins.tool")
-- 模糊查找器
require("plugins.snacks")
-- 自带终端配置
require("plugins.terminal")

-- 卸载插件 命令模式：lua vim.pack.del({"lock.json的插件名字"})
-- 更新全部插件 命令模式：lua vim.pack.update()
