-- 加载 wezterm API 和获取 config 对象
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- ============================================================================
-- 颜色和主题配置
-- ============================================================================
-- -- 第一种方法
-- config.color_scheme = "tokyonight_moon"

-- 第二种方法
config.colors = {
	-- 定义滚动条的颜色
	scrollbar_thumb = "#FBB829",
	-- 选择文本的颜色
	selection_fg = "#1C1B19",
	selection_bg = "#FBB829",
	-- 光标颜色
	cursor_bg = "#FBB829",
	cursor_border = "#FBB829",
}
-- Set background to same color as neovim(nvim_theme="tjdevries/colorbuddy.nvim")
config.colors.background = "#111111"

-- 第三种方法
-- config.color_scheme = "Ubuntu"
-- config.color_schemes = {
-- 	["Ubuntu"] = {
-- 		-- 定义滚动条的颜色
-- 		scrollbar_thumb = "#FBB829",
-- 		-- 选择文本的颜色
-- 		selection_fg = "#1C1B19",
-- 		selection_bg = "#FBB829",
-- 		-- 光标颜色
-- 		cursor_bg = "#FBB829",
-- 		cursor_border = "#FBB829",
-- 	},
-- }

-- ============================================================================
-- 窗口外观配置
-- ============================================================================
-- 窗口装饰
config.window_decorations = "TITLE | RESIZE"
-- 不要标题栏，可以改成"RESIZE",想要标题栏和边框，可以改成"INTEGRATED_BUTTONS | RESIZE"
-- 如果你设置的是INTEGRATED_BUTTONS | RESIZE，就把下面这些全部打开
-- config.integrated_title_button_alignment = "Right"
-- config.integrated_title_button_color = "Auto"
-- config.integrated_title_button_style = "Windows"
-- config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }

-- 把最头顶那一行与背景融为一体,如果用INTEGRATED_BUTTONS | RESIZE，就要改成true
config.use_fancy_tab_bar = false
-- 显示窗口标题和窗口前面的索引
config.enable_tab_bar = true
config.show_tab_index_in_tab_bar = true
-- 只有一个窗口标题时也不隐藏
config.hide_tab_bar_if_only_one_tab = false
-- 标签页最大宽度，默认16
config.tab_max_width = 30

-- 窗口填充和样式，右边给多一点，因为有滚动条
config.window_padding = {
	left = 8,
	right = 10,
	top = 8,
	bottom = 2,
}

-- 窗口行为
config.adjust_window_size_when_changing_font_size = false
-- 关闭终端响铃
config.audible_bell = "Disabled"
-- 打字时隐藏鼠标光标显示，默认为true
config.hide_mouse_cursor_when_typing = true
-- 设置滚动行数
config.scrollback_lines = 10000

-- 渲染设置-gpu
-- config.front_end = "OpenGL"
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.webgpu_force_fallback_adapter = false

--添加动画fps,以及光标设置
config.animation_fps = 60
config.max_fps = 120
config.enable_kitty_keyboard = true -- 启用更快的键盘协议

-- 设置默认工作区名称为"Normal"
config.default_workspace = "Normal"

-- ============================================================================
-- 字体配置
-- ============================================================================
-- 当第一个字体没安装时，使用第二个字体
config.font = wezterm.font_with_fallback({
	{ family = "Maple Mono NF CN", weight = "Regular" },
	{ family = "JetBrains Mono", weight = "Medium" },
	{ family = "UbuntuMono Nerd Font", weight = "Medium", scale = 1.35 },
	"Noto Color Emoji",
})
-- 字体大小和行高
config.font_size = 13
config.line_height = 0.9

-- 窗口初始大小
config.initial_cols = 120 -- 增加列数
config.initial_rows = 35 -- 增加行数

-- ============================================================================
-- 平台特定配置
-- ============================================================================
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "pwsh", "-NoLogo" }
elseif wezterm.target_triple:match("apple") then
	config.default_prog = { "zsh", "-l" }
	-- macOS 特定设置
	config.macos_window_background_blur = 20
else
	config.default_prog = { "zsh", "-l" }
end

-- ============================================================================
-- 启动菜单配置
-- ============================================================================
config.launch_menu = {
	{ label = "杭州台架", args = { "ssh", "mm@10.8.104.67" } },
	{ label = "lhuas_ipc_X1", args = { "ssh", "mm@192.168.30.200" } },
	{ label = "lhuas_ipc_X2", args = { "ssh", "mm@192.168.195.200" } },
	{ label = "zls_ipc", args = { "ssh", "mm@192.168.195.199" } },
	-- -- 添加本地会话选项
	-- { label = "本地 Zsh", args = { "zsh", "-l" } },
	-- { label = "本地 Bash", args = { "bash", "-l" } },
}

-- ============================================================================
-- 面板和滚动条配置
-- ============================================================================
-- 在同一个窗口，区分左右面板的颜色
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

--背景透明度
-- config.window_background_opacity = 0.9
--亚力克模糊
-- config.macos_window_background_blur = 10
--把自己的壁纸放到这里，设置背景图片
-- config.background = {
--   {
--     source = {
--     --   File = 'D:/壁纸/wallhaven-858lz1_2560x1600.png',
--       File = '/home/mm/Pictures/space.jpg',
--     },
--   }
-- }

-- 打开滚动条
config.enable_scroll_bar = true
-- 优化状态更新频率
config.status_update_interval = 2000

-- ============================================================================
-- 工具函数
-- ============================================================================
-- 提取目录最后一个名字
local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- 标题栏 图标定义
local ICONS = {
	-- 箭头图标
	SOLID_LEFT_ARROW = utf8.char(0xe0ba),
	SOLID_LEFT_MOST = utf8.char(0x2588),
	SOLID_RIGHT_ARROW = utf8.char(0xe0bc),

	-- 进程图标
	UNKNOWN = utf8.char(0xf0633),
	CMD = utf8.char(0xebc4),
	PS = utf8.char(0xe86c),
	NVIM = utf8.char(0xf36f),
	VIM = utf8.char(0xe7c5),
	FZF = utf8.char(0xf021e),
	PYTHON = utf8.char(0xe73c),
	TMUX = utf8.char(0xebc8),
	SSH = utf8.char(0xeb39),
	ZSH = utf8.char(0xe760),
	YAZI = utf8.char(0xf01e5),
	SCP = utf8.char(0xeaf4),
	-- CLAUDE = utf8.char(0xeac4),
	-- CLAUDE = utf8.char(0xf121), -- AI/coding icon
}

-- 索引符号
local SUP_IDX = {
	"¹",
	"²",
	"³",
	"⁴",
	"⁵",
	"⁶",
	"⁷",
	"⁸",
	"⁹",
	"¹⁰",
	"¹¹",
	"¹²",
	"¹³",
	"¹⁴",
	"¹⁵",
	"¹⁶",
	"¹⁷",
	"¹⁸",
	"¹⁹",
	"²⁰",
}
local SUB_IDX = {
	"₁",
	"₂",
	"₃",
	"₄",
	"₅",
	"₆",
	"₇",
	"₈",
	"₉",
	"₁₀",
	"₁₁",
	"₁₂",
	"₁₃",
	"₁₄",
	"₁₅",
	"₁₆",
	"₁₇",
	"₁₈",
	"₁₉",
	"₂₀",
}

-- 进程图标映射函数（使用短名称）
local function get_process_icon(exec_name, full_process_name)
	-- 确保 exec_name 不为空
	if not exec_name or exec_name == "" then
		return ICONS.UNKNOWN .. " unknown"
	end
	-- 转换为小写进行匹配，提高匹配成功率
	local exec_lower = exec_name:lower()

	local icon_map = {
		zsh = ICONS.ZSH .. " Zsh",
		bash = ICONS.ZSH .. " Bash",
		tmux = ICONS.TMUX .. " Tmux",
		ssh = ICONS.SSH .. " ssh",
		pwsh = ICONS.PS .. " pwsh",
		powershell = ICONS.PS .. " pwsh",
		cmd = ICONS.CMD .. " cmd",
		python = ICONS.PYTHON .. " py",
		python3 = ICONS.PYTHON .. " py3",
		yazi = ICONS.YAZI .. " yazi",
		scp = ICONS.SCP .. " scp",
		-- claude = ICONS.CLAUDE .. " coding",
	}

	-- 直接匹配
	-- if icon_map[exec_name] then
	-- 	return icon_map[exec_name]
	-- end
	-- 直接匹配（小写）
	if icon_map[exec_lower] then
		return icon_map[exec_lower]
	end

	-- 模式匹配
	local patterns = {
		-- { "claude", ICONS.CLAUDE .. " Claude" }, -- 优先匹配 claude
		{ "nvim", ICONS.NVIM .. " nvim" },
		{ "vim", ICONS.VIM .. " vim" },
		{ "fzf", ICONS.FZF .. " fzf" },
		{ "python", ICONS.PYTHON .. " Python" },
	}

	for _, pattern in ipairs(patterns) do
		if exec_lower:find(pattern[1], 1, true) then
			return pattern[2]
		end
	end

	-- 对未知进程使用短名称
	-- local short_name = #exec_name > 8 and exec_name:sub(1, 8) .. "..." or exec_name
	-- return ICONS.UNKNOWN .. " " .. short_name
	local display_name = full_process_name or exec_name
	-- 截断过长的路径，只保留最后两级目录和文件名
	if display_name:find("/") then
		local parts = {}
		for part in display_name:gmatch("[^/]+") do
			table.insert(parts, part)
		end
		if #parts > 2 then
			display_name = ".../" .. parts[#parts - 1] .. "/" .. parts[#parts]
		end
	end

	-- 如果名称仍然太长，进行截断
	if #display_name > 20 then
		display_name = display_name:sub(1, 17) .. "..."
	end

	return ICONS.UNKNOWN .. " " .. display_name
end

-- ============================================================================
-- 标签页标题格式化
-- ============================================================================
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local colors = {
		edge_background = "#121212",
		inactive = { bg = "#4E4E4E", fg = "#1C1B19", dim_fg = "#3A3A3A" },
		active = { bg = "#FBB829", fg = "#1C1B19" },
		hover = { bg = "#FF8700", fg = "#1C1B19" },
	}

	local background = colors.inactive.bg
	local foreground = colors.inactive.fg
	local dim_foreground = colors.inactive.dim_fg

	if tab.is_active then
		background = colors.active.bg
		foreground = colors.active.fg
	elseif hover then
		background = colors.hover.bg
		foreground = colors.hover.fg
	end

	local edge_foreground = background
	local process_name = tab.active_pane.foreground_process_name or ""
	local exec_name = basename(process_name):gsub("%.exe$", "")
	-- 面板最大化标志 放大镜图标
	local zoomed = tab.active_pane.is_zoomed and " 🔍 " or ""

	-- local title_with_icon = get_process_icon(exec_name)
	local title_with_icon = get_process_icon(exec_name, process_name)
	local left_arrow = tab.tab_index == 0 and ICONS.SOLID_LEFT_MOST or ICONS.SOLID_LEFT_ARROW
	local id = SUB_IDX[tab.tab_index + 1] or tostring(tab.tab_index + 1)
	local pid = SUP_IDX[tab.active_pane.pane_index + 1] or tostring(tab.active_pane.pane_index + 1)

	-- 给标题更多空间，减少预留空间
	local available_width = math.max(max_width - 4, 12) -- 确保最小宽度
	local title = " " .. wezterm.truncate_right(title_with_icon, available_width) .. " "

	return {
		{ Attribute = { Intensity = "Bold" } },
		{ Background = { Color = colors.edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = left_arrow },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = id },
		{ Text = title .. zoomed },
		{ Foreground = { Color = dim_foreground } },
		{ Text = pid },
		{ Background = { Color = colors.edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = ICONS.SOLID_RIGHT_ARROW },
		{ Attribute = { Intensity = "Normal" } },
	}
end)

-- ============================================================================
-- 状态栏配置
-- ============================================================================
wezterm.on("update-status", function(window, pane)
	-- 工作区状态
	local stat = window:active_workspace()
	local stat_color = "#f7768e"

	if window:active_key_table() then
		stat = window:active_key_table()
		stat_color = "#7dcfff"
	elseif window:leader_is_active() then
		stat = "Leader"
		stat_color = "#bb9af7"
	end

	-- 当前进程和目录
	local cmd = pane:get_foreground_process_name()
	cmd = cmd and basename(cmd) or ""

	local cwd = pane:get_current_working_dir()
	local cwd_text = ""

	if cmd == "ssh" then
		cwd_text = "🌐 Remote"
	elseif cmd == "tmux" then
		cwd_text = "🔧 Tmux"
	elseif cwd then
		if type(cwd) == "userdata" then
			cwd_text = basename(cwd.file_path)
		else
			cwd_text = basename(cwd)
		end
	end
	-- --展示完成目录，太长了不美观
	-- elseif cwd then
	-- 	if type(cwd) == "userdata" then
	-- 		cwd = cwd.file_path
	-- 	else
	-- 		cwd = cwd
	-- 	end

	-- 时间和日期
	local time = wezterm.strftime("%H:%M")
	local wday_num = tonumber(wezterm.strftime("%w"))
	local wday_names = { "日", "一", "二", "三", "四", "五", "六" }
	-- local wday_chinese = "星期" .. wday_names[wday_num + 1]
	local wday_chinese = "星期" .. (wday_names[wday_num + 1] or "未知")

	-- 电池信息
	local bat = ""
	local bat_info = wezterm.battery_info()
	if #bat_info > 0 then
		local charge = bat_info[1].state_of_charge * 100
		-- local bat_icon = charge > 80 and "🔋" or charge > 20 and "🔋" or "🪫"
		local bat_icon
		if charge > 80 then
			bat_icon = " "
		elseif charge > 50 then
			bat_icon = " "
		elseif charge > 20 then
			bat_icon = " "
		else
			bat_icon = "󱉞 "
		end
		bat = string.format("%s %.0f%%", bat_icon, charge)
	end

	-- 左状态栏
	window:set_left_status(wezterm.format({
		{ Foreground = { Color = stat_color } },
		{ Text = "  " },
		{ Text = wezterm.nerdfonts.dev_apple .. " " .. stat },
		{ Text = " " },
		{ Text = wezterm.nerdfonts.cod_terminal_linux .. "  " },
	}))

	-- 右状态栏
	window:set_right_status(wezterm.format({
		{ Text = wezterm.nerdfonts.fa_chevron_left .. "  " },
		{ Foreground = { Color = "#e0af68" } },
		{ Text = wezterm.nerdfonts.cod_folder .. "  " .. cwd_text },
		"ResetAttributes",
		{ Text = "   " },
		{ Text = wezterm.nerdfonts.md_timer_sand_complete .. "  " .. time },
		{ Text = "   " },
		{ Foreground = { Color = "#e0af25" } },
		{ Text = bat },
		"ResetAttributes",
		{ Text = "  " .. wezterm.nerdfonts.fa_chevron_right .. "  " },
		{ Foreground = { Color = "#e0af99" } },
		{ Text = wday_chinese .. " " },
	}))
end)

-- ============================================================================
-- 新标签页按钮事件
-- ============================================================================
wezterm.on("new-tab-button-click", function(window, pane, button, default_action)
	if button == "Left" and default_action then
		window:perform_action(default_action, pane)
	elseif button == "Right" then
		window:perform_action(
			act.ShowLauncherArgs({
				-- title = "选择要连接的服务器", -- 标题 可改成自己喜欢的
				help_text = "🚀 选择要连接的服务器:",
				flags = "LAUNCH_MENU_ITEMS|TABS",
			}),
			pane
		)
	end
	return false
end)

-- ============================================================================
-- 键盘绑定
-- ============================================================================
config.leader = { key = "b", mods = "ALT", timeout_milliseconds = 3000 }
config.keys = {
	-- 一次性退出全部窗口
	{ key = "q", mods = "LEADER", action = act.QuitApplication },

	-- 分割面板
	{ key = "5", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "'", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "q", mods = "CTRL", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

	-- 面板导航 like vim key
	{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") }, -- Alt+h 激活左边的窗格
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") }, -- Alt+j 激活下方的窗格
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") }, -- Alt+k 激活上方的窗格
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") }, -- Alt+l 激活右边的窗格
	{ key = "LeftArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) }, -- Alt+左箭头 缩小窗格宽度
	{ key = "DownArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) }, -- Alt+下箭头 增大窗格高度
	{ key = "UpArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) }, -- Alt+上箭头 缩小窗格高度
	{ key = "RightArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) }, -- Alt+右箭头 增大窗格宽度
	-- 没反应 暂时不用
	-- { key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) }, --  切换到下一个标签页
	-- { key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) }, --  切换到上一个标签页

	-- 标签页管理
	{ key = "t", mods = "CTRL", action = act.SpawnTab("DefaultDomain") },
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "LAUNCH_MENU_ITEMS|TABS" }) },

	-- 复制粘贴
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	-- 也可以鼠标中键粘贴
	-- { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
	-- -- 鼠标选中内容ctrl+c就是复制 ,否则默认终止程序
	{
		key = "c",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local sel = window:get_selection_text_for_pane(pane)
			if not sel or sel == "" then
				window:perform_action(wezterm.action.SendKey({ key = "c", mods = "CTRL" }), pane)
			else
				window:perform_action(wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }), pane)
				window:perform_action(wezterm.action.ClearSelection, pane)
			end
		end),
	},

	-- 搜索功能
	{ key = "f", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
	-- 进入复制模式 按下v进行选择，enter复制，Esc退出
	{ key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },

	-- 字体大小调整
	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	-- 还原字体大小
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },

	-- 内容上下滚动
	{ key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
	{ key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },

	-- 工作区选择 如果选择创建工作区会随机命名
	{ key = "s", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },
	-- 创建新工作区并命名
	{
		key = "c",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
}

-- 数字键切换标签页 (1-9)
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL",
		action = act.ActivateTab(i - 1),
	})
end

-- ============================================================================
-- 鼠标绑定
-- ============================================================================
config.mouse_bindings = {
	-- 文本选择（不自动复制）
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.SelectTextAtMouseCursor("Cell"),
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.ExtendSelectionToMouseCursor("Cell"),
	},
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.ExtendSelectionToMouseCursor("Cell"),
	},

	-- Ctrl+点击打开链接
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

-- ============================================================================
-- 高亮和搜索配置
-- ============================================================================
config.quick_select_patterns = {
	-- 日志级别
	"\\b(?i)(ERROR|FATAL|PANIC|CRITICAL)\\b",
	"\\b(?i)(WARN|WARNING|DEPRECATED)\\b",
	"\\b(?i)(INFO|NOTICE|DEBUG)\\b",
	"\\b(?i)(SUCCESS|OK|PASSED)\\b",

	-- 网络
	"\\b(?:[0-9]{1,3}\\.){3}[0-9]{1,3}\\b", -- IPv4
	"https?://[\\w\\d\\.-]+(?:[:\\d+])?(?:/[\\w\\d\\.-_/?%&=]*)?", -- URL

	-- 文件路径
	"[~/][\\w\\d\\.\\-_/]+\\.(log|txt|conf|cfg|ini|yaml|yml|json|py|js|ts|go|rs)\\b",

	-- 时间戳
	"\\d{4}-\\d{2}-\\d{2}[T\\s]\\d{2}:\\d{2}:\\d{2}",

	-- Git SHA
	"\\b[a-f0-9]{7,40}\\b",
}

-- ============================================================================
-- 超链接规则
-- ============================================================================
config.hyperlink_rules = {
	{
		regex = "\\b\\w+://[\\w.-]+\\S*\\b",
		format = "$0",
	},
	{
		regex = "\\bfile://\\S*\\b",
		format = "$0",
	},
}

return config
