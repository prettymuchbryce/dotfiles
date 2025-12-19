-- nvim-tree mappings
local function on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts 'CD')
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts 'Open: In Place')
  vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts 'Info')
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts 'Rename: Omit Filename')
  vim.keymap.set('n', '<C-t>', api.node.open.tab, opts 'Open: New Tab')
  vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts 'Open: Vertical Split')
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts 'Open: Horizontal Split')
  vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts 'Close Directory')
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', '<Tab>', api.node.open.preview, opts 'Open Preview')
  vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts 'Next Sibling')
  vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts 'Previous Sibling')
  vim.keymap.set('n', '.', api.node.run.cmd, opts 'Run Command')
  vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts 'Up')
  vim.keymap.set('n', 'a', api.fs.create, opts 'Create')
  vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts 'Move Bookmarked')
  vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts 'Toggle No Buffer')
  vim.keymap.set('n', 'c', api.fs.copy.node, opts 'Copy')
  vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts 'Toggle Git Clean')
  vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts 'Prev Git')
  vim.keymap.set('n', ']c', api.node.navigate.git.next, opts 'Next Git')
  vim.keymap.set('n', 'd', api.fs.remove, opts 'Delete')
  vim.keymap.set('n', 'D', api.fs.trash, opts 'Trash')
  vim.keymap.set('n', 'E', api.tree.expand_all, opts 'Expand All')
  vim.keymap.set('n', 'e', api.fs.rename_basename, opts 'Rename: Basename')
  vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts 'Next Diagnostic')
  vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts 'Prev Diagnostic')
  vim.keymap.set('n', 'F', api.live_filter.clear, opts 'Clean Filter')
  vim.keymap.set('n', 'f', api.live_filter.start, opts 'Filter')
  vim.keymap.set('n', 'g?', api.tree.toggle_help, opts 'Help')
  vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts 'Copy Absolute Path')
  vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts 'Toggle Dotfiles')
  vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts 'Toggle Git Ignore')
  vim.keymap.set('n', 'K', api.node.navigate.sibling.last, opts 'Last Sibling')
  vim.keymap.set('n', 'L', api.node.navigate.sibling.first, opts 'First Sibling')
  vim.keymap.set('n', 'm', api.marks.toggle, opts 'Toggle Bookmark')
  vim.keymap.set('n', 'o', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts 'Open: No Window Picker')
  vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')
  vim.keymap.set('n', 'P', api.node.navigate.parent, opts 'Parent Directory')
  vim.keymap.set('n', 'q', api.tree.close, opts 'Close')
  vim.keymap.set('n', 'r', api.fs.rename, opts 'Rename')
  vim.keymap.set('n', 'R', api.tree.reload, opts 'Refresh')
  vim.keymap.set('n', 's', api.node.run.system, opts 'Run System')
  vim.keymap.set('n', 'S', api.tree.search_node, opts 'Search')
  vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts 'Toggle Hidden')
  vim.keymap.set('n', 'W', api.tree.collapse_all, opts 'Collapse')
  vim.keymap.set('n', 'x', api.fs.cut, opts 'Cut')
  vim.keymap.set('n', 'y', api.fs.copy.filename, opts 'Copy Name')
  vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts 'Copy Relative Path')
  vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts 'CD')
end

return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    -- Get VSCode color palette
    local c = require('vscode.colors').get_colors()

    -- Import notes module for pinned files support
    local notes = require('notes')

    -- NvimTree's default decorators plus our custom pinned decorator
    local decorators = {
      'Git',
      'Open',
      'Hidden',
      'Modified',
      'Bookmark',
      'Diagnostics',
      'Copied',
      'Cut',
      notes.create_pinned_decorator(),
    }

    require('nvim-tree').setup {
      on_attach = on_attach,
      actions = {
        open_file = {
          resize_window = true,
        },
      },
      sort = {
        sorter = notes.nvimtree_sorter,
      },
      renderer = {
        decorators = decorators,
        highlight_git = true,
        highlight_opened_files = 'none',
        highlight_modified = 'none', -- Don't highlight executables in any special way
        icons = {
          show = {
            git = false, -- Don't show git icons, we'll use colors instead
            file = true,
            folder = true,
            folder_arrow = true,
          },
          glyphs = {
            git = {
              unstaged = '',
              staged = '',
              unmerged = '',
              renamed = '',
              untracked = '',
              deleted = '',
              ignored = '',
            },
          },
        },
      },
      git = {
        ignore = false,
        show_on_dirs = true, -- Show git status on directories
        show_on_open_dirs = true,
        timeout = 400,
      },
      view = {
        side = 'left',
        width = {
          min = 40,
        },
        relativenumber = true,
      },
    }

    -- Define all the highlight groups
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      callback = function()
        -- Simplified color scheme as requested
        -- Only green (new files), yellow (modified), and dark gray (ignored)

        -- New files are green
        vim.api.nvim_set_hl(0, 'NvimTreeGitNew', { fg = c.vscGreen })
        vim.api.nvim_set_hl(0, 'NvimTreeGitUntracked', { fg = c.vscGreen })

        -- Modified files are yellow (including staged and renamed)
        vim.api.nvim_set_hl(0, 'NvimTreeGitDirty', { fg = c.vscYellow })
        vim.api.nvim_set_hl(0, 'NvimTreeGitStaged', { fg = c.vscYellow })
        vim.api.nvim_set_hl(0, 'NvimTreeGitRenamed', { fg = c.vscYellow })
        vim.api.nvim_set_hl(0, 'NvimTreeGitMerge', { fg = c.vscYellow })

        -- Deleted files use yellow too for consistency
        vim.api.nvim_set_hl(0, 'NvimTreeGitDeleted', { fg = c.vscYellow })

        -- Ignored files are dark gray
        vim.api.nvim_set_hl(0, 'NvimTreeGitIgnored', { fg = c.vscGray })
      end,
      group = vim.api.nvim_create_augroup('NvimTreeHighlight', { clear = true }),
    })

    -- Trigger the autocmd immediately for the current colorscheme
    vim.cmd 'doautocmd ColorScheme'

    -- Open nvimtree by default
    local function open_nvim_tree()
      -- open the tree
      require('nvim-tree.api').tree.open()
      -- Move cursor to the file window only if a file was opened
      local file = vim.fn.expand '%:p'
      if file ~= '' and vim.fn.isdirectory(file) == 0 then
        vim.cmd 'wincmd l'
      end
    end
    vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })

    -- Open current file in nvimtree
    vim.api.nvim_set_keymap('n', '<C-H>', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

    -- Open nvimtree
    vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true })
  end,
}
