return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    terminal_cmd = 'claude --dangerously-skip-permissions',
  },
  keys = {
    {
      '<leader>ac',
      '<cmd>ClaudeCode<cr>',
      desc = 'Toggle Claude Code',
      mode = { 'n' },
    },
    {
      '<leader>as',
      '<cmd>ClaudeCodeSend<cr>',
      desc = 'Send to Claude Code',
      mode = { 'v' },
    },
    {
      '<leader>aa',
      '<cmd>ClaudeCodeAdd<cr>',
      desc = 'Add file to Claude Code',
      mode = { 'n' },
    },
  },
}
