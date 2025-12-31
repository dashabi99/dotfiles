#!/usr/bin/env bash
set -euo pipefail

# ===== 基础检查 =====
if ! command -v apt &>/dev/null; then
  echo "本脚本只适用于 Debian/Ubuntu 及其衍生发行版（需要 apt）。"
  exit 1
fi

cd "$HOME"

echo "==== 更新软件源 ===="
sudo apt update

echo "==== 安装常用软件包 ===="
sudo apt install -y \
  zsh wget vlc vim unzip tree ssh ripgrep net-tools \
  meld git curl fd-find build-essential xsel wl-clipboard \
  tmux

# ===== 安装 fcitx5 输入法及相关前端 =====
echo "==== 安装 fcitx5 及中文支持 ===="
sudo apt install -y \
  fcitx5 \
  fcitx5-chinese-addons \
  fcitx5-frontend-gtk4 \
  fcitx5-frontend-gtk3 \
  fcitx5-frontend-gtk2 \
  fcitx5-frontend-qt5

# 创建 fcitx5 拼音词库目录
mkdir -p "$HOME/.local/share/fcitx5/pinyin/dictionaries/"

# ===== 可选：电源管理 TLP =====
# read -rp "是否安装电源管理工具 TLP (推荐笔记本使用)? [y/N]: " INSTALL_TLP
# if [[ "${INSTALL_TLP:-N}" =~ ^[Yy]$ ]]; then
#   sudo apt install -y tlp tlp-rdw
#   echo "TLP 已安装（需要的话可以手动执行 sudo tlp start 启动, 添加自启动sudo systemctl enable tlp）。"
# fi

# ===== 可选：GNOME Tweaks & 扩展 =====
if command -v gnome-shell &>/dev/null; then
  read -rp "检测到 GNOME 桌面，是否安装 gnome-tweaks 与 gnome-shell-extensions? [y/N]: " INSTALL_GNOME_TOOLS
  if [[ "${INSTALL_GNOME_TOOLS:-N}" =~ ^[Yy]$ ]]; then
    sudo apt install -y gnome-tweaks gnome-shell-extensions
  fi
fi

# ===== 统一的 .deb 下载目录 =====
DEB_DIR="$HOME/Downloads/debs"
mkdir -p "$DEB_DIR"
echo "所有 .deb 安装包将下载到: $DEB_DIR"

# ===== 下载 VS Code .deb（不自动安装）=====
download_vscode_deb() {
  echo "==== 下载 VS Code .deb 包（不安装） ===="
  local arch
  arch=$(dpkg --print-architecture)
  if [[ "$arch" != "amd64" ]]; then
    echo "当前架构为 $arch，本下载链接为 x64/amd64，如非 x86_64 机器请手动下载对应版本。"
  fi

  local vscode_deb="$DEB_DIR/vscode_latest_amd64.deb"
  wget -O "$vscode_deb" \
    "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

  echo "VS Code .deb 已下载到: $vscode_deb"
  echo "你可以稍后运行：sudo apt install ./vscode_latest_amd64.deb 进行安装（在 $DEB_DIR 目录下）。"
}
download_vscode_deb

# ===== 下载 Google Chrome .deb（不自动安装）=====
download_chrome_deb() {
  echo "==== 下载 Google Chrome .deb 包（不安装） ===="
  local chrome_deb="$DEB_DIR/google-chrome-stable_current_amd64.deb"
  wget -O "$chrome_deb" \
    "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

  echo "Chrome .deb 已下载到: $chrome_deb"
  echo "你可以稍后运行：sudo apt install ./google-chrome-stable_current_amd64.deb 进行安装（在 $DEB_DIR 目录下）。"
}
download_chrome_deb

# ===== 下载 星火商店（spark-store）.deb（不自动安装）=====
# download_spark_store_deb() {
#   echo "==== 下载 星火商店（spark-store）.deb 包（不安装） ===="
#
#   # ⚠️ 这里是占位示例 URL，请改成星火商店官方提供的最新 .deb 链接
#   # 例如（示例，不一定可用）：
#   # SPARK_DEB_URL="https://github.com/deepin-community/spark-store/releases/download/v4.3.8/spark-store_4.3.8_amd64.deb"
#   local SPARK_DEB_URL="https://example.com/path/to/spark-store_x.y.z_amd64.deb"
#
#   if [[ "$SPARK_DEB_URL" == "https://example.com/path/to/spark-store_x.y.z_amd64.deb" ]]; then
#     echo "当前 SPARK_DEB_URL 还是占位地址，请编辑脚本，替换为星火商店最新 .deb 的真实 URL。"
#     echo "跳过星火商店下载。"
#     return
#   fi
#
#   local spark_deb="$DEB_DIR/spark-store_amd64.deb"
#   wget -O "$spark_deb" "$SPARK_DEB_URL"
#
#   echo "星火商店 .deb 已下载到: $spark_deb"
#   echo "你可以稍后运行：sudo apt install ./spark-store_amd64.deb 进行安装（在 $DEB_DIR 目录下）。"
# }
# download_spark_store_deb

# ===== 克隆 dotfiles 仓库 =====
echo "==== 克隆 dotfiles 仓库 ===="
DOTFILES_DIR="$HOME/dotfiles"
if [ -d "$DOTFILES_DIR/.git" ]; then
  echo "目录 $DOTFILES_DIR 已存在 git 仓库，跳过克隆。"
else
  git clone git@github.com:dashabi99/dotfiles.git "$DOTFILES_DIR" || {
    echo "通过 SSH 克隆失败，检查 SSH key 或改用 HTTPS。"
  }
fi

# ===== 安装 tmux 插件管理器 TPM =====
echo "==== 安装 tmux 插件管理器 TPM ===="
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ -d "$TPM_DIR/.git" ]; then
  echo "TPM 已存在，跳过克隆。"
else
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# ===== 安装 WezTerm nightly =====
echo "==== 安装 WezTerm nightly ===="
if command -v wezterm &>/dev/null; then
  echo "wezterm 已安装，如需 nightly 可手动重新安装。"
else
  curl -fsSL https://wezterm.com/installer.sh | WEZTERM_CHANNEL=nightly bash
fi

# ===== 安装 fzf =====
echo "==== 安装 fzf ===="
if [ -d "$HOME/.fzf" ]; then
  echo "~/.fzf 已存在，尝试更新 fzf..."
  (cd "$HOME/.fzf" && git pull --ff-only) || echo "更新 fzf 失败，可以手动处理 ~/.fzf。"
else
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi

yes | "$HOME/.fzf/install" --all

echo
echo "======================================="
echo " 环境还原脚本执行完成。"
echo " - .deb 包已下载到: $DEB_DIR"
echo "   安装示例："
echo "     cd \"$DEB_DIR\""
echo "     sudo apt install ./vscode_latest_amd64.deb"
echo "     sudo apt install ./google-chrome-stable_current_amd64.deb"
# echo "     sudo apt install ./spark-store_amd64.deb  # 若已配置真实 URL"
echo "======================================="
