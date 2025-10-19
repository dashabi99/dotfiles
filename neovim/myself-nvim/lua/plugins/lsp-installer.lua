-- ============================================================================
-- Mason 插件配置
-- Mason 是一个 LSP（语言服务器协议）、DAP、Linter 和 Formatter 的安装管理器
-- 提供统一的界面来安装和管理各种开发工具
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 调试开关
-- 如果第一行为 true，整个配置将被禁用（返回空表）
-- 删除或注释掉这行代码来激活此配置文件
-- ----------------------------------------------------------------------------
-- if true then return {} end

-- ----------------------------------------------------------------------------
-- 代理配置
-- 为 Python 包安装配置代理（如果环境变量中设置了 PIP_PROXY）
-- ----------------------------------------------------------------------------
local pip_args
local proxy = os.getenv 'PIP_PROXY'  -- 从环境变量读取代理设置
if proxy then
    -- 如果设置了代理，添加 --proxy 参数
    pip_args = { '--proxy', proxy }
else
    -- 否则使用空参数列表
    pip_args = {}
end

-- ----------------------------------------------------------------------------
-- 自动安装工具函数
-- 确保指定的语言服务器和工具已安装，如果未安装则自动安装
-- ----------------------------------------------------------------------------
-- @param list table 要安装的包名称列表
local function ensure_installed(list)
    -- 获取 Mason 注册表实例
    -- 注册表包含所有可用包的信息
    local registry = require 'mason-registry'

    -- ------------------------------------------------------------------------
    -- 安装单个包的内部函数
    -- ------------------------------------------------------------------------
    -- @param pkg_name string 包的名称
    local function install_package(pkg_name)
        -- 尝试从注册表获取包信息
        local ok, pkg = pcall(registry.get_package, pkg_name)
        
        -- 如果包不存在，发出警告并返回
        if not ok then
            vim.notify(
                ('Package %s not found'):format(pkg_name),  -- 格式化错误消息
                vim.log.levels.WARN                          -- 警告级别
            )
            return
        end
        
        -- 检查包是否已经安装
        if not pkg:is_installed() then
            -- 发送开始安装的通知
            vim.notify('Installing LSP: ' .. pkg_name, vim.log.levels.INFO)
            
            -- 异步安装包
            pkg:install():once('closed', function()
                -- 安装完成后的回调函数
                if pkg:is_installed() then
                    -- 安装成功
                    vim.schedule(function()
                        vim.notify(
                            'LSP installed: ' .. pkg_name, 
                            vim.log.levels.INFO
                        )
                    end)
                else
                    -- 安装失败
                    vim.schedule(function()
                        vim.notify(
                            'Failed to install LSP: ' .. pkg_name, 
                            vim.log.levels.ERROR
                        )
                    end)
                end
            end)
        end
    end

    -- ------------------------------------------------------------------------
    -- 兼容性处理：支持新旧版本的 Mason
    -- ------------------------------------------------------------------------
    if not registry.refresh then
        -- 旧版本 Mason：直接安装包（回退方案）
        for _, name in ipairs(list) do
            install_package(name)
        end
    else
        -- 新版本 Mason：先异步刷新注册表，再安装包
        -- 刷新确保获取最新的包信息
        registry.refresh(function()
            for _, name in ipairs(list) do
                install_package(name)
            end
        end)
    end
end

-- ----------------------------------------------------------------------------
-- Mason 选项配置
-- 配置 Mason 的行为和 UI 界面
-- ----------------------------------------------------------------------------
local MasonOpt = {
    -- ------------------------------------------------------------------------
    -- Python pip 配置
    -- 控制如何安装 Python 相关的工具
    -- ------------------------------------------------------------------------
    pip = {
        upgrade_pip = false,        -- 不自动升级 pip（避免版本冲突）
        install_args = pip_args,    -- 使用上面配置的代理参数
    },
    
    -- ------------------------------------------------------------------------
    -- UI 界面配置
    -- 定制 Mason 窗口的外观
    -- ------------------------------------------------------------------------
    ui = {
        border = 'rounded',         -- 窗口边框样式：圆角
        width = 0.8,                -- 窗口宽度：屏幕宽度的 80%
        height = 0.8,               -- 窗口高度：屏幕高度的 80%
        backdrop = 100,             -- 背景透明度：100（完全不透明）
        
        -- 状态图标定制
        icons = {
            package_installed = '✓',      -- 已安装包的图标
            package_pending = '➜',        -- 安装中的包的图标
            package_uninstalled = '✗',    -- 未安装包的图标
        },
    },
}

-- ----------------------------------------------------------------------------
-- Mason 插件定义
-- 配置 Lazy.nvim 如何加载和初始化 Mason
-- ----------------------------------------------------------------------------
-- 禁用 Lua 语言服务器的未使用局部变量警告
---@diagnostic disable: unused-local
local Mason = {
    -- 插件仓库地址
    'williamboman/mason.nvim',
    
    -- ------------------------------------------------------------------------
    -- 加载时机
    -- VimEnter 事件在 Vim 完全启动后触发，确保所有初始化完成
    -- ------------------------------------------------------------------------
    event = 'VimEnter',
    
    -- ------------------------------------------------------------------------
    -- 配置函数
    -- 在插件加载后执行，初始化 Mason 并安装必要的工具
    -- ------------------------------------------------------------------------
    config = function()
        -- 使用上面定义的选项初始化 Mason
        require('mason').setup(MasonOpt)
        
        -- 自动安装以下工具
        ensure_installed {
            'lua-language-server',  -- Lua 语言服务器（LSP）
            'stylua',               -- Lua 代码格式化工具
            'pyright',              -- Python 语言服务器（类型检查）
            -- 'neocmakelsp',          -- CMake 语言服务器
            'prettier',             -- 前端代码格式化工具（JS/TS/HTML/CSS）
        }
    end,
}

-- 返回插件配置表，供 Lazy.nvim 加载
return Mason