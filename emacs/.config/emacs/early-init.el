;;; early-init.el --- Emacs 27+ 最早加载，先于包系统和 GUI 初始化 -*- lexical-binding: t; -*-
;; 新建 frame 就不带这些控件，避免 GTK 先创建菜单栏/工具栏再销毁
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . 0) default-frame-alist)

;; 启动全程 GC 阈值拉满，初始化完毕后由 init.el 里的 gcmh 接管
(setq gc-cons-threshold most-positive-fixnum)

;; 子进程单次读取上限提到 1MB（默认 4KB），LSP 大 JSON 响应/tramp/vterm 都受益
(setq read-process-output-max (* 1024 1024))

;; native-comp：异步编译告警不弹 *Warnings* 窗口
(setq native-comp-async-report-warnings-errors 'silent)

;;; early-init.el ends here
