return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup()

    -- TODO: Fix this.
    -- TODO: Install lualine.
    vim.api.nvim_set_keymap('n', '<C-k>', ':BufferLineCycleNext<CR>', { silent = true })
    vim.api.nvim_set_keymap('n', '<C-l>', ':BufferLineCyclePrev<CR>', { silent = true })
  end,
}
