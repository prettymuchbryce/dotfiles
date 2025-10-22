return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    strategies = {
      -- Change the default chat adapter
      chat = {
        adapter = 'anthropic',
      },
      inline = {
        adapter = 'anthropic',
      },
    },
    opts = {
      -- Set debug logging
      log_level = 'DEBUG',
    },
  },
  keys = { -- Add a keybinding for the chat command
    {
      '<leader>cc',
      '<cmd>CodeCompanionChat<CR>',
      desc = 'Code Companion Chat',
    },
    {
      '<leader>ch',
      '<cmd>CodeCompanionActions<CR>',
      desc = 'Code Companion Actions',
    },
    {
      '<leader>co',
      '<cmd>CodeCompanion<CR>',
      desc = 'Code Companion',
    },
  },
}
