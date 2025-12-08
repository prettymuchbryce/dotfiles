return {
  'Mofiqul/vscode.nvim',
  config = function()
    local c = require('vscode.colors').get_colors()
    require('vscode').setup {
      -- Set dark theme style
      style = 'dark',

      transparent = false,
      italic_comments = true,
      disable_nvimtree_bg = true,
      group_overrides = {
        Cursor = { fg = c.vscBack, bg = c.vscLightBlue, bold = true },
        TermCursor = { fg = c.vscBack, bg = c.vscLightBlue, bold = true },
        NormalNC = { bg = '#161616' },
      },
    }

    vim.opt.guicursor = table.concat({
      'n-v-c:block-Cursor/lCursor-blinkon100',
      'i-ci:ver25-Cursor/lCursor-blinkon100',
      'r-cr:hor20-Cursor/lCursor-blinkon100',
    }, ',')

    -- Force highlight groups after everything else
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      callback = function()
        vim.api.nvim_set_hl(0, 'Cursor', { fg = '#000000', bg = c.vscLightBlue, bold = true })
        vim.api.nvim_set_hl(0, 'TermCursor', { fg = '#000000', bg = c.vscLightBlue, bold = true })
      end,
    })

    vim.cmd.colorscheme 'vscode'
  end,
}
