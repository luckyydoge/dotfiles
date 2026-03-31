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

;; (let ((my-leetcode-venv (expand-file-name "~/.emacs.d/leetcode-env/Scripts/python.exe")))
;;   (setq leetcode-python-binary my-leetcode-venv)
;;   ;; 这一行最关键：有些插件如果检测到路径存在就不会再尝试执行 venv --clear 那行报错命令
;;   (setq leetcode-venv-executable-path my-leetcode-venv)
;;   ;; 强制告诉插件环境已经准备好了，不要再自动安装
;;   (setq leetcode-setup-done t))

(use-package rime
  ;;  :ensure t
  :custom
  (default-input-method "rime")
  (rime-share-data-dir (expand-file-name "huma" user-emacs-directory))
  (rime-user-data-dir (expand-file-name "huma" user-emacs-directory))
  (rime-default-scheme "tigress")
  (rime-translate-keybindings '("C-`" "<shift>"))
  (rime-inline-ascii-trigger 'shift-l)
  (rime-show-candidate 'posframe)
  
  :config
  ;; 2. 关键：强制 Emacs 在 rime 模式下将此键发送给引擎
  (define-key rime-mode-map (kbd "C-`") 'rime-send-keybinding)
  (define-key rime-mode-map (kbd "M-i") 'rime-inline-ascii)
  )

;; (set-selection-coding-system 'chinese-gbk-dos)
;; (setq rime-translate-keybindings '("C-`"))

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


;;; --- Org Agenda & TodoList 配置 ---
(use-package org
  :ensure nil
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link))
  :custom
  ;; 1. 多维管理：核心四个文件
  ;; (org-agenda-files '("~/org/inbox.org" 
  ;;                     "~/org/gtd.org"
  ;;                     "~/org/projects.org"
  ;;                     "~/org/journal.org"))

  ;; 2. 状态流设计：体现“系统运行”思想
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n!)" "DOING(i!)" "WAIT(w@/!)" "|" "DONE(d!)" "ABORT(a@/!)")))

  ;; 3. 记录日志到抽屉，保持界面整洁
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-clock-into-drawer t)
  (org-clock-out-when-done t) ; 任务完成自动停止计时

  (org-agenda-span 7)
  (org-agenda-start-on-weekday nil)

  :config

  ;; (defun my-org-journal-path ()
  ;;   "生成路径格式：~/org/journal/2026/03-March/2026-03-29.org"
  ;;   (let* ((journal-dir "~/org/journal/")
  ;;          (year  (format-time-string "%Y"))
  ;;          (month (format-time-string "%m-%B"))
  ;;          (day   (format-time-string "%Y-%m-%d"))
  ;;          (dest-dir (expand-file-name (concat journal-dir year "/" month "/"))))
  ;;     ;; 如果文件夹不存在，自动创建（mkdir -p）
  ;;     (unless (file-directory-p dest-dir)
  ;; 	(make-directory dest-dir t))
  ;;     (concat dest-dir day ".org")))
  
  ;; 4. RIDE 循环与墨氏复盘捕获模板
  ;; (setq org-capture-templates
  ;;       '(("t" "Todo" entry (file+headline "~/org/inbox.org" "收集箱")
  ;;          "* TODO %?\n  创建时间: %U\n  来自: %a")
  
  ;;         ("m" "面试/会议" entry (file+headline "~/org/gtd.org" "日程")
  ;;          "* NEXT %?\n  SCHEDULED: %^t\n  %i")

  ;;         ;; --- 墨苍离方法论专属模板 ---
  ;;         ("p" "RIDE 项目(按需学习)" entry (file+headline "~/org/projects.org" "认知工程")
  ;;          "* %^{项目/卡点名称}\n** [R] 侦察\n- [ ] 绘制地图：此领域核心概念是什么？\n** [I] 定位\n- [ ] 核心卡点：不解决就走不动的那一步？\n** [D] 深钻\n- [ ] 针对性学习：学到刚好能做下一步决策\n** [E] 执行与萃取\n- [ ] 最小可行执行\n- [ ] 经验萃取：模型参数有哪些变化？")

  ;;         ("r" "每日复盘(认知减熵)" entry (file my-org-journal-path)
  ;;          "* 🌙 %U 复盘回溯\n** 1. 事实与有效归因 (剥离自我)\n%i\n- 事件：[客观动作/结果]\n- 归因：[内/外、稳定/暂时、可控/不可控]\n** 2. 模式识别 (参数分析)\n- 触发器：\n- 系统反应：\n- 潜在模型：[是哪种知见障？]\n** 3. 明日脚本 (If-Then)\n- 如果发生：\n- 那么行动：[具体的参数调整]")))

  ;; 5. 自动化函数组
  (defun my-org-todo-automation-h ()
    "整合：NEXT 自动排程 + DOING 自动计时"
    (cond 
     ;; 切换到 NEXT 时弹出日历
     ((string= org-state "NEXT")
      (org-schedule nil))
     
     ;; 切换到 DOING 时开始计时
     ((string= org-state "DOING")
      (org-clock-in))
     
     ;; 切换到其他状态（如 WAIT, DONE, ABORT）且正在计时，则停止计时
     ((and (member org-state '("TODO" "NEXT" "WAIT" "DONE" "ABORT"))
           (org-clocking-p))
      (org-clock-out))))

  ;; 将整合后的函数挂载到状态变更钩子
  (add-hook 'org-after-todo-state-change-hook #'my-org-todo-automation-h))

;; --- 外部增强配置 ---

;; 配合 org-modern 优化界面
(with-eval-after-load 'org-agenda
  (require 'org-modern)
  (add-hook 'org-agenda-finalize-hook #'org-modern-agenda))
