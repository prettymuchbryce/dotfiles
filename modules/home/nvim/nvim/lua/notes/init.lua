local api = vim.api
local NOTE_DIR = os.getenv('HOME') .. '/notes'
local NOTE_HOME = NOTE_DIR .. '/README.md'

local template = [[
---
title: %s
date: %s
---

]]

local timestamp_enabled = false

function OpenNotes()
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

function NewNote()
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

function InsertTimestamp()
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
  callback = InsertTimestamp,
})

function ToggleTimestampMode()
  timestamp_enabled = not timestamp_enabled
end

vim.cmd [[
  command! ToggleTimestampMode lua ToggleTimestampMode()
  command! NewNote lua NewNote()
  command! OpenNotes lua OpenNotes()
]]

-- Which-key: +Notes
-- NOTE: Requires which-key to be installed so may fail on first load
require('which-key').add {
  { '<leader>N', group = 'Notes' },
  { '<leader>Nn', '<cmd>NewNote<cr>', desc = 'Create a new note' },
  { '<leader>No', '<cmd>OpenNotes<cr>', desc = 'Open notes' },
  { '<leader>Nt', '<cmd>ToggleTimestampMode<cr>', desc = 'Toggle timestamp mode' },
}
