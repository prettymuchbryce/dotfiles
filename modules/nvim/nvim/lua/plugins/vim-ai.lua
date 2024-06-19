return {
  'madox2/vim-ai',
  config = function()
    vim.g.vim_ai_chat = {
      ui = {
        open_chat_command = 'below new | setlocal wrap | call vim_ai#MakeScratchWindow()',
      },
      options = {
        model = 'llama3:70b',
        endpoint_url = 'http://localhost:11434/v1/chat/completions',
      },
    }
  end,
}
