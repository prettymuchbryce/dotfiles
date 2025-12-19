local api = vim.api
local M = {}

local NOTE_DIR = os.getenv('HOME') .. '/notes'
local NOTE_HOME = NOTE_DIR .. '/README.md'

local template = [[
---
title: %s
date: %s
---

]]

local timestamp_enabled = false

function M.open_notes()
  -- Change directory to notes
  vim.cmd('cd ' .. NOTE_DIR)

  -- Open file in buffer
  vim.cmd('edit ' .. vim.fn.fnameescape(NOTE_HOME))

  -- Open nvimtree
  vim.cmd 'NvimTreeOpen'

  -- Select the file buffer (NvimTreeOpen changes the current window)
  local tabpage = api.nvim_get_current_tabpage()
  local win_ids = api.nvim_tabpage_list_wins(tabpage)
  for _, id in ipairs(win_ids) do
    if NOTE_HOME == api.nvim_buf_get_name(api.nvim_win_get_buf(id)) then
      -- if mode == "preview" then return end
      api.nvim_set_current_win(id)
      break
    end
  end
end

function M.new_note()
  local name = vim.fn.input 'Note Name: '
  if name == '' then
    return
  end
  -- Sanitize: remove characters invalid in filenames
  name = name:gsub('[/\\:*?"<>|]', '-')
  local current_date = os.date '%Y-%m-%d'
  local filename = string.format('%s/%s-%s.md', NOTE_DIR, current_date, name)
  local hydrated_template = string.format(template, name, current_date)
  local file = io.open(filename, 'w')
  if not file then
    vim.notify('Error: Could not create note at ' .. filename, vim.log.levels.ERROR)
    return
  end
  file:write(hydrated_template)
  file:close()

  -- Change directory to notes
  vim.cmd('cd ' .. NOTE_DIR)

  -- Open file in buffer
  vim.cmd('edit ' .. vim.fn.fnameescape(filename))

  -- Open nvimtree
  vim.cmd 'NvimTreeOpen'

  -- Select the file buffer (NvimTreeOpen changes the current window)
  local tabpage = api.nvim_get_current_tabpage()
  local win_ids = api.nvim_tabpage_list_wins(tabpage)
  for _, id in ipairs(win_ids) do
    if filename == api.nvim_buf_get_name(api.nvim_win_get_buf(id)) then
      -- if mode == "preview" then return end
      api.nvim_set_current_win(id)
      break
    end
  end

  -- Go to end of file
  vim.cmd '$'

  -- Insert mode
  vim.cmd 'startinsert'
end

function M.insert_timestamp()
  if timestamp_enabled and api.nvim_get_mode().mode == 'i' then
    local current_line = api.nvim_get_current_line()
    -- Check length of current line
    if #current_line == 1 then
      local timestamp = tostring(os.date '%I:%M %p')

      -- Move cursor to beginning of line
      vim.cmd 'normal! 0'

      -- Insert timestamp at the begining of the line and move cursor to end of the line
      api.nvim_put({ timestamp }, 'c', false, true)

      -- Insert a separator in the form " – "
      api.nvim_put({ ' – ' }, 'c', false, true)

      -- Start inserting at the very end of the current line using `nvim_call_function` with 'cursor'
      local cursor_pos = api.nvim_win_get_cursor(0)
      local line = cursor_pos[1]
      local col = cursor_pos[2]
      api.nvim_win_set_cursor(0, { line, col + 2 })
    end
  end
end

vim.api.nvim_create_autocmd('CursorMovedI', {
  group = vim.api.nvim_create_augroup('timestamp', { clear = true }),
  pattern = '*',
  callback = M.insert_timestamp,
})

function M.toggle_timestamp_mode()
  timestamp_enabled = not timestamp_enabled
end

function M.toggle_pin()
  local lines = api.nvim_buf_get_lines(0, 0, -1, false)

  -- Check if file has frontmatter
  if lines[1] ~= '---' then
    vim.notify('No frontmatter found', vim.log.levels.WARN)
    return
  end

  -- Find end of frontmatter and check for pinned
  local frontmatter_end = nil
  local pinned_line = nil
  for i = 2, #lines do
    if lines[i] == '---' then
      frontmatter_end = i
      break
    end
    if lines[i]:match('^pinned:%s*true') then
      pinned_line = i
    end
  end

  if not frontmatter_end then
    vim.notify('Invalid frontmatter', vim.log.levels.WARN)
    return
  end

  if pinned_line then
    -- Remove the pinned line
    api.nvim_buf_set_lines(0, pinned_line - 1, pinned_line, false, {})
    vim.notify('Unpinned', vim.log.levels.INFO)
  else
    -- Add pinned: true before the closing ---
    api.nvim_buf_set_lines(0, frontmatter_end - 1, frontmatter_end - 1, false, { 'pinned: true' })
    vim.notify('Pinned', vim.log.levels.INFO)
  end
end

-- Frontmatter utilities
local function is_pinned(filepath)
  local file = io.open(filepath, 'r')
  if not file then return false end

  local first_line = file:read('*l')
  if first_line ~= '---' then
    file:close()
    return false
  end

  for line in file:lines() do
    if line == '---' then break end
    if line:match('^pinned:%s*true') then
      file:close()
      return true
    end
  end

  file:close()
  return false
end

-- Custom sorter for NvimTree (only applies in notes directory)
local function nvimtree_sorter(nodes)
  local cwd = vim.fn.getcwd()
  local in_notes = cwd == NOTE_DIR or cwd:find(NOTE_DIR, 1, true) == 1

  table.sort(nodes, function(a, b)
    if in_notes then
      -- Notes sorting: pinned first, then newest first, no folder grouping
      local a_pinned = a.name:match('%.md$') and is_pinned(a.absolute_path)
      local b_pinned = b.name:match('%.md$') and is_pinned(b.absolute_path)

      if a_pinned and not b_pinned then return true end
      if b_pinned and not a_pinned then return false end

      return a.name:lower() > b.name:lower()
    else
      -- Default sorting: folders first, then alphabetical ascending
      if a.type ~= b.type then
        return a.type == 'directory'
      end
      return a.name:lower() < b.name:lower()
    end
  end)
end

-- Custom decorator for NvimTree (pin icon + highlight)
local function create_pinned_decorator()
  local UserDecorator = require('nvim-tree.renderer.decorator.user')
  local PinnedDecorator = UserDecorator:extend()

  function PinnedDecorator:new(args)
    args = args or {}
    PinnedDecorator.super.new(self, args)
    self.explorer = args.explorer
    self.enabled = true
    self.highlight_range = 'all'
    self.icon_placement = 'before'
    self.icon = { str = '📌', hl = { 'NvimTreePinnedIcon' } }
    if self.define_sign then
      self:define_sign(self.icon)
    end
  end

  function PinnedDecorator:icons(node)
    if node.name:match('%.md$') and is_pinned(node.absolute_path) then
      return { self.icon }
    end
  end

  function PinnedDecorator:highlight_group(node)
    if node.name:match('%.md$') and is_pinned(node.absolute_path) then
      return 'NvimTreePinnedHL'
    end
  end

  return PinnedDecorator
end

-- Set up highlight groups for pinned notes
vim.api.nvim_set_hl(0, 'NvimTreePinnedHL', { fg = '#FFD700' })
vim.api.nvim_set_hl(0, 'NvimTreePinnedIcon', { fg = '#FFD700' })

vim.cmd [[
  command! ToggleTimestampMode lua require('notes').toggle_timestamp_mode()
  command! TogglePin lua require('notes').toggle_pin()
  command! NewNote lua require('notes').new_note()
  command! OpenNotes lua require('notes').open_notes()
]]

-- Which-key: +Notes
-- NOTE: Requires which-key to be installed so may fail on first load
require('which-key').add {
  { '<leader>N', group = 'Notes' },
  { '<leader>Nn', '<cmd>NewNote<cr>', desc = 'Create a new note' },
  { '<leader>No', '<cmd>OpenNotes<cr>', desc = 'Open notes' },
  { '<leader>Np', '<cmd>TogglePin<cr>', desc = 'Toggle pin' },
  { '<leader>Nt', '<cmd>ToggleTimestampMode<cr>', desc = 'Toggle timestamp mode' },
}

-- Export module
M.nvimtree_sorter = nvimtree_sorter
M.create_pinned_decorator = create_pinned_decorator

return M
