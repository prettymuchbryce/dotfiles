return {
  'madox2/vim-ai',
  init = function()
    -- vim.g.vim_ai_token_file_path = vim.fn.expand '~/.config/open-router.token'
    -- vim.g.vim_ai_debug = 1
    vim.g.vim_ai_chat = {
      ui = {
        open_chat_command = 'below new | setlocal wrap | call vim_ai#MakeScratchWindow()',
      },
      options = {
        -- endpoint_url = 'https://openrouter.ai/api/v1',
        model = 'o1-preview',
        -- enable_auth = 1,
      },
    }
    vim.g.vim_ai_edit = {
      options = {
        -- endpoint_url = 'https://openrouter.ai/api/v1',
        model = 'o1-preview',
        -- enable_auth = 1,
      },
    }
  end,
}
