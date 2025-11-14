vim.keymap.set('n', '<leader>x', ':s/\\[ \\]/[x]<CR>', {
  desc = 'finish todo',
  noremap = true,
  silent = true,
  buffer = true,
})

vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
