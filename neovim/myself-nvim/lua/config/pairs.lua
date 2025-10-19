-- 定义需要自动配对的按键
local keys = {
    -- 左括号：自动关闭并生成配对
    ['('] = { close = true, pair = '()' },
    ['['] = { close = true, pair = '[]' },
    ['{'] = { close = true, pair = '{}' },

    -- 右括号：智能跳过（不自动生成配对）
    [')'] = { close = false, pair = '()' },
    [']'] = { close = false, pair = '[]' },
    ['}'] = { close = false, pair = '{}' },

    -- 引号：自动配对
    ['"'] = { close = true, pair = '""' },
    ["'"] = { close = true, pair = "''" },
    ['`'] = { close = true, pair = '``' },

    -- 特殊按键
    ['<cr>'] = {},  -- 回车键
    ['<bs>'] = {},  -- 退格键
}

---获取光标位置的配对字符
---@param mode string 模式：'insert' 或 'command'
---@return string 返回光标处的两个字符
local function get_pair(mode)
    -- 获取当前行内容
    local line = mode == 'insert' 
        and vim.api.nvim_get_current_line()  -- 插入模式
        or '_' .. vim.fn.getcmdline()        -- 命令模式（加前缀避免索引错误）
    
    -- 获取光标列位置
    local col = mode == 'insert' 
        and vim.api.nvim_win_get_cursor(0)[2]  -- 插入模式
        or vim.fn.getcmdpos()                  -- 命令模式
    
    -- 返回光标位置的两个字符
    return line:sub(col, col + 1)
end

---检查给定字符串是否为配对字符
---@param pair string 要检查的字符串
---@return boolean 是否为配对字符
local function is_pair(pair)
    for _, val in pairs(keys) do
        if pair == val.pair then
            return true
        end
    end
    return false
end

---根据按键添加或删除配对字符
---@param key string 按下的按键
---@param val table 按键配置 {close: boolean, pair: string}
---@param mode string vim 模式
---@return string 要执行的按键序列
local function update_pairs(key, val, mode)
    -- 获取光标处的字符对
    local pair = get_pair(mode)

    -- 回车键处理：如果在配对符号中间按回车，自动缩进
    if key == '<cr>' and mode == 'insert' and is_pair(pair) then
        return '<cr><c-o>O'  -- 换行后在上方插入空行
    
    -- 退格键处理：如果删除配对符号的左半部分，同时删除右半部分
    elseif key == '<bs>' and is_pair(pair) then
        return '<bs><del>'   -- 删除左右两个字符
    
    -- 右括号/右引号处理：智能跳过
    elseif not val.close then
        -- 获取当前行和光标位置
        local line = mode == 'insert' 
            and vim.api.nvim_get_current_line() 
            or '_' .. vim.fn.getcmdline()
        local col = mode == 'insert' 
            and vim.api.nvim_win_get_cursor(0)[2] + 1 
            or vim.fn.getcmdpos() + 1
        
        -- 如果下一个字符就是要输入的右括号/引号，跳过而不是插入
        if line:sub(col, col) == key then
            return '<Right>'  -- 向右移动光标
        end
        return key  -- 否则正常插入
    
    -- 左括号/左引号处理：自动生成配对并将光标移到中间
    elseif val.close then
        return val.pair .. '<Left>'  -- 插入配对并左移光标
    end

    return key  -- 默认返回原按键
end

-- 执行函数：注册所有按键映射
local function exec()
    for key, val in pairs(keys) do
        -- 插入模式映射
        vim.keymap.set('i', key, function()
            return update_pairs(key, val, 'insert')
        end, { noremap = true, expr = true })
        
        -- 命令模式映射
        vim.keymap.set('c', key, function()
            return update_pairs(key, val, 'command')
        end, { noremap = true, expr = true })
    end
end

-- 应用函数：延迟加载，提高启动速度
local function apply()
    -- 创建自动命令：首次进入插入或命令模式时加载
    vim.api.nvim_create_autocmd({ 'InsertEnter', 'CmdlineEnter' }, {
        once = true,  -- 只执行一次
        callback = function()
            exec()  -- 注册按键映射
        end,
    })
end

-- 导出模块
local AutoPairs = {
    apply = apply,
}

return AutoPairs