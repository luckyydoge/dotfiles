-- For `plugins/markview.lua` users.
return {
  'OXY2DEV/markview.nvim',
  ft = { 'markdown', 'typst' },
  opts = {
    preview = {

      hybrid_modes = { 'i', 'n' },
      linewise_hybrid_mode = true,
    },
  },

  -- For blink.cmp's completion
  -- source
  -- dependencies = {
  --     "saghen/blink.cmp"
  -- },
}
