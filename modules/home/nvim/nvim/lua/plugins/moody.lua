return {
  'svampkorg/moody.nvim',
  event = { 'ModeChanged', 'BufWinEnter', 'WinEnter' },
  opts = function()
    local c = require('vscode.colors').get_colors()
    return {
      blends = {
        normal = 0.2,
        insert = 0.2,
        visual = 0.2,
        command = 0.2,
        operator = 0.2,
        replace = 0.2,
        select = 0.2,
        terminal = 0.2,
        terminal_n = 0.2,
      },
      colors = {
        normal = c.vscLightBlue,
        insert = c.vscGreen,
        visual = c.vscViolet,
        command = c.vscYellow,
        operator = c.vscOrange,
        replace = c.vscRed,
        select = c.vscViolet,
        terminal = c.vscGreen,
        terminal_n = c.vscLightBlue,
      },
      bold_nr = true,
      extend_to_linenr = true,
      disabled_filetypes = { 'TelescopePrompt', 'NvimTree' },
    }
  end,
}
