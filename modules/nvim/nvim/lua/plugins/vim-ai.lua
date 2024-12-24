return {
  'madox2/vim-ai',
  init = function()
    vim.g.vim_ai_chat = {
      ui = {
        -- open_chat_command = 'below new | setlocal wrap | call vim_ai#MakeScratchWindow()',
        code_syntax_enabled = 1,
      },
    }
    vim.g.vim_ai_edit = {
      ui = {
        paste_mode = 1,
      },
    }
  end,
}
