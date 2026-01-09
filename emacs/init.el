;;; init.el --- Emacs 30.2 config (Eglot + Vertico stack) -*- lexical-binding: t; -*-
;;; Commentary:
;; Personal configuration.
;;; Code:
;;;; -------------------------
;;;; 性能与启动优化
;;;; -------------------------
(setq gc-cons-threshold (* 64 1024 1024)
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))

;; 空闲较久再 GC，避免频繁打断
(run-with-idle-timer 15 t #'garbage-collect)

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

;;;; -------------------------
;;;; UI：简洁但实用
;;;; -------------------------
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; 关闭 Emacs 的“响铃/闪屏”提示（静音）
(setq ring-bell-function #'ignore)

;; 120列参考线（仅编程模式）
(setq-default fill-column 120)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;; 行号：仅编程模式（更快）
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq-default display-line-numbers-widen t)

;; 显示行列号
(setq column-number-mode t)

;; 括号匹配
(show-paren-mode 1)
(setq blink-matching-paren nil
      show-paren-delay 0.1
      show-paren-highlight-openparen t
      show-paren-when-point-inside-paren t)

;; 默认不折行（对结构化文本更直观）
(setq-default truncate-lines t)
;; 高亮当前行
(global-hl-line-mode 1)

;;;; -------------------------
;;;; 更合理的编辑默认值
;;;; -------------------------
(setq-default indent-tabs-mode nil
              tab-width 4)

;; 自动补全括号
;; 选中后输入会替换选区(electric-pair-mode 1)
(delete-selection-mode 1)

;; 文件变更自动刷新（配合 git 等很方便）
(global-auto-revert-mode 1)

;; y/n 代替 yes/no
(fset 'yes-or-no-p 'y-or-n-p)
;; 关闭 Emacs 前询问确认（此处也会变成 y/n，因为上面已替换 yes-or-no-p）
(setq confirm-kill-emacs #'y-or-n-p)

;; 备份/自动保存：集中存放（推荐，不建议彻底关闭）
;; (let ((backup-dir  (expand-file-name "var/backup/"  user-emacs-directory))
;;       (autosave-dir (expand-file-name "var/autosave/" user-emacs-directory)))
;;   (make-directory backup-dir t)
;;   (make-directory autosave-dir t)
;;   (setq backup-directory-alist `(("." . ,backup-dir))
;;         auto-save-file-name-transforms `((".*" ,autosave-dir t))
;;         auto-save-default t
;;         backup-by-copying t
;;         delete-old-versions t
;;         kept-new-versions 6
;;         kept-old-versions 2
;;         version-control t))
(setq backup-inhibited t) ; 不自动备份
(setq auto-save-default nil) ; 不自动保存文件

;; 文件末尾空行可见（便于发现末尾多余空行）
(setq-default indicate-empty-lines t)
;; 输入时隐藏鼠标指针（避免挡住文字）
(setq make-pointer-invisible t)

;; 与系统剪贴板互通
(setq select-enable-clipboard t
      x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)
      mouse-yank-at-point t)
(setq help-window-select t)

;;;; -------------------------
;;;; 包管理：package.el + use-package
;;;; -------------------------
(setq package-enable-at-startup nil)

(require 'package)
(setq package-archives
      '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ;; MELPA 用官方更稳，避免镜像不同步导致 404;["melpa":"https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/"]
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t
      use-package-expand-minimally t)

;;;; -------------------------
;;;; 主题（可选）
;;;; -------------------------
;; 内置主题：更稳定、零依赖
;; (load-theme 'modus-vivendi t)

;; 如果你喜欢 doom-themes（可选）
(use-package doom-themes
  :demand t
  :config
  (setq doom-themes-enable-bold nil
        doom-themes-enable-italic t)
  (load-theme 'doom-monokai-octagon t))

;;;; -------------------------
;;;; 常用小工具
;;;; -------------------------
(use-package which-key
  :hook (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 0.6))

;; 当有三个分割窗口时，显示数字跳转
(use-package ace-window
  :bind (("C-x o" . ace-window)))

;; 更好的跳转到行首和行尾
(use-package mwim
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)))

;; 不同颜色标记多级括号
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;;;; -------------------------
;;;; Vertico / Orderless / Marginalia / Consult / Embark
;;;; -------------------------
;; Vertico：minibuffer 候选列表 UI
(use-package vertico
  :hook (after-init . vertico-mode)
  :config
  (setq vertico-cycle t))

;; 保存 minibuffer 历史
(use-package savehist
  :hook (after-init . savehist-mode)
  :config
  (setq history-length 200))

;; 更强匹配：Orderless
(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((file (styles basic partial-completion)))))

;; 候选注释：Marginalia
(use-package marginalia
  :hook (after-init . marginalia-mode))

;; Consult：搜索/跳转/预览（强烈推荐）
(use-package consult
  :bind (("C-s"     . consult-line)
         ("C-c k"   . consult-ripgrep)
         ("C-x b"   . consult-buffer)
         ("C-x C-r" . consult-recent-file)
         ("M-y"     . consult-yank-pop)))

;; Embark：对候选/光标对象执行动作（可选但非常好用）
(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings)))

(use-package embark-consult
  :after (embark consult))

;; 让 M-x 更顺滑的排序/历史（可选）
(use-package amx
  :hook (after-init . amx-mode)
  :init (setq amx-backend 'auto))

;;;; -------------------------
;;;; 项目管理（内置 project.el + 可选的 consult-project-extra）
;;;; -------------------------
;; Emacs 30 自带 project.el，consult 已能 consult-ripgrep 项目搜索
;; 若你想更便捷地“按项目切换/搜索”，可启用 consult-project-extra（可选）
(use-package consult-project-extra
  :after consult
  :bind (("C-c p f" . consult-project-extra-find)
         ("C-c p b" . consult-project-extra-switch-to-buffer)
         ("C-c p r" . consult-project-extra-ripgrep)))

;;;; -------------------------
;;;; Dired 增强（轻量、少依赖）
;;;; -------------------------
(use-package diredfl
  :hook (dired-mode . diredfl-mode))

;; 如果你确实想要图标（会引入字体安装）
(use-package all-the-icons
  :if (display-graphic-p)
  :commands (all-the-icons-install-fonts))

(use-package all-the-icons-dired
  :if (display-graphic-p)
  :hook (dired-mode . all-the-icons-dired-mode))

;; Dirvish（你之前在用，保留）
(use-package dirvish
  :after dired
  :hook (after-init . dirvish-override-dired-mode)
  :bind (:map dired-mode-map
              ("C-x d" . dirvish)
              ("d" . dired-do-delete)
              ("r" . dired-do-rename)
              ("a" . dired-create-empty-file)
              ("/" . dired-create-directory)))

;;;; -------------------------
;;;; 编程：Eglot（内置）+ 格式化 + 补全体验
;;;; -------------------------
;; 你选择轻量 Eglot：Emacs 内置，默认配合 capf 补全系统即可。
;; 对于 UI，建议使用 corfu（轻量、现代），但它是可选项。
;;
;; 先：Eglot 本体配置（无需安装）
(use-package eglot
  :ensure nil
  :hook ((python-mode . eglot-ensure)
         (lua-mode    . eglot-ensure)
         (sh-mode     . eglot-ensure)
         (bash-mode   . eglot-ensure))
  :config
  ;; 常用：改成更积极的诊断更新（按需）
  (setq eglot-autoshutdown t
        eglot-send-changes-idle-time 0.2))

;; 可选：补全 UI（强烈推荐）。没有它也能用 M-TAB / TAB 的内置补全。
(use-package corfu
  :hook (after-init . global-corfu-mode)
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.1
        corfu-auto-prefix 1
        corfu-cycle t
        corfu-preselect 'prompt))

;; 可选：在补全候选旁显示注释（函数签名/文档）
(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode)
  :config
  (setq corfu-popupinfo-delay 0.2))

;; 可选：更好的 minibuffer 补全（当你在 minibuffer 也想要 corfu 风格）
(use-package corfu-terminal
  :if (not (display-graphic-p))
  :after corfu
  :config
  (corfu-terminal-mode 1))

;; 可选：文档浮窗（类似 hover）
(use-package eldoc
  :ensure nil
  :hook (prog-mode . eldoc-mode)
  :config
  (setq eldoc-echo-area-use-multiline-p nil))

;; 格式化：Apheleia（简单稳定）或使用 external formatter
;; 这里给你 Apheleia（对 python black/isort、lua stylua 等好配）
(use-package apheleia
  :hook (after-init . apheleia-global-mode)
  :config
  ;; 你可按需扩展：
  ;; (setf (alist-get 'python-mode apheleia-mode-alist) 'black)
  )

;; Eglot + 格式化：保存时格式化（按需开启）
(defun my/format-on-save-maybe ()
  "Format current buffer on save if eglot is managing it."
  (when (and (bound-and-true-p eglot--managed-mode)
             (fboundp 'eglot-format-buffer))
    (eglot-format-buffer)))

;; 如果你希望保存自动格式化，取消注释：
(add-hook 'before-save-hook #'my/format-on-save-maybe)

;;;; -------------------------
;;;; 诊断显示（内置）
;;;; -------------------------
(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode)
  :bind (("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)))

;;;; -------------------------
;;;; 自定义快捷键（你的习惯部分保留/微调）
;;;; -------------------------
;; 自定义两个函数
;; Faster move cursor
(defun next-ten-lines()
  "Move cursor to next 10 lines."
  (interactive)
  (forward-line 10))
(defun previous-ten-lines()
  "Move cursor to previous 10 lines."
  (interactive)
  (forward-line -10))
(global-set-key (kbd "M-n") 'next-ten-lines)      ; 光标向下移动 10 行
(global-set-key (kbd "M-p") 'previous-ten-lines)    ; 光标向上移动 10 行

(global-set-key (kbd "M-w") 'kill-region)       ; 设置M-w 为剪切
(global-set-key (kbd "C-w") 'kill-ring-save)      ; 设置C-w 为复制
(global-set-key (kbd "M-m") 'move-beginning-of-line)  ; M-m 为到真正的行首

;; 选中区域则注释区域，没有选中则注释当前行
(defun my-comment-dwim ()
  "Comment/uncomment region if active, otherwise comment/uncomment current line."
  (interactive)
  (if (use-region-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))))
(global-set-key (kbd "C-/") #'my-comment-dwim)

;; undo
(global-set-key (kbd "C-z") #'undo)

;; 缩放
(global-set-key (kbd "C-=") #'text-scale-increase)
(global-set-key (kbd "C--") #'text-scale-decrease)
(global-set-key (kbd "C-0") (lambda () (interactive) (text-scale-set 0)))
(global-set-key (kbd "<C-mouse-4>") #'text-scale-increase)
(global-set-key (kbd "<C-mouse-5>") #'text-scale-decrease)

;; F5 重载
(defun my/reload-init ()
  "Reload init.el."
  (interactive)
  (load-file user-init-file)
  (message "Reloaded: %s" user-init-file))
(global-set-key (kbd "<f5>") #'my/reload-init)

;;;; -------------------------
;;;; 字体：English + Chinese fallback（按需修改字体名）
;;;; -------------------------
(defun my/setup-fonts ()
  "Set English/monospace font and Chinese font fallback."
  (interactive)
  (let ((en-font "IosevkaTerm Nerd Font Mono")
        (zh-font "LXGW WenKai Mono")
        (en-size 14)
        (zh-size 16))
    (when (find-font (font-spec :name en-font))
      (set-face-attribute 'default nil :font (format "%s-%d" en-font en-size)))
    (when (find-font (font-spec :name zh-font))
      (dolist (charset '(han cjk-misc bopomofo kana hangul))
        (set-fontset-font t charset (font-spec :name zh-font :size zh-size))))))

(add-hook 'after-init-hook #'my/setup-fonts)
(add-hook 'after-make-frame-functions (lambda (_f) (my/setup-fonts)))

;;;; -------------------------
;;;; Custom：把 customize 写入单独文件
;;;; -------------------------
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

(provide 'init)
;;; init.el ends here
