local M = {}

local DISABLED = 0
local CURSOR = 1
local WINDOW = 2
local status = CURSOR
local timer = vim.loop.new_timer()

local w = vim.w
local wo = vim.wo
local g = vim.g
local fn = vim.fn
local api = vim.api

local function return_highlight_term(group, term)
  local output = api.nvim_exec("highlight " .. group, true)
  local hi = fn.matchstr(output, term .. [[=\zs\S*]])
  if hi == nil or hi == "" then
    return "None"
  else
    return hi
  end
end

local function to_table(x)
  if type(x) == "nil" then
    return {}
  elseif type(x) == "table" then
    return x
  end

  return { x }
end

local function table_contains(t, x)
  for _, v in pairs(t) do
    if v == x then
      return true
    end
  end
  return false
end

local cursorline_timeout = g.cursorline_timeout and g.cursorline_timeout or 1000

local normal_bg = return_highlight_term("Normal", "guibg")
local cursorline_bg = return_highlight_term("CursorLine", "guibg")

local cursorword_disabled_filetypes = to_table(g.cursorword_disabled_filetypes)
local cursorword_disabled_buftypes = to_table(g.cursorword_disabled_buftypes)
local cursorline_disabled_filetypes = to_table(g.cursorline_disabled_filetypes)
local cursorline_disabled_buftypes = to_table(g.cursorline_disabled_buftypes)

local function should_disable_cursorword_on_buffer()
  return table_contains(cursorword_disabled_filetypes, vim.bo.filetype)
    or table_contains(cursorword_disabled_buftypes, vim.bo.buftype)
end

local function should_disable_cursorline_on_buffer()
  return table_contains(cursorline_disabled_filetypes, vim.bo.filetype)
    or table_contains(cursorline_disabled_buftypes, vim.bo.buftype)
end

local function set_cursorline()
  if g.cursorline_highlight ~= false and not should_disable_cursorline_on_buffer() then
    wo.cursorline = true
  end
end

local function disable_cursorline()
  vim.cmd("highlight! CursorLine guibg=" .. normal_bg)
  vim.cmd("highlight! CursorLineNr guibg=" .. normal_bg)
  status = DISABLED
end

local function enable_cursorline()
  vim.cmd("highlight! CursorLine guibg=" .. cursorline_bg)
  vim.cmd("highlight! CursorLineNr guibg=" .. cursorline_bg)
  status = CURSOR
end

function M.vim_enter()
  if g.cursorword_highlight ~= false then
    vim.cmd("highlight CursorWord term=underline cterm=underline gui=underline")
  end
  if g.cursorline_highlight == false then
    disable_cursorline()
  end
end

function M.matchadd()
  if fn.hlexists("CursorWord") == 0 then
    return
  end
  local column = api.nvim_win_get_cursor(0)[2]
  local line = api.nvim_get_current_line()
  local cursorword = fn.matchstr(line:sub(1, column + 1), [[\k*$]])
    .. fn.matchstr(line:sub(column + 1), [[^\k*]]):sub(2)

  if cursorword == w.cursorword then
    return
  end
  w.cursorword = cursorword
  if w.cursorword_match == 1 then
    vim.call("matchdelete", w.cursorword_id)
  end
  w.cursorword_match = 0
  if cursorword == "" or #cursorword > 100 or #cursorword < 3 or string.find(cursorword, "[\192-\255]+") ~= nil then
    return
  end
  local pattern = [[\<]] .. cursorword .. [[\>]]
  w.cursorword_id = fn.matchadd("CursorWord", pattern, -1)
  w.cursorword_match = 1
end

function M.cursor_moved()
  if g.cursorword_highlight ~= false and not should_disable_cursorword_on_buffer() then
    M.matchadd()
  end
  if status == WINDOW then
    status = CURSOR
    return
  end
  if g.cursorline_highlight ~= false and not should_disable_cursorline_on_buffer() then
    M.timer_start()
    if status == CURSOR and cursorline_timeout ~= 0 then
      disable_cursorline()
    end
  end
end

function M.buf_enter()
  set_cursorline()
  status = WINDOW
end

function M.buf_leave()
  wo.cursorline = false
  status = WINDOW
end

function M.timer_start()
  timer:start(cursorline_timeout, 0, vim.schedule_wrap(enable_cursorline))
end

return M
