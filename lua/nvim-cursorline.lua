local M = {}

local w = vim.w
local wo = vim.wo
local fn = vim.fn
local api = vim.api
local hl = api.nvim_set_hl
local autocmd = api.nvim_create_autocmd
local timer = vim.loop.new_timer()

local DEFAULT_OPTIONS = {
  cursorline = {
    enable = true,
    timeout = 1000,
  },
  cursorword = {
    enable = true,
    min_length = 3,
  },
}

local function matchadd()
  local column = api.nvim_win_get_cursor(0)[2]
  local line = api.nvim_get_current_line()
  local cursorword = fn.matchstr(line:sub(1, column + 1), [[\k*$]])
    .. fn.matchstr(line:sub(column + 1), [[^\k*]]):sub(2)

  if cursorword == w.cursorword then
    return
  end
  w.cursorword = cursorword
  if w.cursorword_id then
    vim.call("matchdelete", w.cursorword_id)
    w.cursorword_id = nil
  end
  if
    cursorword == ""
    or #cursorword > 100
    or #cursorword < M.options.cursorword.min_length
    or string.find(cursorword, "[\192-\255]+") ~= nil
  then
    return
  end
  local pattern = [[\<]] .. cursorword .. [[\>]]
  w.cursorword_id = fn.matchadd("CursorWord", pattern, -1)
end

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", DEFAULT_OPTIONS, options or {})

  if M.options.cursorline.enable then
    wo.cursorline = true
    autocmd("WinEnter", {
      callback = function()
        wo.cursorline = true
      end,
    })
    autocmd("WinLeave", {
      callback = function()
        wo.cursorline = false
      end,
    })
    autocmd({ "CursorMoved", "CursorMovedI" }, {
      callback = function()
        wo.cursorlineopt = "number"
        timer:start(
          M.options.cursorline.timeout,
          0,
          vim.schedule_wrap(function()
            wo.cursorlineopt = "both"
          end)
        )
      end,
    })
  end

  if M.options.cursorword.enable then
    autocmd("VimEnter", {
      callback = function()
        hl(0, "CursorWord", { underline = true })
        matchadd()
      end,
    })
    autocmd({ "CursorMoved", "CursorMovedI" }, {
      callback = function()
        matchadd()
      end,
    })
  end
end

M.options = nil

return M
