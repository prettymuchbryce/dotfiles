-- Change working directory to file's directory on startup (only once)
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Change to file directory on startup',
  group = vim.api.nvim_create_augroup('startup-chdir', { clear = true }),
  callback = function()
    local file = vim.fn.expand('%:p')
    if file ~= '' and vim.fn.isdirectory(file) == 0 then
      vim.cmd('cd ' .. vim.fn.expand('%:p:h'))
    end
  end,
})

local format_sync_grp = vim.api.nvim_create_augroup('GoFormat', {})
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.go',
  callback = function()
    require('go.format').goimport()
  end,
  group = format_sync_grp,
})

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
