return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  event = 'VeryLazy',
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  vim.keymap.set('n', '-', '<CMD>Oil --float <CR>', { desc = 'Open parent directory' }),
}
