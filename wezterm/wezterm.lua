-- 加载 wezterm API 和获取 config 对象
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- ============================================================================
-- 颜色和主题配置
-- ============================================================================
-- -- 第一种方法(单独设置全局主题，没有光标及滚动条的颜色修改)
--config.color_scheme = "Catppuccin Mocha"
--config.color_scheme = "Ubuntu"

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
	background = "#222222",
}

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
--config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
--config.window_decorations = "TITLE | RESIZE"
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
--config.tab_max_width = 30
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
config.scrollback_lines = 20000

-- 渲染设置-gpu -- (OpenGL可能稳定一点)
--config.front_end = "OpenGL"
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
--config.webgpu_force_fallback_adapter = false
-- 可以选择打开或者关闭，感觉没区别，就是剪切板有点难受
-- config.enable_wayland = false

--添加动画fps,以及光标设置
config.animation_fps = 1
config.max_fps = 120

config.term = "xterm-256color"
-- 不建议使用这个，会导致退出nvim有点不对
--config.term = "wezterm"
-- 字体处理
config.freetype_load_target = "Light"
config.freetype_render_target = "Normal"
-- 防止较宽字形画进相邻单元格
config.allow_square_glyphs_to_overflow_width = "Never"

-- ============================================================================
-- 字体配置
-- wezterm ls-fonts --list-system  查看当前环境安装了哪些字体
-- ============================================================================
-- 当第一个字体没安装时，使用第二个字体
--config.font = wezterm.font("UbuntuMono Nerd Font")
--config.font = wezterm.font("Consolas")

config.font = wezterm.font_with_fallback({
	"Ubuntu Mono",
	"nonicons",
})
--config.font = wezterm.font_with_fallback({
--    { family = "UbuntuMono Nerd Font", weight = "Regular", scale = 1.15 },
--	--{ family = "Ioskeley Mono", weight = "Regular" },
--	--{ family = "LXGW WenKai Mono", weight = "Regular" },
--	-- { family = "Maple Mono NF CN", weight = "Regular" },
--	-- { family = "FiraCode Nerd Font", weight = "Regular" },
--	-- { family = "JetBrains Mono", weight = "Medium" },
--	--"Noto Color Emoji",
--})
-- 为特定Unicode范围指定字体；
--config.font_rules = {
--	-- Nerd Font 符号范围
--	{
--		intensity = "Normal",
--		italic = false,
--		font = wezterm.font_with_fallback({
--			"Symbols Nerd Font Mono",
--			-- "Maple Mono NF CN",
--			-- "FiraCode Nerd Font",
--		}),
--	},
--}

-- 字体大小和行高
config.font_size = 15
config.line_height = 1.2

-- 窗口初始大小
config.initial_cols = 120 -- 增加列数
config.initial_rows = 35 -- 增加行数

-- ============================================================================
-- 启动菜单配置
-- ============================================================================
config.launch_menu = {
	{ label = "杭州台架", args = { "ssh", "mm@10.8.104.67" } },
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
--config.status_update_interval = 1000

--背景透明度
--config.window_background_opacity = 0.9
--亚力克模糊
--config.macos_window_background_blur = 10

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

return config
