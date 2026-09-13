;;; my-etaf.el --- ETAF 应用：Markdown 预览  -*- lexical-binding: t; -*-
;;; Commentary:
;; etaf-md-preview 把 Markdown 渲染成普通 buffer（文本属性 + 像素空格），
;; 不需要浏览器、不需要 markdown/pandoc 转换器。产物是只读 buffer，
;; isearch / 分屏 / 大纲导航照旧。
;;
;; 包来自作者自建归档 https://etaf.top/packages/（未上 MELPA/GNU ELPA），
;; 归档已在 init.el 的 package-archives 里注册。
;;
;; 注意：整个 ETAF 生态是 2026-10 新建的单人项目，API 可能在小版本间变动；
;; 这里只用作只读阅读视图，不承载任何数据回写逻辑。
;;
;; 用法：C-c m 打开当前文件的预览；在预览 buffer 里按 r 重新渲染。
;;; Code:

(use-package etaf-md-preview
  :ensure t
  :commands etaf-md-preview-open
  :custom
  ;; 跟随当前 Emacs 主题明暗，不写死配色
  (etaf-md-preview-theme 'auto)
  :bind ("C-c m" . etaf-md-preview-open))

(provide 'my-etaf)
;;; my-etaf.el ends here
