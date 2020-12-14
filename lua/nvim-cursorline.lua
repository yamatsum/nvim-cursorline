local M = {}

local disabled = 0
local cursor = 1
local window = 2
local status = disabled
local timer = vim.loop.new_timer()

function M.highlight()
  vim.cmd('highlight CursorWord term=underline cterm=underline gui=underline')
end

function M.matchadd()
  local column = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local cursorword = vim.fn.matchstr(line:sub(1, column + 1), [[\k*$]]) .. vim.fn.matchstr(line:sub(column + 1), [[^\k*]]):sub(2)

  if cursorword == vim.w.cursorword then return end
  vim.w.cursorword = cursorword
  if vim.w.cursorword_match == 1 then vim.call('matchdelete', vim.w.cursorword_id) end
  vim.w.cursorword_match = 0
  if cursorword == '' or #cursorword > 100 then return end
  local pattern = [[\<]] .. cursorword .. [[\>]] 
  vim.w.cursorword_id = vim.fn.matchadd('CursorWord', pattern)
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
		vim.wo.cursorline = false
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
	timer:start(1000, 0, vim.schedule_wrap(function()
		vim.wo.cursorline = true
		status = cursor
	end))
end

return M
