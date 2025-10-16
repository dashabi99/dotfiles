return {
  "nvim-mini/mini.tabline",
  version = false,
  config = {
    -- 是否显示图标（需要 nvim-web-devicons）
    show_icons = false,
    -- 设置 Vim 的默认选项与 tabline 相关
    set_vim_settings = true,
    -- 隐藏标签页部分
    tabpage_section = "right",

    -- 自定义标签格式
    format = function(buf_id, label)
      -- 获取所有已列出的buffer
      local listed_buffers = vim.tbl_filter(function(b)
        return vim.fn.buflisted(b) == 1
      end, vim.api.nvim_list_bufs())

      -- 找到当前buffer在列表中的位置（顺序编号）
      local index = 1
      for i, b in ipairs(listed_buffers) do
        if b == buf_id then
          index = i
          break
        end
      end

      -- 获取文件名
      local name = vim.fn.bufname(buf_id)
      if name ~= "" then
        name = vim.fn.fnamemodify(name, ":t")
      else
        name = "No Name"
      end
      -- 检查buffer是否被修改
      local modified = vim.api.nvim_buf_get_option(buf_id, "modified")
      local modified_symbol = modified and " [+]" or ""

      -- 返回格式: 顺序编号 : [ 名称 ] [+]
      return string.format("%d:[ %s ]%s ", index, name, modified_symbol)
    end,
  },
  -- 去掉修改文件的背景色，使其与普通buffer一致
  vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { link = "MiniTablineCurrent" }),
  vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { link = "MiniTablineVisible" }),
  vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", { link = "MiniTablineHidden" }),

  -- 可选：设置一些按键映射来切换 buffer
  -- vim.keymap.set("n", "<Tab>", "<Cmd>bn<CR>", { desc = "下一个 buffer" })
  -- vim.keymap.set("n", "<S-Tab>", "<Cmd>bp<CR>", { desc = "上一个 buffer" })
  -- vim.keymap.set("n", "<leader>bd", "<Cmd>bd<CR>", { desc = "删除当前 buffer" })
}
