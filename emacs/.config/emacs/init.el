(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(global-visual-line-mode 1)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(setq custom-file "./custom.el")
(setq scroll-margin 5)
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq user-emacs-directory "~/.config/emacs/")
(global-hl-line-mode 1)
					; 所有编程模式自动开启代码折叠
(add-hook 'prog-mode-hook #'hs-minor-mode)

;;; --- 基础视觉与交互配置 ---
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(setq visible-bell t)
(setq display-line-numbers-type 'relative)
(setq org-src-fontify-natively t)
(global-display-line-numbers-mode 1)
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
(set-face-attribute 'default nil :font "Sarasa Fixed SC" :height 160 :weight 'regular)

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
                         ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
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
(use-package gruvbox-theme
  :ensure t
  :config
  ;; 设置你喜欢的风味：'latte, 'frappe, 'macchiato, 或 'mocha (默认)
  (setq catppuccin-flavor 'mocha) 
  (load-theme 'gruvbox-dark-medium t))

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

;; (add-to-list 'load-path "./lsp-bridge")
(add-to-list 'load-path (expand-file-name "lsp-bridge" (file-name-directory load-file-name)))

(require 'yasnippet)
(yas-global-mode 1)

(require 'lsp-bridge)
(global-lsp-bridge-mode)
(setq acm-backend-order '( "template-first-part-candidates" "mode-first-part-candidates"
 "tabnine-candidates" "copilot-candidates" "codeium-candidates"
 "template-second-part-candidates" "mode-second-part-candidates")
)
;; (setq lsp-bridge-python-command "python-lsp-bridge")

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
  :bind (("M-j" . avy-goto-char-timer)) ; 推荐绑定 M-s
  :config
  (setq avy-timeout-seconds 0.3)) ; 反应速度适配你的高性能 CPU

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
          ))

  :bind
  ;; 2. 绑定快捷键方便调用
  ;; (("C-c n f" . consult-notes)                    ; 选择源并搜索文件
  ;;  ("C-c n s" . consult-notes-search-in-all-notes))
  ) ; 所有源中搜索内容
(use-package expand-region
  :ensure t  ;; 如果本地没有，自动通过 ELPA/MELPA 安装
  :bind ("C-=" . er/expand-region)
  :config
  ;; 可选：如果你觉得 C-= 不好按，可以增加一个辅助缩减的键
  ;; 选中多了按这个可以缩回去
  (global-set-key (kbd "C--") 'er/contract-region))

(use-package lua-mode
  :ensure t
  :mode "\\.lua\\'"
  :interpreter "lua"
  :config
  (setq lua-indent-level 2)) ; 设置缩进为 2（Lua 社区惯例）

;;; --- Racket / Scheme (SICP 学习) ---
(use-package racket-mode
  :ensure t
  :mode (("\\.rkt\\'" . racket-mode))
  :hook (racket-mode . racket-xp-mode)
  :config
  ;;  xs(setq racket-program "racket")
  )

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

;; (use-package envrc

;;   :hook (after-init . envrc-global-mode))


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
      '(rime-predicate-prog-in-code-p
	rime-predicate-after-alphabet-char-p
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
(dolist (dir '("~/org" "~/org/task" "~/org/roam"))
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
         ("C-c l" . org-store-link)
	 ("C-c r" . my/org-refile-to-source-id-insert-at-top)
	 )
  :custom
  ;; 1. 多维管理与状态流
  (org-agenda-files '("~/org/todo.org"))
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n!)" "DOING(i!)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@/!)")))
  
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
  (setq org-id-link-to-org-use-id 'create-if-interactive)
  (setq org-id-track-globally t)

  ;; --- Capture 模板配置 ---
  (setq org-capture-templates
        '(("t" "todo" entry (file "~/org/todo.org")
           "* TODO %:description\n  :PROPERTIES:\n  :SOURCE: %a\n  :CREATED: %U\n  :END:\n" 
           :immediate-finish t :prepend t)
	  ("n" "New task note" plain
           (file (lambda ()
                   (let* ((name (read-string "任务名称: "))
                          (date-str (format-time-string "%Y-%m-%d"))
                          (clean-name (replace-regexp-in-string
                                       "[^a-zA-Z0-9\u4e00-\u9fa5-]" ""
                                       (replace-regexp-in-string " " "-" name))))
                     (expand-file-name
                      (concat date-str "-" clean-name ".org")
                      "~/org/task/"))))
           "#+DATE: %U\n\n* %?")
	  ))  ;; --- 自动化函数组：状态变更触发器 ---
  (defun my-org-todo-automation-h ()
    "整合：NEXT 自动排程 + DOING 自动计时"
    (cond 
     ((string= org-state "NEXT") (org-schedule nil))
     ((string= org-state "DOING") (org-clock-in))
     ((and (not (string= org-state "DOING")) (org-clocking-p)) (org-clock-out))))

  (add-hook 'org-after-todo-state-change-hook #'my-org-todo-automation-h)

  ;; --- 自定义功能：任务归并 (Refile to Source ID) ---
  (defun my/org-refile-to-source-id-insert-at-top ()
    "将任务内容插入至源笔记 ID 标题的正下方，并删除目标处的 ID。"
    (interactive)
    (let* ((source (org-entry-get nil "SOURCE"))
           (id (when (and source (string-match "id:\\([a-z0-9-]+\\)" source))
                 (match-string 1 source))))
      (if (not id)
          (user-error "没有有效的 SOURCE ID")
        (let ((m (org-id-find id)))
          (if (not m)
              (user-error "找不到目标 ID %s" id)
            (let* ((target-file (car m))
                   (target-pos (cdr m))
                   (entry-text (save-excursion
                                 (org-back-to-heading t)
                                 (let ((beg (save-excursion (forward-line 1) (point)))
                                       (end (org-end-of-subtree t t)))
                                   (buffer-substring-no-properties beg end)))))
              (with-current-buffer (find-file-noselect target-file)
                (save-excursion
                  (goto-char target-pos)
                  (org-back-to-heading t)
                  (org-delete-property "ID")
                  (end-of-line)
                  (insert "\n" entry-text)
                  (unless (bolp) (insert "\n"))
                  (save-buffer)))
              (org-cut-subtree)
              (message "内容已归并，ID 已清理。")))))))
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
   '(("d" "default" plain "%?"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
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

;; 编写一个优雅的切换函数：切换项目时自动创建一个新 Tab 并命名
(defun my/project-switch-in-tab ()
  (interactive)
  (let ((project (project-current)))
    (tab-bar-new-tab)
    (call-interactively #'project-switch-project)
    (let ((name (project-name (project-current))))
      (tab-bar-rename-tab name))))

(global-set-key (kbd "C-x p t") #'my/project-switch-in-tab)

;; (defun my/get-pyright-path ()
;;   "从 direnv 环境中获取 pyright 路径"
;;   (let* ((default-directory (locate-dominating-file default-directory ".envrc")))
;;     (when default-directory
;;       (string-trim
;;        (shell-command-to-string
;;         "direnv exec . which pyright 2>/dev/null")))))

;; (with-eval-after-load 'eglot
;;   (add-to-list 'eglot-server-programs
;;                '(python-mode . (lambda ()
;;                                  (let ((pyright-path (my/get-pyright-path)))
;;                                    (if pyright-path
;;                                        (list pyright-path)
;;                                      '("pyright")))))))

;; meow 配置


(use-package meow
  :ensure t
  :config
  (defun meow-setup ()
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-colemak)
    (meow-motion-define-key
     ;; Use e to move up, n to move down.
     ;; Since special modes usually use n to move down, we only overwrite e here.
     '("e" . meow-prev)
     '("<escape>" . ignore))
    (meow-leader-define-key
     '("?" . meow-cheatsheet)
     '("1" . meow-digit-argument)
     '("2" . meow-digit-argument)
     '("3" . meow-digit-argument)
     '("4" . meow-digit-argument)
     '("5" . meow-digit-argument)
     '("6" . meow-digit-argument)
     '("7" . meow-digit-argument)
     '("8" . meow-digit-argument)
     '("9" . meow-digit-argument)
     '("0" . meow-digit-argument))
    (meow-normal-define-key
     '("0" . meow-expand-0)
     '("1" . meow-expand-1)
     '("2" . meow-expand-2)
     '("3" . meow-expand-3)
     '("4" . meow-expand-4)
     '("5" . meow-expand-5)
     '("6" . meow-expand-6)
     '("7" . meow-expand-7)
     '("8" . meow-expand-8)
     '("9" . meow-expand-9)
     '("-" . negative-argument)
     '(";" . meow-reverse)
     '("," . meow-inner-of-thing)
     '("." . meow-bounds-of-thing)
     '("[" . meow-beginning-of-thing)
     '("]" . meow-end-of-thing)
     '("/" . meow-visit)
     '("a" . meow-append)
     '("A" . meow-open-below)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("c" . meow-change)
     '("e" . meow-prev)
     '("E" . meow-prev-expand)
     '("f" . meow-find)
     '("g" . meow-cancel-selection)
     '("G" . meow-grab)
     '("m" . meow-left)
     '("M" . meow-left-expand)
     '("i" . meow-right)
     '("I" . meow-right-expand)
     '("j" . meow-join)
     '("k" . meow-kill)
     '("l" . meow-line)
     '("L" . meow-goto-line)
     '("h" . meow-mark-word)
     '("H" . meow-mark-symbol)
     '("n" . meow-next)
     '("N" . meow-next-expand)
     '("o" . meow-block)
     '("O" . meow-to-block)
     '("p" . meow-yank)
     '("q" . meow-quit)
     '("r" . meow-replace)
     '("s" . meow-insert)
     '("S" . meow-open-above)
     '("t" . meow-till)
     '("u" . meow-undo)
     '("U" . meow-undo-in-selection)
     '("v" . meow-search)
     '("w" . meow-next-word)
     '("W" . meow-next-symbol)
     '("x" . meow-delete)
     '("X" . meow-backward-delete)
     '("y" . meow-save)
     '("z" . meow-pop-selection)
     '("'" . repeat)
     '("<escape>" . ignore)))
  )
(meow-setup)
(meow-global-mode 1)
