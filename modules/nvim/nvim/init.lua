require 'keymaps'
require 'options'
require 'commands'

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  require 'plugins.vim-slueth',
  require 'plugins.comment',
  require 'plugins.gitsigns',
  require 'plugins.which-key',
  require 'plugins.telescope',
  require 'plugins.vim-ai',
  require 'plugins.nvim-lspconfig',
  require 'plugins.conform',
  require 'plugins.copilot-lua',
  require 'plugins.nvim-cmp',
  require 'plugins.todo-comments',
  require 'plugins.nvim-tree',
  require 'plugins.nvim-treesitter',
  require 'plugins.gitlinker',
  require 'plugins.vim-surround',
  require 'plugins.vscode',
  require 'plugins.bufferline',
  require 'plugins.vim-qfedit',
  require 'plugins.nvim-bqf',
  require 'plugins.lualine',
  require 'plugins.fugitive',
  require 'plugins.gh',
  require 'plugins.rainbow-delimiters',
  require 'plugins.vim-dadbod-ui',
  require 'plugins.codecompanion',
  require 'plugins.vim-gnupg',
  require 'plugins.hardtime',
}, {
  performance = {
    rtp = {
      -- This is true by default, but removes our custom rtp
      -- which means notes below will fail to load.
      reset = false,
    },
  },
})

require 'notes'
