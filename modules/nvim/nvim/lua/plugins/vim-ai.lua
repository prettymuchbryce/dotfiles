local vim_ai_endpoint_url = 'http://localhost:11434/v1/chat/completions'
local vim_ai_model = 'qwen2.5-coder:32b'
local vim_ai_temperature = 0.3

return {
  'madox2/vim-ai',
  init = function()
    -- vim.g.vim_ai_token_file_path = vim.fn.expand '~/.config/open-router.token'
    -- vim.g.vim_ai_debug = 1
    vim.g.vim_ai_chat = {
      ui = {
        open_chat_command = 'below new | setlocal wrap | call vim_ai#MakeScratchWindow()',
        code_syntax_enabled = 1,
      },
      options = {
        -- endpoint_url = 'https://openrouter.ai/api/v1',
        model = vim_ai_model,
        temperature = vim_ai_temperature,
        endpoint_url = vim_ai_endpoint_url,
        enable_auth = 0,
        max_tokens = 0,
        request_timeout = 60,
        -- enable_auth = 1,
      },
    }
    vim.g.vim_ai_edit = {
      ui = {
        paste_mode = 1,
      },
      options = {
        -- endpoint_url = 'https://openrouter.ai/api/v1',
        model = vim_ai_model,
        temperature = vim_ai_temperature,
        endpoint_url = vim_ai_endpoint_url,
        enable_auth = 0,
        max_tokens = 0,
        request_timeout = 60,
        -- enable_auth = 1,
      },
    }
  end,
}
