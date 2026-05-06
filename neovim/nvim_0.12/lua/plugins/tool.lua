vim.pack.add({
    { src = 'https://github.com/NvChad/nvim-colorizer.lua' },
    { src = 'https://github.com/folke/flash.nvim' },
    { src = 'https://github.com/echasnovski/mini.nvim' },
})

-- 终端显示颜色
require('colorizer').setup()
-- 快速跳转,按s触发
require('flash').setup()
vim.keymap.set('n', 's', function()
    require('flash').jump()
end, { desc = 'Flash' })

require('mini.ai').setup({})
require('mini.comment').setup({})
require('mini.surround').setup({})
require('mini.cursorword').setup({})
require('mini.pairs').setup({})
require('mini.bufremove').setup({})
-- require("mini.notify").setup({})
-- vim.notify = MiniNotify.make_notify()

require('mini.indentscope').setup({})

require('mini.trailspace').setup({})

-- 保存时删除尾部空格
vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
        if vim.bo.buftype ~= '' then
            return
        end
        MiniTrailspace.trim()
        MiniTrailspace.trim_last_lines()
    end,
})
