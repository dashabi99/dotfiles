;; 指导教程：https://pavinberg.github.io/emacs-book/zh/intro/

;;;; -------------------------
;;;; 基础性能与启动优化
;;;; -------------------------
;; 启动阶段提高 GC 阈值，减少频繁 GC 导致的卡顿
(setq gc-cons-threshold (* 64 1024 1024)
      gc-cons-percentage 0.6)
;; 启动后恢复到更合理的阈值
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))
;; 空闲时再 GC（更顺滑，避免编辑时卡顿）
(run-with-idle-timer 5 t (lambda () (garbage-collect)))
;; 减少启动时界面闪烁/噪音
(setq inhibit-startup-message t
      inhibit-startup-screen t
      initial-scratch-message ";; Happy hacking with Emacs!\n\n")

;;;; -------------------------
;;;; 编码/中文友好
;;;; -------------------------
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;;;; -------------------------
;;;; UI：简洁但实用
;;;; -------------------------
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; 关闭 Emacs 的“响铃/闪屏”提示（静音）
(setq ring-bell-function #'ignore)

;; 显示竖线
(setq-default fill-column 120)  ; 把竖线放到第 120 列
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode) ; 只在编辑模式显示
;; (global-display-fill-column-indicator-mode 1)

;; 全局行号（如果你经常打开超大文件，建议改成只在 prog-mode 开启）
(global-display-line-numbers-mode 1)
(setq-default display-line-numbers-widen t)

;; 显示行列号
(setq column-number-mode t)

;; 括号匹配
(show-paren-mode 1)
(setq blink-matching-paren nil)
(setq show-paren-delay 0.2)
(setq show-paren-highlight-openparen t)
(setq show-paren-when-point-inside-paren t)

;; 默认不折行（对结构化文本更直观）
(setq-default truncate-lines t)

;; 高亮当前行
(global-hl-line-mode 1)

;; 更顺滑的滚动,后面用了插件，这个可以先取消了
;; (setq scroll-step 1
;;       scroll-conservatively 10000
;;       ;; 鼠标滚动：每次 2 行，按 shift 更慢
;;       mouse-wheel-scroll-amount '(2 ((shift) . 1))
      ;; mouse-wheel-progressive-speed nil)

;; 主题（内置主题够稳定，后续可换 doom-themes 等）
;; (load-theme 'modus-vivendi t)

;;;; -------------------------
;;;; 更合理的编辑默认值
;;;; -------------------------
(setq-default indent-tabs-mode nil) ; 用空格缩进更通用
(setq-default tab-width 4)

(electric-pair-mode 1)      ; 自动补全括号
(delete-selection-mode 1)   ; 选中后输入会替换选区（更像现代编辑器）

;; 文件变更自动刷新（配合 git 等很方便）
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil) ; 静默刷新，少打扰

;; y/n 代替 yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; 关闭 Emacs 前询问确认（此处也会变成 y/n，因为上面已替换 yes-or-no-p）
(setq confirm-kill-emacs #'yes-or-no-p)

;; 备份/自动保存：建议“集中存放”而不是彻底关闭（更安全且目录仍干净）
;; 如果你强烈想完全关闭，把下面整个 let 块删掉，并恢复你原来的两行 setq 即可。
; (let ((backup-dir (expand-file-name "var/backup/" user-emacs-directory))
;       (autosave-dir (expand-file-name "var/autosave/" user-emacs-directory)))
;   (make-directory backup-dir t)
;   (make-directory autosave-dir t)
;   (setq backup-directory-alist `(("." . ,backup-dir))
;         auto-save-file-name-transforms `((".*" ,autosave-dir t))
;         auto-save-default t
;         backup-by-copying t
;         delete-old-versions t
;         kept-new-versions 6
;         kept-old-versions 2
;         version-control t))
(setq backup-inhibited t) ; 不自动备份
(setq auto-save-default nil) ; 不自动保存文件

;; 文件末尾空行可见（便于发现末尾多余空行）
(setq-default indicate-empty-lines t)

;; 输入时隐藏鼠标指针（避免挡住文字）
(setq make-pointer-invisible t)

;; 与系统剪贴板互通
(setq select-enable-clipboard t)
;; 从剪贴板请求时优先 UTF8
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
;; 粘贴位置以文本光标为准（而不是鼠标位置）
(setq mouse-yank-at-point t)

;;;; -------------------------
;;;; 包管理：use-package (USTC 镜像)
;;;; -------------------------

;; 避免 Emacs 启动时自动重复初始化包系统（我们手动 package-initialize）
(setq package-enable-at-startup nil)

(require 'package)
;; (add-to-list 'package-archives '("gnu"    . "https://mirrors.ustc.edu.cn/elpa/gnu/") t)
;; (add-to-list 'package-archives '("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/") t)
;; (add-to-list 'package-archives '("melpa"  . "https://mirrors.ustc.edu.cn/elpa/melpa/") t)
(add-to-list 'package-archives '("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/") t)
(add-to-list 'package-archives '("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/") t)
(add-to-list 'package-archives '("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/") t)

(package-initialize)

;; 自动安装 use-package（仅首次需要联网刷新）
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; use-package 默认行为：自动安装、默认延迟加载
(setq use-package-always-ensure t)
(setq use-package-always-defer t)

;; =====插件主题=====
;; (use-package doom-themes
;;  :demand t
;;  :config
;;  (load-theme 'doom-dracula t))
(use-package doom-themes
 :demand t
 :config
 (setq doom-themes-enable-bold nil  ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled
 (load-theme 'doom-monokai-octagon t)
 (doom-themes-treemacs-config))

;; =====小工具=====
;; 更好的跳转到行首和行尾
(use-package mwim
 :ensure t
 :bind
 ("C-a" . mwim-beginning-of-code-or-line)
 ("C-e" . mwim-end-of-code-or-line))

;; 当有三个分割窗口时，显示数字跳转
(use-package ace-window
 :ensure t
 :bind (("C-x o" . 'ace-window)))

;; 不同颜色标记多级括号
(use-package rainbow-delimiters
 :ensure t
 :hook (prog-mode . rainbow-delimiters-mode))

;; 显示键位图
(use-package which-key
 :ensure t ; Emacs 30+ 此行不必须
 :init (which-key-mode))

;; 平滑滚动
(use-package good-scroll
 :ensure t
 :if window-system     ; 在图形化界面时才使用这个插件
 :init (good-scroll-mode))

;; ---------------------------
;; Ivy：补全框架（核心）
;; ---------------------------
(use-package ivy
  :ensure t
  :demand t                         ; 启动 Emacs 时就加载，确保 ivy-mode 立刻生效
  :init
  (ivy-mode 1)                      ; 开启 Ivy 全局补全
  :config
  (setq ivy-use-virtual-buffers t   ; 最近打开/书签等也作为候选显示
        ivy-count-format "(%d/%d) " ; 候选计数显示格式
        search-default-mode #'char-fold-to-regexp) ; 搜索时支持字符折叠（例如 a 匹配 á/à 等）
  :bind
  (("C-x b" . ivy-switch-buffer)    ; 切换 buffer（比默认更好用）
   ("C-c v" . ivy-push-view)        ; 保存当前窗口布局为一个 view
   ("C-c s" . ivy-switch-view)      ; 切换到某个 view
   ("C-c V" . ivy-pop-view))        ; 弹出/回到上一个 view
  :bind (:map ivy-minibuffer-map    ; 只在 Ivy 的 minibuffer 输入界面生效
              ("C-r" . counsel-minibuffer-history))) ; 在 minibuffer 里搜索历史输入
;; ---------------------------
;; Counsel：Ivy 的增强命令集合
;; ---------------------------
(use-package counsel
  :ensure t
  :after ivy
  :init
  (counsel-mode 1)                  ; 启用 counsel 的增强替换（对部分命令做 remap）
  :bind
  (("M-x"     . counsel-M-x)        ; 增强版 M-x（带历史/排序/更友好）
   ("C-x C-f" . counsel-find-file)  ; 增强版打开文件
   ("C-c k"   . counsel-rg)         ; ripgrep 全局搜索（项目内搜代码很强）
   ;; mark-ring：在你跳转/设置 mark 的位置之间回溯
   ;; 在一些终端/系统上 C-SPC 会被映射成 C-@，所以两个都绑更稳
   ("C-x C-@"   . counsel-mark-ring)
   ("C-x C-SPC" . counsel-mark-ring)))
;; ---------------------------
;; Swiper：在当前 buffer 内搜索（绑定到 C-s）
;; ---------------------------
(use-package swiper
  :ensure t
  :after ivy
  :bind
  (("C-s" . swiper)))               ; 用 Swiper 替代默认 isearch-forward
;; 可选：如果你想用 C-r 在当前 buffer 里反向搜索，也可以加：
(global-set-key (kbd "C-r") #'swiper-backward)

;; 使用alt+x时，常用历史命令显示在前面
(use-package amx
 :ensure t
 :init (amx-mode))

;; ---------------------------
;; 目录配置增强
;; ---------------------------
;; 目录显示多种颜色
(use-package diredfl
  :ensure t
  :hook (dired-mode . diredfl-mode))

;; 安装图标
(use-package all-the-icons
  :ensure t
  :when (display-graphic-p)
  :commands all-the-icons-install-fonts) ;; 安装完成之后需要执行 all-the-icons-install-fonts 命令安装对应字体

;; 目录管理器显示图标
(use-package all-the-icons-dired
  :ensure t
  :hook (dired-mode . all-the-icons-dired-mode))

;; minibuffer的补全也显示图标
(use-package all-the-icons-ivy
  :ensure t
  :after ivy
  :init
  (all-the-icons-ivy-setup))

;; 增强版Dired
(use-package dirvish
  :ensure t
  :hook (after-init . dirvish-override-dired-mode)
  :bind (:map dired-mode-map
	     ("C-x d" . dirvish)     ; 打开文件管理器
	     ("d" . dired-do-delete) ; 删除
	     ("r" . dired-do-rename) ; 重命名
	     ("a" . dired-create-empty-file) ; 创建空文件
	     ("/" . dired-create-directory) ; 创建文件夹
	))

;; ---------------------------
;; 代码编辑：补全，lsp……
;; ---------------------------

;;;; -------------------------
;;;; 一些常用快捷键/小工具
;;;; -------------------------
;; 自定义两个函数
;; Faster move cursor
(defun next-ten-lines()
 "Move cursor to next 10 lines."
 (interactive)
 (next-line 10))

(defun previous-ten-lines()
 "Move cursor to previous 10 lines."
 (interactive)
 (previous-line 10))
;; 绑定到快捷键
(global-set-key (kbd "M-n") 'next-ten-lines)      ; 光标向下移动 10 行
(global-set-key (kbd "M-p") 'previous-ten-lines)    ; 光标向上移动 10 行

(global-set-key (kbd "M-w") 'kill-region)       ; 设置M-w 为剪切
(global-set-key (kbd "C-w") 'kill-ring-save)      ; 设置C-w 为复制
(global-set-key (kbd "M-m") 'move-beginning-of-line)  ; M-m 为到真正的行首

;; 选中区域则注释区域，没有选中则注释当前行
(defun my-comment-dwim ()
  (interactive)
  (if (use-region-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))))
(global-set-key (kbd "C-/") #'my-comment-dwim)

(global-set-key (kbd "C-z") #'undo)  ; 撤销操作

;; C-= 放大，C-- 缩小，C-0 重置（内置 text-scale：对“当前 buffer”生效）
(global-set-key (kbd "C-=") #'text-scale-increase)
(global-set-key (kbd "C--") #'text-scale-decrease)
(global-set-key (kbd "C-0")
                (lambda () (interactive) (text-scale-set 0)))

;; Ctrl + 鼠标滚轮缩放（不同 GUI/后端可能事件名不同，这里都绑上）
(global-set-key (kbd "<C-mouse-4>") #'text-scale-increase)
(global-set-key (kbd "<C-mouse-5>") #'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") #'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") #'text-scale-decrease)

;; F5 重新加载 init.el
(defun my/reload-init ()
  "Reload init.el."
  (interactive)
  (load-file user-init-file)
  (message "Reloaded: %s" user-init-file))
(global-set-key (kbd "<f5>") #'my/reload-init)

;; 更友好的帮助窗口：打开 help 后自动选中 help 窗口
(setq help-window-select t)

;; ----------------------------
;; 字体: English + Chinese fallback
;; ----------------------------
;; ----------------------------
;; 字体: English + Chinese fallback（稳定版）
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

;;;; -------------------------
;;;; Custom：把 customize 写入的内容放到单独文件，避免污染 init.el
;;;; -------------------------
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

(provide 'init)
;;; init.el ends here
