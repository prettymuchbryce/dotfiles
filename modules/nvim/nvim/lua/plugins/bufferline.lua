return {
  'akinsho/bufferline.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup()

    vim.api.nvim_set_keymap('n', '<C-k>', ':BufferLineCycleNext<CR>', { silent = true })
    vim.api.nvim_set_keymap('n', '<C-l>', ':BufferLineCyclePrev<CR>', { silent = true })
  end,
}
