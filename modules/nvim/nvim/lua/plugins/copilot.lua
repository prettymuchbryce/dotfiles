return {
  'github/copilot.vim',
  config = function()
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap('i', '<C-o>', 'copilot#Accept("<C-o>")', { silent = true, expr = true })
  end,
}
