local M = {}

local w = vim.w
local a = vim.api
local wo = vim.wo
local fn = vim.fn
local hl = a.nvim_set_hl
local au = a.nvim_create_autocmd
local timer = vim.loop.new_timer()

local DEFAULT_OPTIONS = {
  cursorline = {
    enable = true,
    timeout = 1000,
    number = false,
    disable_filetypes = {
      'neo-tree'
    },
  },
  cursorword = {
    enable = true,
    min_length = 3,
    hl = { underline = true },
  },
}

local function matchadd()
  local column = a.nvim_win_get_cursor(0)[2]
  local line = a.nvim_get_current_line()
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

  local disabled_filetype_lookup = {}
  for _, ft in ipairs(M.options.cursorline.disable_filetypes) do
    disabled_filetype_lookup[ft] = true
  end

  if M.options.cursorline.enable then
    wo.cursorline = true
    au("WinEnter", {
      callback = function()
        wo.cursorline = true
      end,
    })
    au("WinLeave", {
      callback = function()
        wo.cursorline = false
      end,
    })
    au({ "CursorMoved", "CursorMovedI" }, {
      callback = function()
        if disabled_filetype_lookup[vim.bo.filetype] then
          vim.wo.cursorline = true
          return
        end
        if M.options.cursorline.number then
          wo.cursorline = false
        else
          wo.cursorlineopt = "number"
        end
        timer:start(
          M.options.cursorline.timeout,
          0,
          vim.schedule_wrap(function()
            if M.options.cursorline.number then
              wo.cursorline = true
            else
              wo.cursorlineopt = "both"
            end
          end)
        )
      end,
    })
  end

  if M.options.cursorword.enable then
    au("VimEnter", {
      callback = function()
        hl(0, "CursorWord", M.options.cursorword.hl)
        matchadd()
      end,
    })
    au({ "CursorMoved", "CursorMovedI" }, {
      callback = function()
        matchadd()
      end,
    })
  end
end

M.options = nil

return M
