return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup()

    -- vim.api.nvim_set_keymap('n', '[b', ':BufferLineCycleNext<CR>', { silent = true })
    -- vim.api.nvim_set_keymap('n', 'b]', ':BufferLineCyclePrev<CR>', { silent = true })
  end,
}
