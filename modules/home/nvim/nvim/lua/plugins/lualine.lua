return {
  'nvim-lualine/lualine.nvim',
  cond = not vim.env.NVIM_OVIM,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'vscode',
      },
    }
  end,
}
