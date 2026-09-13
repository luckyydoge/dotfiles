;;; GC 调优：gcmh 接管（交互时高阈值不停顿，空闲时自动回收）
;; 启动期的 GC 阈值由 early-init.el 拉满，这里初始化完成后交给 gcmh
(use-package gcmh
  :ensure t
  :hook (after-init . gcmh-mode))

(scroll-bar-mode 0)
(add-hook 'prog-mode-hook 'whitespace-mode)
;; (add-hook 'yaml-ts-mode-hook 'whitespace-mode)
;; 显示所有空格和制表符的符号
(setq whitespace-style '(face spaces tabs tab-mark trailing ))
(column-number-mode 1)
(global-visual-line-mode 1)
(add-hook 'prog-mode-hook (lambda ()
                            (visual-line-mode -1)
                            (setq truncate-lines t)))
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(setq custom-file "./custom.el")
(setq scroll-margin 5)
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq-default indent-tabs-mode nil)
(setq user-emacs-directory "~/.config/emacs/")
(global-hl-line-mode ); 所有编程模式自动开启代码折叠
;; 注意：hs-minor-mode 对不在 hs-special-modes-alist 里的 mode（如 rust-ts-mode）
;; 会直接 signal error，报错会中断 run-mode-hooks，使同一 mode-hook 链里后面的
;; 东西（例如 lsp-bridge 的自动启用）永远不执行。这里先判断支持与否再开。
(add-hook 'prog-mode-hook
          (lambda ()
            (when (assoc major-mode hs-special-modes-alist)
              (hs-minor-mode 1))))

;;; --- 基础视觉与交互配置 ---
;; menu-bar/tool-bar/scroll-bar 已在 early-init.el 前移关闭
(setq visible-bell t)
(setq org-src-fontify-natively t)
(which-key-mode 1)
(setopt use-short-answers t)
(require 'ox-md)
(use-package emacs
  :bind (("C-r" . revert-buffer)))

;;; --- 结构化括号编辑 (Smartparens) ---
(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1)
  (sp-with-modes '(racket-mode racket-hash-lang-mode racket-repl-mode)
    (sp-local-pair "'" nil :actions nil)
    (sp-local-pair "`" nil :actions nil)))

;;; --- 彩虹括号 (Rainbow Delimiters) ---
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; 使用 Shift + 方向键 在窗口间移动
(windmove-default-keybindings)

;; 字体配置：Maple Mono NF CN
(set-face-attribute 'default nil :font "Sarasa Fixed SC" :height 140 :weight 'regular)

;; Nerd Font 图标回退：Sarasa 没有 Nerd 字形，把 PUA 区间交给 Nerd Font。
;; 已安装的候选：IosevkaTerm Nerd Font Mono / NotoSansM Nerd Font Mono
;; 若之后装 nerd-fonts.symbols-only，可改成 "Symbols Nerd Font Mono"。
(defvar my/nerd-font-family "IosevkaTerm Nerd Font Mono"
  "用于 Nerd Font 图标回退的字体家族。")

(dolist (range '((#xE000 . #xF8FF)      ; BMP PUA（主要图标）
                 (#xF0000 . #xFFFFD)    ; Supplementary PUA-A
                 (#x100000 . #x10FFFD))) ; Supplementary PUA-B
  (set-fontset-font "fontset-default" range
                    (font-spec :family my/nerd-font-family) nil 'append))

(global-set-key (kbd "M-[") 'tab-bar-switch-to-prev-tab)
(global-set-key (kbd "M-]") 'tab-bar-switch-to-next-tab)
(setq tab-bar-select-tab-modifiers '(meta))
(global-set-key (kbd "M-1") (lambda () (interactive) (tab-bar-select-tab 1)))
(global-set-key (kbd "M-2") (lambda () (interactive) (tab-bar-select-tab 2)))
(global-set-key (kbd "M-3") (lambda () (interactive) (tab-bar-select-tab 3)))
(global-set-key (kbd "M-4") (lambda () (interactive) (tab-bar-select-tab 4)))
(global-set-key (kbd "M-5") (lambda () (interactive) (tab-bar-select-tab 5)))
(global-set-key (kbd "M-6") (lambda () (interactive) (tab-bar-select-tab 6)))
(global-set-key (kbd "M-7") (lambda () (interactive) (tab-bar-select-tab 7)))
(global-set-key (kbd "M-8") (lambda () (interactive) (tab-bar-select-tab 8)))
(global-set-key (kbd "M-9") (lambda () (interactive) (tab-bar-select-tab 9)))
(global-set-key (kbd "M-t") 'tab-bar-new-tab)

;; 确定文件夹存在，如果不存在则创建
(let ((target-dir "~/.config/emacs/auto-save/"))
  (unless (file-exists-p target-dir)
    (make-directory target-dir t)))

(setq auto-save-file-name-transforms
      `((".*" "~/.config/emacs/auto-save/" t)))

(setq create-lockfiles nil)

(setq backup-directory-alist
      `((".*" . "~/.config/emacs/backups/")))

;; 还可以顺便开启版本控制，保留多个旧版本
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;;; --- 网络与代理配置 ---
(require 'package)
(setq package-archives '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                         ;; ETAF 生态（etaf/ebox/ecss/etaf-ui + 应用）作者自建归档，未上 MELPA
                         ("etaf"   . "https://etaf.top/packages/")))
(package-initialize)

;; (setq url-proxy-services
;;       '(("http"  . "127.0.0.1:40808")
;;         ("https" . "127.0.0.1:40808")
;;         ("no_proxy" . "^127\\.0\\.0\\.1$")))

;; (use-package catppuccin-theme
;;   :ensure t
;;   :config
;;   ;; 设置你喜欢的风味：'latte, 'frappe, 'macchiato, 或 'mocha (默认)
;;   (setq catppuccin-flavor 'mocha) 
;;   (load-theme 'catppuccin :no-confirm))
(use-package base16-theme
  :ensure t
  :demand t  ; 确保立即加载，避免延迟导致主题无法应用
  :config
  (load-theme 'base16-everforest-light-medium t))
;; (use-package gruvbox-theme
;;   :ensure t
;;   :config
;;   ;; 设置你喜欢的风味：'latte, 'frappe, 'macchiato, 或 'mocha (默认)
;;   (load-theme 'gruvbox-dark-soft t))
;; (use-package solarized-theme
;;   :ensure t
;;   :init
;;   ;; 自定义选项必须在加载主题前设置
;;   (setq solarized-distinct-fringe-background t)   ; fringe 与背景色区分
;;   (setq solarized-high-contrast-mode-line t)      ; mode-line 高对比度
;;   ;; 可选：减少粗体、增加斜体等
;;   ;; (setq solarized-use-less-bold t)
;;   ;; (setq solarized-use-more-italic t)
;;   :config
;;   ;; 默认加载暗色主题（也可改为 'solarized-light）
;;   (load-theme 'solarized-light t)
;;   ;; 绑定快捷键快速切换亮暗
;;   (global-set-key (kbd "<f5>") #'solarized-toggle-theme))
;; (use-package zenburn-theme
;;   :ensure t
;;   :config
;;   (load-theme 'zenburn t))
;;; --- 垂直补全系统 (Minibuffer UI) ---
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  (setq vertico-cycle t))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;;; --- 代码片段系统 (Snippet) ---
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

(use-package yasnippet-capf
  :ensure t
  :after yasnippet)

(use-package markdown-mode
  :ensure t)

(use-package web-mode
  :ensure t  ; 如果未安装则自动安装[reference:3][reference:4]
  :mode ("\\.html?\\'"     . web-mode)  ; 自动关联 .html 文件[reference:5][reference:6]
        ("\\.vue\\'"       . web-mode)  ; 自动关联 .vue 文件[reference:7]
        ("\\.jsx\\'"       . web-mode)  ; 自动关联 .jsx 文件[reference:8]
        ("\\.djhtml\\'"    . web-mode)  ; 自动关联 Django 模板文件[reference:9]
  :config (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2)
)

;;; --- Tree-sitter modes (Emacs 30 内置 treesit) ---
(setq treesit-font-lock-level 4)
;; 内置基础模式存在 → remap 到 ts 模式
(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
(add-to-list 'major-mode-remap-alist '(css-mode    . css-ts-mode))
(add-to-list 'major-mode-remap-alist '(js-mode     . js-ts-mode))
;; 无基础模式的语言 → 后缀直接关联（实测 30.2 默认无任何 ts-mode 关联）
(dolist (e '(("\\.go\\'"   . go-ts-mode)         ("\\.java\\'" . java-ts-mode)
             ("\\.ts\\'"   . typescript-ts-mode) ("\\.tsx\\'"  . tsx-ts-mode)
             ("\\.json\\'" . json-ts-mode)       ("\\.yaml\\'" . yaml-ts-mode)
             ("\\.yml\\'"  . yaml-ts-mode)       ("\\.lua\\'"  . lua-ts-mode)
	     ("\\.nix\\'"  . nix-ts-mode)
	     ))
  (add-to-list 'auto-mode-alist e))
;; Emacs 30.2 的 rust-ts-mode 不会注册 .rs 后缀，且本机没装 rust-mode，
;; 结果 .rs 落到 fundamental-mode，lsp-bridge 因为 major-mode 不匹配而不启动 rust-analyzer
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))

;; bash: sh-mode 里按 shebang 判定，是 bash 才切 bash-ts-mode
;; （POSIX sh / dash / zsh 文件继续用 sh-mode，避免错误高亮）
(add-hook 'sh-mode-hook
          (lambda () (when (eq sh-shell 'bash) (bash-ts-mode))))

;; lsp-bridge 配置已抽到 my-lsp-bridge.el（submodule 在 user-emacs-directory 下）
(load (expand-file-name "my-lsp-bridge.el" user-emacs-directory) nil t)

;;; --- 代码行内补全 (Corfu + Cape) ---
;; (use-package corfu
;;   :ensure t
;;   :custom
;;   (corfu-auto t)
;;   (corfu-auto-prefix 2)
;;   (corfu-auto-delay 0.1) ; 让弹出更灵敏
;;   (corfu-quit-at-boundary 'separator)
;;   :init
;;   (global-corfu-mode))

;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (setq-local completion-at-point-functions
;;                         (remove 'ispell-completion-at-point completion-at-point-functions))))

;; ;; 安装 Cape 是解决“不弹窗”的终极方案
;; (use-package cape
;;   :ensure t
;;   :init
;;   ;; 这一步极其重要：手动将所有后端缝合在一起
;;   (add-to-list 'completion-at-point-functions #'cape-dabbrev)
;;   (add-to-list 'completion-at-point-functions #'cape-file)
;;   (add-to-list 'completion-at-point-functions #'yasnippet-capf)
;;   (add-to-list 'completion-at-point-functions #'cape-keyword)
;;   )

(use-package avy
  :ensure t
  :bind (
         ("M-j" . avy-goto-char-timer)
         ("M-J" . avy-goto-subword-0)
         ("M-g M-g" . avy-goto-line)
         ) ; 推荐绑定 M-s
  :config
  (setq avy-timeout-seconds 0.3)
  :custom
  ;; ① 关键：avy 默认键位是 QWERTY 主键行，改成 Colemak-DH 主键行
  (avy-keys '(?a ?r ?s ?t ?g ?m ?n ?e ?i ?o))
  (avy-style 'at-full)                    ; 候选标在词上，易读
  (avy-background t)                      ; 变暗背景，只高亮候选（减少噪音）
  (avy-all-windows t)                     ; 跨 frame 内所有窗口跳
  (avy-case-fold-search t)
  (avy-timeout-seconds 0.2)               ; 比你现在 0.3 更跟手
  ) ; 反应速度适配你的高性能 CPU

;;; --- 增强搜索与跳转 (Consult) ---
(use-package consult
  :ensure t
  ;; 绑定常用快捷键，建议模仿 Ivy/Swiper 的习惯
  :bind (;; 1. 替代 Swiper (Buffer 内搜索)
         ("C-s" . consult-line)
         ("M-s l" . consult-line)
         ;; 2. 增强型 Buffer 切换 (支持预览、分组)
         ("C-x b" . consult-buffer)
         ;; 3. 跳转到当前文件的符号 (函数、变量等)
         ("M-g i" . consult-imenu)
         ;; 4. 跳转到某一行
         ("M-g g" . consult-goto-line)
         ;; 5. 项目级全局搜索 (需要系统安装了 ripgrep)
         ("M-s r" . consult-ripgrep)
         ;; 6. 查看历史记录
         ("M-y" . consult-yank-pop)
	 ("M-s f" . consult-fd))

  :init
  ;; 配置预览功能：在选择时实时跳转到对应位置
  ;; 默认情况下，当你上下移动光标，主窗口会实时更新
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  ;;  :custom
  ;; 让 consult-find 使用 fd 替代 find
  ;; (consult-find-args "fd --color=never --full-path") 
  :config
  ;; 优化：在 consult-line 搜索时，按需显示预览
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   :preview-key 'any)
  (setq consult-find-args "fd --color=never --full-path --path-separator /")
  )
(use-package consult-notes
  :ensure t
  :after consult
  :init
  ;; 1. 配置你的笔记数据源（永久目录）
  (setq consult-notes-file-dir-sources
        '(("task" ?t "~/org/task/")
          ("roam" ?n "~/org/roam/")
          ("journal" ?j "~/org/journal/")
          ))

  :bind
  ;; 2. 绑定快捷键方便调用（C-c n f 已被 org-roam-node-find 占用，故用 / 与 s）
  (("C-c n /" . consult-notes)                    ; 选择源并搜索文件
   ("C-c n s" . consult-notes-search-in-all-notes))
  ) ; 所有源中搜索内容
(use-package expand-region
  :ensure t  ;; 如果本地没有，自动通过 ELPA/MELPA 安装
  :bind ("C-=" . er/expand-region)
  :config
  ;; 可选：如果你觉得 C-= 不好按，可以增加一个辅助缩减的键
  ;; 选中多了按这个可以缩回去
  (global-set-key (kbd "C--") 'er/contract-region))

;; Lua: 换用内置 lua-ts-mode（tree-sitter），保留 2 空格缩进习惯
(add-hook 'lua-ts-mode-hook
          (lambda () (setq-local lua-ts-indent-offset 2)))

;;; --- 代码折叠: treesit-fold(语法引擎) + kirigami(统一键位) ---
(use-package treesit-fold
  :ensure t
  :hook ((go-ts-mode python-ts-mode java-ts-mode js-ts-mode typescript-ts-mode
          tsx-ts-mode lua-ts-mode css-ts-mode json-ts-mode bash-ts-mode
          rust-ts-mode)
         . treesit-fold-mode)
  :config
  ;; fringe 折叠指示箭头
  (add-hook 'treesit-fold-mode-hook #'treesit-fold-indicators-mode))

;; kirigami 不是折叠引擎，是统一键位调度层：
;; ts-mode 缓冲区 → treesit-fold；org/elisp → outline/hs 等既有后端
;; 默认键位: C-c z a 切换 / c 折叠 / o 展开 / r 递归展开 / m 全部折叠
(use-package kirigami
  :ensure t
  :init
  (kirigami-global-mode 1))
(global-set-key (kbd "C-c z o") 'kirigami-open-fold)     ; Open fold at point
(global-set-key (kbd "C-c z O") 'kirigami-open-fold-rec) ; Open fold recursively
(global-set-key (kbd "C-c z r") 'kirigami-open-folds)    ; Open all folds
(global-set-key (kbd "C-c z c") 'kirigami-close-fold)    ; Close fold at point
(global-set-key (kbd "C-c z m") 'kirigami-close-folds)   ; Close all folds
(global-set-key (kbd "C-c z a") 'kirigami-toggle-fold)   ; Toggle fold at point

;;; --- 缩进参考线: indent-bars (GNU ELPA) ---
;; 注意: 会替换 font-lock-fontify-region-function，放在 init.el 靠后位置
(use-package indent-bars
  :ensure t
  :custom
  (indent-bars-treesit-support t)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  (indent-bars-treesit-scope
   '((python-ts-mode function_definition class_definition for_statement
                     if_statement with_statement while_statement)
     (go-ts-mode function_declaration method_declaration
                 if_statement for_statement block)
     (java-ts-mode method_declaration class_declaration
                   if_statement for_statement while_statement)
     (lua-ts-mode function_declaration if_statement for_statement
                  while_statement do_statement)
     (bash-ts-mode function_definition if_statement case_statement
                   for_statement while_statement)))
  ;; 若 Cairo+高DPI 下 stipple 花屏: (indent-bars-prefer-character t)
  :hook ((python-ts-mode go-ts-mode java-ts-mode lua-ts-mode bash-ts-mode)
         . indent-bars-mode))

;;; --- Racket / Scheme (SICP 学习) ---
(use-package racket-mode
  :ensure t
  :mode (("\\.rkt\\'" . racket-mode))
  :hook (racket-mode . racket-xp-mode)
  :config
  ;;  xs(setq racket-program "racket")
  )

(use-package easysession
  :ensure t
  :demand t
  :custom
  ;; 每 10 分钟自动保存
  (easysession-save-interval (* 10 60))

  ;; 切换 Session 前自动保存当前 Session
  (easysession-switch-to-save-session t)

  ;; 启动时不自动加载上次 Session：恢复上百 buffer 会让每次新开卡 ~17s。
  ;; 需要时用 C-c s l (easysession-switch-to) 手动切换。
  (easysession-setup-load-session nil)

  :config
  ;; 手动切换 Session
  (global-set-key (kbd "C-c s l") #'easysession-switch-to)

  ;; 保存当前 Session
  (global-set-key (kbd "C-c s s") #'easysession-save)

  ;; 重命名 Session
  (global-set-key (kbd "C-c s r") #'easysession-rename)

  ;; 删除 Session
  (global-set-key (kbd "C-c s d") #'easysession-delete)

  ;; 初始化自动加载、定时保存和退出保存
  (easysession-setup))

;; (use-package eglot
;;   :ensure nil ; Emacs 29+ 内置
;;   :hook (python-mode . eglot-ensure)
;;   :config

;;   ;; 强制 Python 使用 pyright（必须！FastAPI 全靠它）
;;   ;; (add-to-list 'eglot-server-programs
;;   ;;              '((python-mode python-ts-mode) . ("pyright" "--stdio")))

;;   ;; 配合 envrc，确保 eglot 启动前环境变量已就绪
;;   (add-hook 'eglot--managed-mode-hook
;;             (lambda () (when (fboundp 'envrc-mode) (envrc-mode 1)))))
(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode)
  :custom (envrc-async nil))   ; Nix 首次 eval 别卡死 Emacs

(use-package minions
  :ensure t
  :config
  (setq minions-mode-line-lighter " ·")                 ; 收起后的符号
  (setq minions-prominent-modes '(meow-normal-mode))    ; 只直接显示 meow 状态
  (minions-mode 1))

(global-set-key (kbd "C-.") 'duplicate-line)

(use-package rime
  :custom
  (default-input-method "rime")
  (rime-share-data-dir (expand-file-name "huma" user-emacs-directory))
  (rime-user-data-dir (expand-file-name "huma" user-emacs-directory))
  (rime-default-scheme "tigress") ; 虎码
  (rime-show-candidate 'posframe)
  
  :init
  
  :config

  ;; 2. 界面与默认行为
  (setq rime-mode-line-indicator '(" [中]" " [英]"))
  )
(global-set-key (kbd "M-i") #'toggle-input-method)
(setq rime-inline-ascii-trigger 'shift-r)
(setq rime-disable-predicates
      '(
	;; rime-predicate-prog-in-code-p
	;; rime-predicate-after-alphabet-char-p
	meow-normal-mode-p
        meow-motion-mode-p
        meow-keypad-mode-p
        meow-beacon-mode-p
	))
(setq rime-inline-predicates
      '(rime-predicate-space-after-cc-p)
      )

;; ;; 1. 安装并配置 nix-mode
;; (use-package nix-mode
;;   ;;  :ensure t
;;   :mode "\\.nix\\'")

;; ;; 2. 配置异步格式化工具 Apheleia (推荐)
;; (use-package apheleia
;;   :ensure t
;;   :config
;;   ;; 显式指定 nix-mode 使用 alejandra
;;   (setf (alist-get 'nix-mode apheleia-formatters)
;;         '("alejandra" "-"))
;;   (apheleia-global-mode +1))


;;; --- Org-mode 综合配置中心 ---
;; 先创建所需目录
(dolist (dir '("~/org" "~/org/task" "~/org/task/archive" "~/org/roam" "~/org/journal"))
  (let ((p (expand-file-name dir)))
    (unless (file-directory-p p)
      (make-directory p t)
      (message "Created dir: %s" p))))

;; 再创建根目录下的 org 文件
(dolist (file '("~/org/todo.org" "~/org/inbox.org"))
  (let ((p (expand-file-name file)))
    (unless (file-exists-p p)
      ;; 写入空内容生成文件
      (write-region "" nil p)
      (message "Created file: %s" p))))

(use-package org
  :ensure nil
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link))
  :custom
  ;; 1. 多维管理与状态流
  (org-agenda-files '("~/org/todo.org"))
  (org-todo-keywords
   '((sequence "TODO(t!)" "NEXT(n!)" "DOING(i!)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@/!)")))
  
  ;; 2. 日志与计时管理
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-clock-into-drawer t)
  (org-clock-out-when-done t)
  
  ;; 3. 视图偏好
  (org-agenda-span 7)
  (org-agenda-start-on-weekday nil)
  (org-startup-indented t)

  :config
  ;; --- ID 与 链接系统 (加载 org-id 以支持回溯) ---
  (require 'org-id)
  (require 'org-habit)
  (setq org-id-link-to-org-use-id 'create-if-interactive)
  (setq org-id-track-globally t)
  ;; --- 笔记系统模块：同步 / 回写 / 计时 ---
  (load (expand-file-name "my-org-notes.el" user-emacs-directory) nil t)
  (setq org-id-extra-files
        (append (directory-files-recursively
                 (expand-file-name "~/org/task") "\\.org\\'")
                (directory-files-recursively
                 (expand-file-name "~/org/roam") "\\.org\\'")))

  ;; --- Capture 模板配置 ---
  (setq org-capture-templates
        '(("t" "todo" entry (file "~/org/todo.org")
           "* TODO %?\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n"
            :prepend t)
          ("i" "inspiration" entry (file "~/org/inbox.org")
           "* %?\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n"
           :prepend t)
          ("j" "journal" entry
           (file+olp+datetree (lambda () (format-time-string "~/org/journal/%Y-%m.org")))
           "* %<%H:%M> 每日复盘\n- 今天推进了：%?\n- 卡点在：\n- 明天第一件事：\n"
           :tree-type week :unnarrowed t)
          ("n" "New task note" plain
           (file (lambda () (my/org-task-capture-file)))
           "#+TITLE: %?\n:PROPERTIES:\n:ID: %(org-id-new)\n:创建时间: %U\n:END:\n\n* 交付物\n\n* 要解决的问题\n\n* 行动清单\n\n* 动态日志\n\n* 参考资料与知识链接\n"
           :unnarrowed t)))
  ;; --- 自动化函数组：状态变更触发器 ---
  (defun my-org-todo-automation-h ()
    "NEXT 自动排程 + DOING 自动计时。"
    (unless my/org-sync-inhibit
      (cond
       ((string= org-state "NEXT")
        (org-schedule nil)
        (when (org-clocking-p)
          (let ((org-clock-out-switch-to-state nil))
     (org-clock-out))))
       ((string= org-state "DOING")
        (org-clock-in))
       ((and (not (string= org-state "DOING")) (org-clocking-p))
        (let ((org-clock-out-switch-to-state nil))
          (org-clock-out))))))

  (add-hook 'org-after-todo-state-change-hook #'my-org-todo-automation-h)

  ;; --- C-c r 已下线：原『归并到 SOURCE』命令与 SOURCE 键冲突，改由投影统一维护 ---
  )

(use-package ox-gfm
  :ensure t
  :after org
  :config
  (add-to-list 'org-export-backends 'gfm)
  )
;; (use-package org-modern
;;   :ensure t
;;   :hook (org-mode . org-modern-mode)
;;   :config
;;   (setq
;;    ;; 编辑时显示的样式
;;    ;;   org-modern-star '("?" "○" "?" "◇" "?") ; 替换原本的 * 号
;;    ;;   org-modern-list '((?- . "?") (?+ . "?")) ; 替换列表符号
;;    org-modern-todo t                       ; 让 TODO 变成圆角方块
;;    org-modern-priority t                   ; 让优先级 [#A] 变得更显眼
;;    org-modern-tag t                        ; 让 :Tag: 变成精美的标签
;;    ))

;;; --- Org-Roam 知识库配置 ---
(use-package org-roam
  :ensure nil
  :custom
  (org-roam-directory (file-truename "~/org/roam"))
  (org-roam-capture-templates
   '(("d" "card" plain "%?"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                         ":PROPERTIES:\n:ID: %(org-id-new)\n:创建: %U\n:来源: \n:END:\n#+title: ${title}\n#+FILETAGS: :card:\n\n* 相关概念\n\n* 来源与上下文\n\n* 被以下项目使用\n\n* 思考与行动启发\n")
      :unnarrowed t)
     ("h" "MOC" plain "%?"
      :target (file+head "MOC-%<%Y%m%d%H%M%S>-${slug}.org"
                         ":PROPERTIES:\n:ID: %(org-id-new)\n:创建: %U\n:END:\n#+title: ${title}\n#+FILETAGS: :MOC:\n\n* 核心概念\n\n* 流程与方法\n\n* 待探索\n")
      :unnarrowed t)
     ("s" "SOP" plain "%?"
      :target (file+head "SOP-%<%Y%m%d%H%M%S>-${slug}.org"
                         ":PROPERTIES:\n:ID: %(org-id-new)\n:创建: %U\n:END:\n#+title: ${title}\n#+FILETAGS: :sop:\n\n* 适用场景\n\n* 步骤\n\n* 检查清单\n")
      :unnarrowed t)
     ("p" "pitfall" plain "%?"
      :target (file+head "PITFALL-%<%Y%m%d%H%M%S>-${slug}.org"
                         ":PROPERTIES:\n:ID: %(org-id-new)\n:创建: %U\n:END:\n#+title: ${title}\n#+FILETAGS: :pitfall:\n\n* 现象\n\n* 原因\n\n* 解法\n")
      :unnarrowed t)))
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n l" . org-roam-buffer-toggle))
  :config
  (org-roam-db-autosync-mode))
(setq org-agenda-custom-commands
      '(("n" "复习看板：日程 + 任务池"
         ((agenda "" ((org-agenda-span 7)))      ; 上半部分：显示 7 天日程
          (alltodo ""                            ; 下半部分：显示所有待办任务
                   ((org-agenda-overriding-header "待复习任务池")
                    (org-agenda-files '("~/org/todo.org"))))))))

(use-package ace-window
  :ensure t
  :bind ("M-o" . ace-window)
  :config
  (setq aw-keys '(?a ?r ?s ?t ?g ?m ?n ?e ?i))) ; 使用左手常用键

(setq tab-bar-show 1)          ;; 始终显示标签栏
(setq tab-bar-new-button-show nil) ;; 保持简洁
(setq tab-bar-tab-hints t)     ;; 显示数字编号 (Meta-1, Meta-2 切换)

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :custom
  ;; 使用更现代的索引方式（配合 ripgrep/fd）
  (projectile-indexing-method 'alien)
  (projectile-enable-caching t)
  (projectile-completion-system 'vertico) ; 与你的 vertico 集成
  :bind-keymap
  ("C-c p" . projectile-command-map) ; 统一前缀，方便记忆
  )

;; 编写一个优雅的切换函数：切换项目时自动创建一个新 Tab 并命名
(defun my/project-switch-in-tab ()
  (interactive)
  (let ((project (project-current)))
    (tab-bar-new-tab)
    (call-interactively #'project-switch-project)
    (let ((name (project-name (project-current))))
      (tab-bar-rename-tab name))))

(global-set-key (kbd "C-x p t") #'my/project-switch-in-tab)


;; meow 配置已抽到 my-meow.el
(load (expand-file-name "my-meow.el" user-emacs-directory) nil t)

;; ETAF 应用（Markdown 预览）配置在 my-etaf.el
(load (expand-file-name "my-etaf.el" user-emacs-directory) nil t)

;;; --- VCS / AI：magit + vc-jj + majutsu + agent-shell ---

;; magit：纯 git 仓库的主力（也是 majutsu 的运行依赖）
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; vc-jj：VC 基线，让 C-x v 和 project.el 原生识别 jj 仓库（GNU ELPA）
(use-package vc-jj
  :ensure t)

;; majutsu：jj 仓库的 magit 风格 UI（不在 MELPA，从 GitHub pin v0.6.0）
;; 注意：v0.6.0 的入口是 majutsu-log（别名 majutsu），没有 majutsu-status
(use-package majutsu
  :vc (:url "https://github.com/0WD0/majutsu" :rev "v0.6.0")
  :after magit
  :bind ("C-x J" . majutsu-log))
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; agent-shell：opencode 的 Emacs 原生客户端（MELPA，走 server API 不嵌 TUI）
(with-eval-after-load 'majutsu-ediff
  (defun my/majutsu-ediff-merge-files (left base right output)
    "修复版：加 recursive-edit 阻塞等用户退出 ediff。"
    (let ((left (expand-file-name left))
          (base (expand-file-name base))
          (right (expand-file-name right))
          (output (expand-file-name output)))
      (add-hook 'ediff-quit-hook #'majutsu-ediff--exit-recursive-edit)
      (unwind-protect
          (progn
            (ediff-merge-files-with-ancestor left right base nil output)
            (recursive-edit))
        (remove-hook 'ediff-quit-hook #'majutsu-ediff--exit-recursive-edit))))
  (advice-add 'majutsu-ediff-merge-files :override #'my/majutsu-ediff-merge-files))

(use-package agent-shell
  :ensure t
  :commands (agent-shell-opencode-start-agent)
  :bind ("C-c C-o" . agent-shell-opencode-start-agent)
  :config
  ;; 指向 opencode v2（llm-agents.nix 提供的 opencode2，与 v1 的 opencode 并存）
  (setq agent-shell-opencode-acp-command
        '("/etc/profiles/per-user/zjw/bin/opencode2" "acp"))
  )

(use-package dirvish
  :ensure t
  :init (dirvish-override-dired-mode)
  :bind ("C-c d" . dirvish-side)
  :config
  (define-key dirvish-mode-map (kbd "?") #'dirvish-dispatch)
  (define-key dirvish-mode-map (kbd "TAB") #'dirvish-subtree-toggle)
  ;; 用 ls -A（--almost-all）隐藏 . 和 ..，其他隐藏文件照常显示。
  ;; 若想连 .git/.env 也藏起来，改用 dired-omit-mode + dired-omit-files。
  (setq dired-listing-switches "-Alh --group-directories-first")
  )

;;; --- 终端与服务面板 ---
;; vterm：Emacs 内的完整终端（process-compose TUI、htop 等）
(use-package vterm
  :bind ("C-c v" . vterm)
  :config
  ;; 默认 shell 用 zsh（NixOS 下的绝对路径，executable-find 兜底）
  (setq vterm-shell (or (executable-find "zsh") vterm-shell))
  ;; 让 .zshrc 跳过 zellij 自动启动
  (setq vterm-environment (append '("EMACS_VTERM=1") vterm-environment))
  (defun my/vterm-new (name)
    "Open a new vterm buffer named NAME."
    (interactive "sName: ")
    (let ((vterm-buffer-name (format "*vterm:%s*" name)))
      (vterm))))

;; prodigy：服务面板；每个项目组一个 process-compose 服务
(use-package prodigy
  :ensure t
  :bind ("C-c P" . prodigy)
  :config
  (load (expand-file-name "my-prodigy.el" user-emacs-directory) nil t))

;; 按仓库类型自动分派：有 .jj 用 majutsu，纯 git 用 magit
(defun my/vcs-status ()
  "根据当前仓库类型打开 majutsu-log 或 magit-status。"
  (interactive)
  (if (locate-dominating-file default-directory ".jj")
      (majutsu-log)
    (magit-status)))
(global-set-key (kbd "C-c j") #'my/vcs-status)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;; --- diff-hl：buffer 内内联显示 hunk 变更 ---
(use-package diff-hl
  :ensure t
  :hook ((prog-mode . diff-hl-mode)
         (org-mode . diff-hl-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (diff-hl-margin-mode -1)
  (setq diff-hl-show-hunk-inline t))

