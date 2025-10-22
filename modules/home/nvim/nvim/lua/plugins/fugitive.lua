return {
  'tpope/vim-fugitive',
  config = function()
    -- Set vertical diff as default
    vim.opt.diffopt:append 'vertical'

    -- Auto-resize git buffers to 80 columns
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'fugitive', 'git', 'gitcommit' },
      callback = function()
        vim.cmd 'vertical resize 80'
      end,
    })
  end,
}
