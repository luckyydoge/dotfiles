return {
  'nvim-java/nvim-java',
  dependencies = {
    -- 核心 LSP 和安装工具
    'nvim-java/nvim-java-core',
    'nvim-java/nvim-java-test',
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',

    -- 调试支持
    'mfussenegger/nvim-dap',

    -- 增强功能
    'nvim-tree/nvim-web-devicons',
  },
  ft = { 'java' },
  config = function()
    -- require('java').setup()
    -- require('lspconfig').jdtls.setup {}
    -- require('java').build.build_workspace()
  end,
}
