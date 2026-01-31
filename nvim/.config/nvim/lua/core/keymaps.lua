vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save change' })
vim.keymap.set('n', '<leader>wa', ':wa<CR>', { desc = 'Save all change' })

-- 切换到下一个 Tab（替代默认的 gt，更直观）
-- vim.keymap.set('n', '<leader>tl', 'gt', { desc = 'Go to next tab' })
-- 切换到上一个 Tab（替代默认的 gT）
-- vim.keymap.set('n', '<leader>th', 'gT', { desc = 'Go to previous tab' })
-- 关闭当前 Tab（替代 :tabclose）
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'Close current tab' })
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'Create a new tab' })
