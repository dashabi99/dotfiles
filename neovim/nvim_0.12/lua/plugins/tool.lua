vim.pack.add({
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/NvChad/nvim-colorizer.lua" },
    { src = "https://github.com/folke/flash.nvim" },
    { src = "https://github.com/tpope/vim-fugitive" },
})
-- 自动补全括号插件
-- require("nvim-autopairs").setup()
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
    group = vim.api.nvim_create_augroup("SetupCompletion", { clear = true }),
    once = true,
    callback = function()
        require("nvim-autopairs").setup()
    end,
})
-- 终端显示颜色
require("colorizer").setup()
-- 快速跳转,按s触发
require("flash").setup()
vim.keymap.set("n", "s", function() require("flash").jump() end, { desc = "Flash" })
