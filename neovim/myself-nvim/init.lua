-- https://github.com/aurora0x27/nvim-config/tree/main  基于此配置修改

-- ============================================================================
-- Neovim 配置入口文件
-- 功能: 管理插件加载、用户配置初始化和 Lazy.nvim 插件管理器设置
-- ============================================================================
-- ----------------------------------------------------------------------------
-- 用户配置延迟加载
-- 在 Lazy.nvim 完成插件加载后，通过自动命令触发用户配置的应用
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd('User', {
    -- 监听 LazyVimStarted 事件，该事件在 Lazy.nvim 启动完成后触发
    pattern = 'LazyVimStarted',

    callback = function()
        -- 使用 vim.schedule 将配置加载推迟到下一个事件循环
        -- 这样可以确保所有插件已经完全加载，避免竞态条件
        vim.schedule(function()
            -- 按顺序加载各个配置模块
            require('config.keymaps').apply()     -- 键位映射配置
            require('config.options').apply()     -- Vim 选项配置
            require('config.autocmd').apply()     -- 自动命令配置
            require('config.diagnostics').apply() -- 诊断信息配置
            require('config.lsp').apply()         -- LSP 语言服务器配置
            -- require('config.ssh_mode').apply()    -- SSH 模式配置
            require('config.pairs').apply()       -- 括号自动配对配置
            -- require('config.patch').apply()       -- 匹配工作区域路径配置
        end)
    end
})

-- ----------------------------------------------------------------------------
-- 预加载配置
-- 在插件管理器初始化前需要执行的配置，通常包含一些核心设置
-- ----------------------------------------------------------------------------
require('config.preload').apply()

-- ----------------------------------------------------------------------------
-- Lazy.nvim 插件管理器初始化
-- ----------------------------------------------------------------------------

-- 设置 Lazy.nvim 的安装路径
-- stdpath('data') 返回 Neovim 数据目录路径（通常是 ~/.local/share/nvim）
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

-- 检查 Lazy.nvim 是否已安装
---@diagnostic disable: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    -- 如果未安装，则从 GitHub 克隆 Lazy.nvim 仓库
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'

    -- 执行 git clone 命令
    -- --filter=blob:none: 使用部分克隆，只下载必要的文件，加快克隆速度
    -- --branch=stable: 克隆稳定分支
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }

    -- 检查克隆是否成功
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end

-- 将 Lazy.nvim 路径添加到 Neovim 的运行时路径（runtimepath）
-- prepend 表示添加到路径列表的最前面，确保优先加载
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- ----------------------------------------------------------------------------
-- 插件配置和加载
-- 使用 Lazy.nvim 的 setup 函数初始化插件管理系统
-- ----------------------------------------------------------------------------
require('lazy').setup {
    -- 插件规格配置
    spec = { -- 从 lua/plugins 目录导入所有插件配置文件
        -- 该目录下的每个 .lua 文件都应该返回一个插件配置表
        {
            import = 'plugins'
        } },

     install = {
        colorscheme = { 'catppuccin' },
    },

    -- UI 界面配置
    ui = {
        backdrop = 100,    -- 背景透明度 (0-100)，100 表示完全不透明
        width = 0.8,       -- 窗口宽度，0.8 表示占屏幕宽度的 80%
        height = 0.8,      -- 窗口高度，0.8 表示占屏幕高度的 80%
        border = 'rounded' -- 窗口边框样式：rounded（圆角）
    },

    -- 性能优化配置
    performance = {
        rtp = {
            -- 禁用的运行时插件列表
            -- 可以在这里添加不需要的内置插件，以提升启动速度
            -- 例如: 'gzip', 'matchit', 'netrwPlugin', 'tarPlugin' 等
            disabled_plugins = {
                "gzip", -- gzip 文件支持（如果不编辑压缩文件可禁用）
                -- "matchit",  -- 增强的 % 匹配（建议保留）
                -- "matchparen", -- 括号高亮匹配（建议保留）
                "netrwPlugin", -- 内置文件浏览器（如果使用其他文件管理器可禁用）
                "tarPlugin", -- tar 归档文件支持
                "tohtml",  -- 转换为 HTML 功能
                "tutor",   -- Neovim 教程
                "zipPlugin" -- zip 文件支持
            }
        }
    },

    -- 配置钩子函数
    -- 在 Lazy.nvim 完成配置后执行
    config = function()
        -- 注意: 选项和键位映射的应用已经移到了上面的 LazyVimStarted 自动命令中
        -- 因为插件加载是异步的，需要等待所有插件加载完成后再应用配置
        -- 这里可以添加其他需要在配置完成后立即执行的代码
    end

    -- 类型注解标记，用于 Lua 语言服务器的类型检查
    ---@diagnostic disable: undefined-doc-name
} --[[@as LazyConfig]]
-- ----------------------------------------------------------------------------
