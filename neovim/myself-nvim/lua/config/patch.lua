local WorkspacePatch = {}

-- 应用工作区特定配置
function WorkspacePatch.apply()
    -- 查找工作区配置目录
    -- 优先级1：当前目录下的 .nvim 文件夹
    local workspace_nvim = vim.fn.getcwd() .. '/.nvim'
    
    -- 优先级2：当前目录下的 .vscode/nvim 文件夹（兼容 VSCode）
    local secondary = vim.fn.getcwd() .. '/.vscode/nvim'
    
    -- 检查主配置目录是否存在
    if vim.fn.isdirectory(workspace_nvim) == 1 then
        -- 主目录存在，使用它
    
    -- 检查次要配置目录是否存在
    elseif vim.fn.isdirectory(secondary) == 1 then
        -- 次要目录存在，使用它
        workspace_nvim = secondary
    
    -- 两个目录都不存在
    else
        -- 提前返回，不加载任何工作区配置
        return
    end

    -- 将工作区配置目录添加到 Neovim 的运行时路径前面
    -- 这样可以覆盖全局配置
    vim.opt.runtimepath:prepend(workspace_nvim)
    
    -- 加载工作区的 init.lua 文件
    local init_lua = workspace_nvim .. '/init.lua'
    
    -- 检查 init.lua 是否存在且可读
    if vim.fn.filereadable(init_lua) == 1 then
        -- 执行 init.lua 文件
        dofile(init_lua)
    end

    -- 触发 FileType 自动命令并重新加载文件类型插件
    -- 这样可以应用工作区特定的文件类型配置
    if vim.bo.filetype ~= '' then
        vim.cmd('doautocmd FileType ' .. vim.bo.filetype)
    end
end

return WorkspacePatch