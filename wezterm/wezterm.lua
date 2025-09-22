-- 加载 wezterm API 和获取 config 对象
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- ============================================================================
-- 颜色和主题配置
-- ============================================================================
-- -- 第一种方法(单独设置全局主题，没有光标及滚动条的颜色修改)
-- config.color_scheme = "tokyonight_moon"
-- config.color_scheme = "Ubuntu"

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
-- 窗口装饰 -- 看自己喜欢设置
config.window_decorations = "TITLE | RESIZE"
-- config.window_decorations = "TITLE | RESIZE"
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

-- 渲染设置-gpu -- (OpenGL可能稳定一点)
-- config.front_end = "OpenGL"
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.webgpu_force_fallback_adapter = false

--添加动画fps,以及光标设置
config.animation_fps = 120
config.max_fps = 120
-- 启动kitty键盘协议，linux运行正常，在win上导致在wezterm里运行vim/nvim时，esc没反应和打一个中文字没反应，多个字正常.还是禁用吧也没快多少
-- config.enable_kitty_keyboard = true
config.term = "xterm-256color"

-- 设置默认工作区名称为"Normal"
config.default_workspace = "Normal"

-- ============================================================================
-- 字体配置
-- ============================================================================
-- 当第一个字体没安装时，使用第二个字体
config.font = wezterm.font_with_fallback({
	{ family = "Maple Mono NF CN", weight = "Regular" },
	{ family = "FiraCode Nerd Font", weight = "Regular" },
	{ family = "UbuntuMono Nerd Font", weight = "Regular", scale = 1.15 },
	{ family = "JetBrains Mono", weight = "Medium" },
	"Noto Color Emoji",
})
-- -- 为特定Unicode范围指定字体,使用这个导致maple的info,error图标变得很小；
-- config.font_rules = {
-- 	-- Nerd Font 符号范围
-- 	{
-- 		intensity = "Normal",
-- 		italic = false,
-- 		font = wezterm.font_with_fallback({
-- 			"Symbols Nerd Font Mono",
-- 			-- "Maple Mono NF CN",
-- 			"FiraCode Nerd Font",
-- 		}),
-- 	},
-- }

-- 字体大小和行高
config.font_size = 13
config.line_height = 0.9

-- 窗口初始大小
config.initial_cols = 120 -- 增加列数
config.initial_rows = 35 -- 增加行数

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
	{ label = "PowerShell", args = { "pwsh", "-NoLogo" } },
}

-- ============================================================================
-- 面板和滚动条配置
-- ============================================================================
-- 在同一个窗口，区分左右面板的颜色
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

-- 打开滚动条
config.enable_scroll_bar = true
-- 优化状态更新频率
config.status_update_interval = 1000

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

-- ============================================================================
-- 定义多系统都需要的变量,避免重复
-- ============================================================================
-- 检测登陆系统
local function platform()
	local function is_found(str, pattern)
		return string.find(str, pattern) ~= nil
	end

	return {
		is_win = is_found(wezterm.target_triple, "windows"),
		is_linux = is_found(wezterm.target_triple, "linux"),
		is_mac = is_found(wezterm.target_triple, "apple"),
	}
end
local os_info = platform()
if os_info.is_win then
	config.default_prog = { "pwsh", "-NoLogo" }
elseif os_info.is_linux then
	config.default_prog = { "zsh", "-l" }
elseif os_info.is_mac then
	config.default_prog = { "zsh", "-l" }
	-- macOS 特定设置
	-- config.macos_window_background_blur = 20
end

-- 提取目录/路径最后一个名字(兼容win和linux识别)
local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- ============================================================================
-- 图标和符号定义
-- ============================================================================
-- 箭头图标
local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
local SOLID_LEFT_MOST = utf8.char(0x2588)
local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

-- 进程图标
local UNKNOWN = utf8.char(0xebc3)
local ADMIN_WIN = utf8.char(0xf49c)
local CMD = utf8.char(0xebc4)
local PWSH = utf8.char(0xe86c)
local NVIM = utf8.char(0xe6ae)
local VIM_WIN = utf8.char(0xe62b)
local VIM_LINUX = utf8.char(0xe7c5)
local FZF = utf8.char(0xf021e)
local PYTHON = utf8.char(0xe73c)
local TMUX = utf8.char(0xebc8)
local SSH = utf8.char(0xeb39)
local ZSH = utf8.char(0xe760)
local YAZI = utf8.char(0xf01e5) -- 终端文件管理器yazi图标
local SCP = utf8.char(0xf09e) -- scp 的图标
local CLAUDE = utf8.char(0xf0a1e) -- claude code图标
local ZOOM = "🔍" -- 放大镜图标
local GIT = utf8.char(0xe702) -- git图标
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

-- ============================================================================
-- 标签页的图标和标题设置
-- ============================================================================
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = "#121212"
	local background = "#4E4E4E"
	local foreground = "#1C1B19"
	local dim_foreground = "#3A3A3A"

	if tab.is_active then
		background = "#FBB829"
		foreground = "#1C1B19"
	elseif hover then
		background = "#FF8700"
		foreground = "#1C1B19"
	end

	local edge_foreground = background
	local process_name = tab.active_pane.foreground_process_name
	local pane_title = tab.active_pane.title
	local exec_name = basename(process_name):gsub("%.exe$", "")
	local title_with_icon

	-- exec_name是从进程路径提取的短名称，pane_title是当前窗口标题,match是匹配,upper是转大写
	-- 多种匹配方法
	if exec_name == "zsh" or exec_name == "bash" then
		title_with_icon = ZSH .. " " .. exec_name
	elseif exec_name:match("nvim") then
		title_with_icon = NVIM .. " nvim"
	elseif exec_name:match("vim") then
		title_with_icon = VIM_LINUX
	elseif exec_name == "fzf" then
		title_with_icon = FZF .. " " .. exec_name:upper()
	elseif exec_name == "tmux" then
		title_with_icon = TMUX .. " " .. exec_name
	elseif exec_name:match("python") then
		title_with_icon = PYTHON .. " " .. exec_name
	elseif exec_name == "ssh" then
		title_with_icon = SSH .. " " .. exec_name
	elseif exec_name == "git" then
		title_with_icon = GIT .. " " .. exec_name
	elseif exec_name == "yazi" then
		title_with_icon = YAZI .. " " .. exec_name
	elseif exec_name == "scp" then
		title_with_icon = SCP .. " " .. exec_name
	elseif pane_title:match("claude") then
		title_with_icon = CLAUDE .. " claude code"
	elseif os_info.is_win and exec_name == "pwsh" then
		-- 检查是否在运行vim
		if exec_name:find("nvim") then
			title_with_icon = NVIM .. " nvim"
		elseif pane_title:match("VIM") then
			title_with_icon = VIM_WIN .. " vim"
		elseif pane_title:match("^Administrator: ") then
			title_with_icon = PWSH .. " PowerShell " .. ADMIN_WIN
		else
			title_with_icon = PWSH .. " PowerShell"
		end
	elseif exec_name == "cmd" then
		title_with_icon = CMD .. " " .. exec_name
	else
		title_with_icon = UNKNOWN .. " " .. pane_title
	end

	local left_arrow = SOLID_LEFT_ARROW
	if tab.tab_index == 0 then
		left_arrow = SOLID_LEFT_MOST
	end
	local id = SUB_IDX[tab.tab_index + 1]
	local pid = SUP_IDX[tab.active_pane.pane_index + 1]
	local title = " " .. wezterm.truncate_right(title_with_icon, max_width - 6) .. " "

	return {
		{ Attribute = { Intensity = "Bold" } },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = left_arrow },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = id },
		{ Text = title },
		{ Text = tab.active_pane.is_zoomed and (" " .. ZOOM .. " ") or "" },
		{ Foreground = { Color = dim_foreground } },
		{ Text = pid },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
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

	if cmd:find("ssh") then
		cwd_text = "🌐 Remote"
	elseif cmd:find("tmux") then
		cwd_text = "🔧 Tmux"
	elseif cwd then
		if type(cwd) == "userdata" then
			local file_path = cwd.file_path or cwd.path or ""
			cwd_text = basename(file_path)
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
		-- 这个图标不好看，不用了
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
		{ Text = " " },
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
config.leader = { key = "b", mods = "ALT", timeout_milliseconds = 3000 } -- 设置快捷键前缀
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
				-- 当复制完后一点时间自己清除选中内容
				wezterm.time.call_after(0.01, function()
					window:perform_action(wezterm.action.ClearSelection, pane)
				end)
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

-- CTRL+数字键切换标签页 (1-9)
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
