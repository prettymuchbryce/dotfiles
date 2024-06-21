return {
  'madox2/vim-ai',
  config = function()
    vim.g.vim_ai_chat = {
      ui = {
        open_chat_command = 'below new | setlocal wrap | call vim_ai#MakeScratchWindow()',
      },
      options = {
        model = 'gpt-4o',
      },
    }
  end,
}
