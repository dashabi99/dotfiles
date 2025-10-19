-- ============================================================================
-- 键位映射配置文件
-- 此文件包含所有自定义键位映射，在 Lazy.nvim 初始化完成后执行
-- 确保所有插件已加载，避免键位映射引用不存在的插件功能
-- ============================================================================

local KeyMaps = {}

-- ----------------------------------------------------------------------------
-- 应用键位映射配置
-- 此函数在插件加载完成后执行，设置所有自定义快捷键
-- ----------------------------------------------------------------------------
function KeyMaps.apply()
    -- ------------------------------------------------------------------------
    -- 辅助函数：延迟加载插件函数
    -- 用途：避免在配置时立即加载插件，提升启动速度
    -- 只有在实际使用快捷键时才加载对应的插件功能
    -- ------------------------------------------------------------------------
    -- @param module string 插件模块名称
    -- @param ... string 要访问的字段路径（支持嵌套）
    -- @return function 返回一个延迟执行的函数
    --
    -- 示例：select('telescope.builtin', 'find_files')
    --       等价于：require('telescope.builtin').find_files()
    local function select(module, ...)
        local fields = { ... }
        return function()
            -- 首次调用时才加载插件模块
            local mod = require(module)
            -- 遍历字段路径，逐层访问
            for i = 1, #fields - 1 do
                mod = mod[fields[i]]
            end
            -- 调用最终的函数
            mod[fields[#fields]]()
        end
    end

    -- ========================================================================
    -- 窗口管理相关快捷键
    -- ========================================================================

    -- ------------------------------------------------------------------------
    -- 窗口大小调整（使用方向键）
    -- 使用 smart-splits 插件提供智能窗口调整功能
    -- ------------------------------------------------------------------------
    vim.keymap.set('n', '<C-Left>', select('smart-splits', 'resize_left'), 
        { noremap = true, silent = true })  -- Ctrl+左箭头：向左扩展窗口
    vim.keymap.set('n', '<C-Right>', select('smart-splits', 'resize_right'), 
        { noremap = true, silent = true })  -- Ctrl+右箭头：向右扩展窗口
    vim.keymap.set('n', '<C-Up>', select('smart-splits', 'resize_up'), 
        { noremap = true, silent = true })  -- Ctrl+上箭头：向上扩展窗口
    vim.keymap.set('n', '<C-Down>', select('smart-splits', 'resize_down'), 
        { noremap = true, silent = true })  -- Ctrl+下箭头：向下扩展窗口

    -- ------------------------------------------------------------------------
    -- 窗口间光标移动（Vim 风格：hjkl）
    -- 使用 smart-splits 插件提供智能窗口切换功能
    -- 可以在 Vim 分屏和 Tmux 窗格之间无缝切换
    -- ------------------------------------------------------------------------
    vim.keymap.set(
        'n',
        '<C-h>',
        select('smart-splits', 'move_cursor_left'),
        { desc = 'Move to left window', noremap = true, silent = true }
    )  -- Ctrl+h：移动到左侧窗口
    vim.keymap.set(
        'n',
        '<C-j>',
        select('smart-splits', 'move_cursor_down'),
        { desc = 'Move to below window', noremap = true, silent = true }
    )  -- Ctrl+j：移动到下方窗口
    vim.keymap.set(
        'n',
        '<C-k>',
        select('smart-splits', 'move_cursor_up'),
        { desc = 'Move to above window', noremap = true, silent = true }
    )  -- Ctrl+k：移动到上方窗口
    vim.keymap.set(
        'n',
        '<C-l>',
        select('smart-splits', 'move_cursor_right'),
        { desc = 'Move to right window', noremap = true, silent = true }
    )  -- Ctrl+l：移动到右侧窗口

    -- ========================================================================
    -- 缓冲区（Buffer）切换相关快捷键
    -- ========================================================================

    -- ------------------------------------------------------------------------
    -- 使用 H 和 L 快速切换缓冲区（类似浏览器的前进/后退）
    -- ------------------------------------------------------------------------
    vim.keymap.set('n', 'H', '<cmd>bp<CR>', 
        { noremap = true, silent = true })  -- H：切换到上一个缓冲区（buffer previous）
    vim.keymap.set('n', 'L', '<cmd>bn<CR>', 
        { noremap = true, silent = true })  -- L：切换到下一个缓冲区（buffer next）

    -- ========================================================================
    -- Telescope 模糊查找相关快捷键
    -- 前缀：<Leader>f（f = find，查找）
    -- ========================================================================

    -- ------------------------------------------------------------------------
    -- 文件和内容查找
    -- ------------------------------------------------------------------------
    vim.keymap.set(
        'n',
        '<Leader>ff',
        select('telescope.builtin', 'find_files'),
        { desc = 'Telescope Find Files', noremap = true, silent = true }
    )  -- <Leader>ff：查找文件（模糊搜索文件名）

    vim.keymap.set(
        'n',
        '<Leader>fo',
        select('telescope.builtin', 'oldfiles'),
        { desc = 'Telescope Find Recent Files', noremap = true, silent = true }
    )  -- <Leader>fo：查找最近打开的文件（oldfiles）

    vim.keymap.set(
        'n',
        '<Leader>fw',
        select('telescope.builtin', 'live_grep'),
        { desc = 'Telescope Find Word', noremap = true, silent = true }
    )  -- <Leader>fw：全局搜索文本内容（live grep）

    vim.keymap.set(
        'n',
        '<Leader>fb',
        select('telescope.builtin', 'buffers'),
        { desc = 'Telescope Find Buffer', noremap = true, silent = true }
    )  -- <Leader>fb：查找并切换缓冲区

    -- ------------------------------------------------------------------------
    -- 代码相关查找
    -- ------------------------------------------------------------------------
    vim.keymap.set(
        'n',
        '<Leader>fd',
        select('telescope.builtin', 'diagnostics'),
        { desc = 'Telescope Find Diagnostics', noremap = true, silent = true }
    )  -- <Leader>fd：查找代码诊断信息（错误、警告等）

    vim.keymap.set(
        'n',
        '<Leader>fs',
        select('telescope.builtin', 'lsp_dynamic_workspace_symbols'),
        { desc = 'Telescope Find Workspace Symbols', noremap = true, silent = true }
    )  -- <Leader>fs：查找工作区符号（函数、变量、类等）

    -- ------------------------------------------------------------------------
    -- Git 相关查找
    -- ------------------------------------------------------------------------
    vim.keymap.set(
        'n',
        '<Leader>fg',
        select('telescope.builtin', 'git_status'),
        { desc = 'Telescope Find Git Diff', noremap = true, silent = true }
    )  -- <Leader>fg：查看 Git 状态和差异

    -- ------------------------------------------------------------------------
    -- 其他查找功能
    -- ------------------------------------------------------------------------
    vim.keymap.set(
        'n',
        '<Leader>fm',
        select('telescope', 'extensions', 'noice', 'noice'),
        { desc = 'Telescope Filter Noice Msg', noremap = true, silent = true }
    )  -- <Leader>fm：过滤 Noice 插件的消息记录

    vim.keymap.set(
        'n',
        '<Leader>ft',
        '<cmd>TodoTelescope<CR>',
        { desc = 'Telescope Filter Todo Items', noremap = true, silent = true }
    )  -- <Leader>ft：查找代码中的 TODO 注释

    -- ========================================================================
    -- 缓冲区管理相关快捷键
    -- 前缀：<Leader>b（b = buffer）
    -- ========================================================================

    vim.keymap.set(
        'n',
        '<Leader>bd',
        '<cmd>bp | bd #<CR>',
        { desc = 'Buffer close current', noremap = true, silent = true }
    )  -- <Leader>bd：关闭当前缓冲区（保持窗口布局）
       -- 命令解析：bp（切换到上一个缓冲区）| bd #（删除原缓冲区）

    -- ========================================================================
    -- LSP 和诊断相关快捷键
    -- 前缀：<Leader>l（l = LSP）
    -- ========================================================================

    vim.keymap.set(
        'n',
        '<Leader>lg',
        select('telescope.builtin', 'git_commits'),
        { desc = 'Search Git Commits', noremap = true, silent = true }
    )  -- <Leader>lg：搜索 Git 提交记录

    vim.keymap.set(
        'n',
        '<Leader>lD',
        select('telescope.builtin', 'diagnostics'),
        { desc = 'Search diagnostics', noremap = true, silent = true }
    )  -- <Leader>lD：搜索诊断信息

    -- ========================================================================
    -- 光标移动优化
    -- ========================================================================

    -- ------------------------------------------------------------------------
    -- 使 j 和 k 在换行文本中按屏幕行移动（而非逻辑行）
    -- 适用于长文本编辑，让光标移动更符合视觉习惯
    -- ------------------------------------------------------------------------
    vim.keymap.set({ 'n', 'v' }, 'j', 'gj', 
        { noremap = true, silent = true })  -- j：向下移动一个屏幕行
    vim.keymap.set({ 'n', 'v' }, 'k', 'gk', 
        { noremap = true, silent = true })  -- k：向上移动一个屏幕行

    -- ========================================================================
    -- 文件浏览器相关快捷键（已注释）
    -- ========================================================================

    -- ------------------------------------------------------------------------
    -- NeoTree 文件浏览器切换（当前已禁用）
    -- 如果需要使用，取消注释以下代码
    -- ------------------------------------------------------------------------
    -- vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', {
    --     desc = 'Toggle NeoTree file explorer',
    --     noremap = true,
    --     silent = true,
    -- })  -- <Leader>e：切换 NeoTree 文件浏览器

    -- ========================================================================
    -- 编辑器辅助功能
    -- ========================================================================
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', 
        { silent = true })  -- Esc：清除搜索高亮

    -- 更好的缩进
    vim.keymap.set("v", "<", "<gv", { desc = "向左缩进" })
    vim.keymap.set("v", ">", ">gv", { desc = "向右缩进" })

    -- 移动文本
    vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "向下移动文本" })
    vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "向上移动文本" })

    --如果你使用了wezterm终端，且用ctrl+v粘贴，那么改建可视化块模式的键位 vv
    vim.keymap.set("n", "vv", "<C-v>", { noremap = true })
    -- 插入模式下，将 'jk' 映射为 'Esc'
    vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

    -- 命令行模式下，将 'jk' 映射为 'Esc'
    vim.keymap.set("c", "jk", "<Esc>", { noremap = true, silent = true })

    -- ========================================================================
    -- 键位映射清理
    -- ========================================================================

    -- ------------------------------------------------------------------------
    -- 删除选择模式（Select mode）中的 j 和 k 映射
    -- 避免与其他插件的键位冲突
    -- ------------------------------------------------------------------------
    vim.keymap.del('s', 'j')  -- 删除选择模式的 j 映射
    vim.keymap.del('s', 'k')  -- 删除选择模式的 k 映射
end

return KeyMaps