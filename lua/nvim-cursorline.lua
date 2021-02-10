local M = {}

local disabled = 0
local cursor = 1
local window = 2
local status = cursor
local timer = vim.loop.new_timer()

vim.wo.cursorline = true

local function return_highlight_term(group, term)
  local output = vim.api.nvim_exec("highlight " .. group, true)
  return vim.fn.matchstr(output, term .. [[=\zs\S*]])
end

local normal_bg = return_highlight_term("Normal", "guibg")
local cursorline_bg = return_highlight_term("CursorLine", "guibg")

function M.highlight_cursorword()
  vim.cmd("highlight CursorWord term=underline cterm=underline gui=underline")
end

function M.matchadd()
  if vim.fn.hlexists("CursorWord") == 0 then
    return
  end
  local column = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local cursorword =
    vim.fn.matchstr(line:sub(1, column + 1), [[\k*$]]) .. vim.fn.matchstr(line:sub(column + 1), [[^\k*]]):sub(2)

  if cursorword == vim.w.cursorword then
    return
  end
  vim.w.cursorword = cursorword
  if vim.w.cursorword_match == 1 then
    vim.call("matchdelete", vim.w.cursorword_id)
  end
  vim.w.cursorword_match = 0
  if cursorword == "" or #cursorword > 100 then
    return
  end
  local pattern = [[\<]] .. cursorword .. [[\>]]
  vim.w.cursorword_id = vim.fn.matchadd("CursorWord", pattern, -1)
  vim.w.cursorword_match = 1
end

function M.cursor_moved()
  M.matchadd()
  if status == window then
    status = cursor
    return
  end
  M.timer_start()
  if status == cursor then
    -- vim.wo.cursorline = false
    vim.cmd("highlight! CursorLine guibg=" .. normal_bg)
    vim.cmd("highlight! CursorLineNr guibg=" .. normal_bg)
    status = disabled
  end
end

function M.win_enter()
  vim.wo.cursorline = true
  status = window
end

function M.win_leave()
  vim.wo.cursorline = false
  status = window
end

function M.timer_start()
  timer:start(
    1000,
    0,
    vim.schedule_wrap(
      function()
        -- vim.wo.cursorline = true
        vim.cmd("highlight! CursorLine guibg=" .. cursorline_bg)
        vim.cmd("highlight! CursorLineNr guibg=" .. cursorline_bg)
        status = cursor
      end
    )
  )
end

return M
