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
        -- use_default_keymaps = false, -- 不使用默认键位（自定义键位）
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
          ["\\"] = { "actions.select", opts = { horizontal = true } }, -- 上下分屏
          ["K"] = { "actions.preview", mode = "n" }, -- 预览文件
          ["<BS>"] = { "actions.parent", mode = "n" }, -- 往回导航
          ["_"] = { "actions.open_cwd", mode = "n" }, -- 回到当前目录
        },
        -- 浏览别的目录时现实路径
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
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

      -- Open parent directory in floating window
      vim.keymap.set("n", "<space>-", require("oil").toggle_float)
    end,
  },

  -- 禁用 bufferline，使用原生标签页
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
}
