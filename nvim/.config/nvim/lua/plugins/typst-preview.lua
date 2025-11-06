return {
  'chomosuke/typst-preview.nvim',
  ft = 'typst', -- 仅在打开 .typ 文件时加载
  version = '1.*',
  opts = {
    -- 可以在这里设置配置选项，例如：
    -- server_args = { '--host', '127.0.0.1:0' },
  },
  keys = {
    -- 映射一个快捷键来启动预览
    {
      '<leader>tp',
      ':TypstPreview<CR>',
      desc = 'Typst Preview',
    },
  },
}
