return {
  'github/copilot.vim',
  cmd = 'Copilot',
  event = 'InsertEnter',
  init = function()
    vim.g.copilot_filetypes = {
      markdown = false,
      text = false,
    }
  end,
}
