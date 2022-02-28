local M = {}

local wo = vim.wo
local autocmd = vim.api.nvim_create_autocmd
local timer = vim.loop.new_timer()

local DEFAULT_OPTIONS = {
  cursorline = {
    enable = true,
    timeout = 1000,
  },
}

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", DEFAULT_OPTIONS, options or {})

  if M.options.cursorline.enable then
    wo.cursorline = true
    autocmd({
      event = { "WinEnter" },
      callback = function()
        wo.cursorline = true
      end,
      once = false,
    })
    autocmd({
      event = { "WinLeave" },
      callback = function()
        wo.cursorline = false
      end,
      once = false,
    })
    autocmd({
      event = { "CursorMoved", "CursorMovedI" },
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
      once = false,
    })
  end
end

M.options = nil

return M
