vim.pack.add({
    { src = 'https://github.com/NvChad/nvim-colorizer.lua' },
    { src = 'https://github.com/folke/flash.nvim' },
    { src = 'https://github.com/echasnovski/mini.nvim' },
})

-- 终端显示颜色
require('colorizer').setup()

-- 快速跳转,按s触发
local flash = require('flash')
flash.setup()
vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
    flash.jump()
end, {
    desc = 'Flash Jump',
})

require('mini.ai').setup({})
require('mini.comment').setup({})
require('mini.surround').setup({})
require('mini.pairs').setup({})
require('mini.bufremove').setup({})

require('mini.cursorword').setup()
require('mini.indentscope').setup()
-- 如果是大文件（>1M,或者超过10000行）禁用上面这两个插件
local group = vim.api.nvim_create_augroup('DisableMiniForLargeFiles', {
    clear = true,
})

-- 判断当前缓冲区是否属于大文件
local function is_large_file(buf)
    -- 超过 1 MiB
    local max_size = 1024 * 1024

    -- 超过 10,000 行
    local max_lines = 10000

    local file = vim.api.nvim_buf_get_name(buf)

    if file ~= '' then
        local stat = vim.uv.fs_stat(file)

        if stat and stat.size > max_size then
            return true
        end
    end

    return vim.api.nvim_buf_line_count(buf) > max_lines
end

-- 不需要这些效果的文件类型
local disabled_filetypes = {
    help = true,
    lazy = true,
    mason = true,
    notify = true,
    snacks_dashboard = true,
    snacks_picker_input = true,
    snacks_picker_list = true,
    terminal = true,
    toggleterm = true,
    Trouble = true,
}

vim.api.nvim_create_autocmd({
    'BufReadPost',
    'BufNewFile',
    'FileType',
}, {
    group = group,
    desc = 'Disable Mini cursorword and indentscope when unnecessary',
    callback = function(args)
        local buf = args.buf

        if not vim.api.nvim_buf_is_valid(buf) then
            return
        end

        local bo = vim.bo[buf]

        local should_disable = bo.buftype ~= '' or disabled_filetypes[bo.filetype] or is_large_file(buf)

        if should_disable then
            vim.b[buf].minicursorword_disable = true
            vim.b[buf].miniindentscope_disable = true
        end
    end,
})

local trailspace = require('mini.trailspace')
trailspace.setup()
-- 保存普通文件时：删除行尾空白以及文件末尾多余空行
local trailspace_group = vim.api.nvim_create_augroup('MiniTrailspaceTrim', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
    group = trailspace_group,
    desc = 'Trim trailing whitespace before saving',
    callback = function(args)
        -- 跳过终端、帮助页、快捷列表等特殊缓冲区
        if vim.bo[args.buf].buftype ~= '' then
            return
        end
        trailspace.trim()
        trailspace.trim_last_lines()
    end,
})
