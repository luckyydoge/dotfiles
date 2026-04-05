(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(global-visual-line-mode 1)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(electric-pair-mode 1)
(setq custom-file "./custom.el")
(setq user-emacs-directory "~/.config/emacs/")

;;; --- 基础视觉与交互配置 ---
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(setq visible-bell t)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(electric-pair-mode 1)
(which-key-mode 1)
;; 使用 Shift + 方向键 在窗口间移动
(windmove-default-keybindings)

;; 字体配置：Maple Mono NF CN
(set-face-attribute 'default nil :font "Sarasa Fixed SC" :height 160 :weight 'regular)


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

(use-package catppuccin-theme
  :ensure t
  :config
  ;; 设置你喜欢的风味：'latte, 'frappe, 'macchiato, 或 'mocha (默认)
  (setq catppuccin-flavor 'mocha) 
  (load-theme 'catppuccin :no-confirm))

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

;;; --- 代码行内补全 (Corfu + Cape) ---
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.1) ; 让弹出更灵敏
  (corfu-quit-at-boundary 'separator)
  :init
  (global-corfu-mode))

(add-hook 'org-mode-hook
          (lambda ()
            (setq-local completion-at-point-functions
                        (remove 'ispell-completion-at-point completion-at-point-functions))))

;; 安装 Cape 是解决“不弹窗”的终极方案
(use-package cape
  :ensure t
  :init
  ;; 这一步极其重要：手动将所有后端缝合在一起
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'yasnippet-capf)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  )

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

(use-package eglot
  :ensure nil ; Emacs 29+ 内置
  :hook (python-mode . eglot-ensure)
  :config
  ;; 配合 envrc，确保 eglot 启动前环境变量已就绪
  (add-hook 'eglot--managed-mode-hook
            (lambda () (when (fboundp 'envrc-mode) (envrc-mode 1)))))

(use-package envrc
  
  :hook (after-init . envrc-global-mode))

(use-package leetcode
  :ensure t
  :custom
  (leetcode-prefer-language "python")        ;; 设置你的主语言为 Java
  (leetcode-prefer-sql "mysql")
  (leetcode-save-solutions t)              ;; 自动保存你的解法
  (leetcode-directory "~/Documents/leetcode") ;; 解题代码存放路径
  :config				      ;
  ;; 如果你使用的是中国区账号，务必加上这行
  (setq leetcode-api-base "https://leetcode.cn")
  )

(global-set-key (kbd "C-.") 'duplicate-line)


(use-package rime
  :custom
  (default-input-method "rime")
  (rime-share-data-dir (expand-file-name "huma" user-emacs-directory))
  (rime-user-data-dir (expand-file-name "huma" user-emacs-directory))
  (rime-default-scheme "tigress") ; 虎码
  (rime-translate-keybindings '("C-`" "<shift>"))
  (rime-inline-ascii-trigger 'shift-l)
  (rime-show-candidate 'posframe)
  
  :init
  ;; 在加载前定义的辅助函数，确保 Minibuffer 逻辑可用
  (defun my/rime-toggle-inline ()
    "在 Minibuffer 中安全切换 Rime 的中英模式"
    (interactive)
    (if (fboundp 'rime-inline-ascii)
        (rime-inline-ascii)
      (message "Rime 未就绪")))
  
  :config
  ;; 1. 基础按键绑定
  (define-key rime-mode-map (kbd "C-`") 'rime-send-keybinding)
  (define-key rime-mode-map (kbd "M-i") 'rime-inline-ascii)
  (define-key minibuffer-local-map (kbd "M-i") #'my/rime-toggle-inline)

  ;; 2. 界面与默认行为
  (setq rime-mode-line-indicator '(" [中]" " [英]"))
  (set-input-method "rime") ; 确保全局默认

  ;; 3. 自动化钩子 (Hook)
  ;; 自动激活 Rime
  (add-hook 'after-change-major-mode-hook (lambda () (activate-input-method "rime")))
  
  )


;; 1. 安装并配置 nix-mode
(use-package nix-mode
  ;;  :ensure t
  :mode "\\.nix\\'")

;; 2. 配置异步格式化工具 Apheleia (推荐)
(use-package apheleia
  :ensure t
  :config
  ;; 显式指定 nix-mode 使用 alejandra
  (setf (alist-get 'nix-mode apheleia-formatters)
        '("alejandra" "-"))
  (apheleia-global-mode +1))


;;; --- Org-mode 综合配置中心 ---

(use-package org
  :ensure nil
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link))
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
  (setq org-id-link-to-org-use-id t)
  (setq org-id-track-globally t)

  ;; --- Capture 模板配置 ---
  (setq org-capture-templates
        '(("t" "todo" entry (file "~/org/todo.org")
           "* TODO %:description\n  :PROPERTIES:\n  :SOURCE: %a\n  :CREATED: %U\n  :END:\n" 
           :immediate-finish t :prepend t)))

  ;; --- 自动化函数组：状态变更触发器 ---
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

(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode)
  :config
  (setq
   ;; 编辑时显示的样式
   ;;   org-modern-star '("?" "○" "?" "◇" "?") ; 替换原本的 * 号
   ;;   org-modern-list '((?- . "?") (?+ . "?")) ; 替换列表符号
   org-modern-todo t                       ; 让 TODO 变成圆角方块
   org-modern-priority t                   ; 让优先级 [#A] 变得更显眼
   org-modern-tag t                        ; 让 :Tag: 变成精美的标签
   ))

;;; --- Org-Roam 知识库配置 ---
(use-package org-roam
  :ensure nil
  :custom
  (org-roam-directory (file-truename "~/org"))
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
