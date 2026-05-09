# 查看目前使用的 Profile路径 echo $PROFILE
# 直接用記事本编辑 notepad $PROFILE

# 安装插件
# （Install-Module Terminal-Icons -Scope CurrentUser）
# （Install-Module posh-git -Scope CurrentUser）
# （Install-Module PSReadLine -Scope CurrentUser -Force）
# （Install-Module PSFzf -Scope CurrentUser）
# 更新模块插件 Update-Module

# 命令行美化
# omp配置 暂时不用
# oh-my-posh init pwsh --config ~/.omp.theme.json | Invoke-Expression
# starship命令行
Invoke-Expression (&starship init powershell)

# open打开文件管理器
function open {
    param(
        [string]$Path = "."
    )
    Invoke-Item $Path
}

# 终端图标 耗时不用
# Import-Module Terminal-Icons

# Git 提示  耗时不用
# Import-Module posh-git

# PSReadLine 先安装（用自带的cmd下载）
Import-Module PSReadLine
# 使用win编辑模式
#Set-PSReadLineOption -EditMode Windows
# 使用历史记录作为预测来源
Set-PSReadLineOption -PredictionSource History
# 预测列表样式
Set-PSReadLineOption -PredictionViewStyle ListView

# Tab 补全使用菜单模式
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
# Ctrl+p：按当前输入内容向上搜索历史
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function HistorySearchBackward
# Ctrl+n：按当前输入内容向下搜索历史
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function HistorySearchForward
# Ctrl+a：行首
Set-PSReadLineKeyHandler -Chord Ctrl+a -Function BeginningOfLine
# Ctrl+e：行尾
Set-PSReadLineKeyHandler -Chord Ctrl+e -Function EndOfLine
# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo


# 安装（fzf 和 Install-Module PSFzf -Scope CurrentUser）
Import-Module PSFzf
#Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PsFzfOption `
            -PSReadlineChordReverseHistory 'Ctrl+r' `
            -PSReadlineChordProvider 'Ctrl+f'

# yazi快捷键
function yy {
	$tmp = (New-TemporaryFile).FullName
	yazi.exe @args --cwd-file="$tmp"
	$cwd = Get-Content -Path $tmp -Encoding UTF8
	if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
		Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
	}
	Remove-Item -Path $tmp
}