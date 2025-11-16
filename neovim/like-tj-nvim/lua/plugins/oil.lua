return {
  -- 启用 oil.nvim 替代
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      CustomOilBar = function()
        local path = vim.fn.expand("%")
        path = path:gsub("oil://", "")
        return "  " .. vim.fn.fnamemodify(path, ":.")
      end

      require("oil").setup({
        default_file_explorer = true, -- 替代 netrw 作为默认文件浏览器
        use_default_keymaps = false, -- 不使用默认键位（自定义键位）
        delete_to_trash = true, -- 删除文件到回收站而非永久删除
        skip_confirm_for_simple_edits = true, -- 简单编辑跳过确认
        watch_for_changes = true, -- 监听外部文件变化
        columns = { "icon" },
        keymaps = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          ["|"] = { "actions.select", opts = { vertical = true } }, -- 左右分屏
          ["_"] = { "actions.select", opts = { horizontal = true } }, -- 上下分屏
          ["K"] = { "actions.preview", mode = "n" }, -- 预览文件
          ["<BS>"] = { "actions.parent", mode = "n" }, -- 往上一级目录导航
          ["-"] = { "actions.open_cwd", mode = "n" }, -- 回到打开文件时的目录
          -- ["n"] = { "actions.select", opts = { tab = true } }, -- 新标签页打开
          ["<CR>"] = "actions.select", -- 回车打开文件/目录
          -- ["<C-c>"] = "actions.close", -- 关闭 Oil
          ["q"] = "actions.close", -- 关闭 Oil
          ["gs"] = "actions.change_sort", -- 改变排序方式
          ["gx"] = "actions.open_external", -- 用外部程序打开
          ["g."] = "actions.toggle_hidden", -- 切换显示隐藏文件
          ["g\\"] = "actions.toggle_trash", -- 切换回收站视图
          ["g?"] = "actions.show_help", -- 显示帮助
        },
        -- 浏览别的目录时显示路径
        win_options = {
          winbar = "%{v:lua.CustomOilBar()}",
        },
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, _)
            local folder_skip = { "dev-tools.locks", "dune.lock", "_build" }
            return vim.tbl_contains(folder_skip, name)
          end,
        },
      })

      -- Open parent directory in current window
      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      -- Open parent directory in floating window
      vim.keymap.set("n", "<leader>E", require("oil").toggle_float)
    end,
  },

  -- 禁用 bufferline，使用原生标签页
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
}
