;;;; -------------------------
;;;; 基础性能与启动优化
;;;; -------------------------
(setq gc-cons-threshold (* 64 1024 1024))  ; 启动阶段提高 GC 阈值
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)))) ; 启动后恢复

;; 减少启动时界面闪烁
(setq inhibit-startup-message t
      inhibit-startup-screen t
      initial-scratch-message ";; Happy hacking with Emacs!\n\n")

;;;; -------------------------
;;;; 编码/中文友好
;;;; -------------------------
(prefer-coding-system 'utf-8-unix)
(set-language-environment "UTF-8")
(setq-default buffer-file-coding-system 'utf-8-unix)

;;;; -------------------------
;;;; UI：简洁但实用
;;;; -------------------------
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore)      ; 关闭 Emacs 的“响铃/闪屏”提示
(setq inhibit-startup-message t)       ; 关闭启动 Emacs 时的欢迎界面

;; 显示列号、行号（编程模式更常用）
(column-number-mode 1)
; (add-hook 'prog-mode-hook #'display-line-numbers-mode)
(global-display-line-numbers-mode 1)     ; 在 Window 显示行号

;; 高亮当前行、括号匹配
(global-hl-line-mode 1)
(show-paren-mode 1)

;; 更顺滑的滚动
(setq scroll-step 1
      scroll-conservatively 10000
      mouse-wheel-scroll-amount '(2 ((shift) . 1))
      mouse-wheel-progressive-speed nil)

;; 主题（内置主题够稳定，后续可换 doom-themes 等）
; (load-theme 'modus-vivendi t)

;;;; -------------------------
;;;; 更合理的编辑默认值
;;;; -------------------------
(setq-default indent-tabs-mode nil) ; 用空格缩进更通用
(setq-default tab-width 4)
(electric-pair-mode t)  ; 自动补全括号
(global-auto-revert-mode t) ; 文件变更自动刷新（配合 git 等很方便）
(setq global-auto-revert-non-file-buffers t)
(setq confirm-kill-emacs #'yes-or-no-p)   ; 在关闭 Emacs 前询问是否确认关闭，防止误触
(delete-selection-mode t)          ; 选中文本后输入文本会替换文本（更符合我们习惯了的其它编辑器的逻辑）
;; y/n 代替 yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;;;; -------------------------
;;;; 包管理：use-package (腾讯镜像)
;;;; -------------------------
(require 'package)
(setq package-archives
      '(("gnu"    . "https://mirrors.ustc.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")
        ("melpa"  . "https://mirrors.ustc.edu.cn/elpa/melpa/")))
;; 第一次需要：拉取仓库索引
(unless package-archive-contents
  (package-refresh-contents))
;; 自举安装 use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
;; 运行时加载（建议直接 require，最省心）
(require 'use-package)
(setq use-package-always-ensure t)

;; 插件主题
(use-package gruber-darker-theme
  :ensure t
  :config
  ;; 启用主题（深色）
  (load-theme 'gruber-darker t))

;;;; -------------------------
;;;; 一些常用快捷键/小工具
;;;; -------------------------
;; F5 重新加载 init.el
(defun my/reload-init ()
  "Reload init.el."
  (interactive)
  (load-file user-init-file)
  (message "Reloaded: %s" user-init-file))
(global-set-key (kbd "<f5>") #'my/reload-init)

;; 更友好的帮助窗口
(setq help-window-select t)

;; ----------------------------
;; 字体: English + Chinese fallback
;; ----------------------------
(defun my/setup-fonts ()
  "Set English/monospace font and Chinese font fallback."
  (interactive)
  (let ((en-font "IosevkaTerm Nerd Font Mono")
        (zh-font "LXGW WenKai Mono")
        (en-size 14)   ;; 英文字号（按需改）
        (zh-size 16))  ;; 中文字号（中文通常需要略大一点更协调）
    ;; 先设置默认英文字体（等宽）
    (when (find-font (font-spec :name en-font))
      (set-face-attribute 'default nil :font (format "%s-%d" en-font en-size)))
    ;; 为中文及常见 CJK 字符集设置 fallback 字体
    (when (find-font (font-spec :name zh-font))
      (dolist (charset '(han cjk-misc bopomofo kana hangul))
        (set-fontset-font t charset (font-spec :name zh-font :size zh-size))))))
;; GUI 启动后设置字体；daemon 模式下新 frame 也会生效
(add-hook 'after-init-hook #'my/setup-fonts)
(add-hook 'after-make-frame-functions
          (lambda (_frame) (my/setup-fonts)))

;;; init.el ends here
(custom-set-variables
 '(package-selected-packages nil))
(custom-set-faces
 )
(provide 'init)
