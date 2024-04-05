local _M = {}

function _M:_initialize()
  if self.initialized then return end

  self.initialized = true

  self.opts = {
    transparency = 60,
    zindex = 1
  }
end

function _M:hook()
  _M:show()

  vim.api.nvim_create_autocmd('BufLeave', {
    buffer = vim.api.nvim_get_current_buf(),
    callback = function()
      _M:hide()
    end,
    group = vim.api.nvim_create_augroup('backdrop_autocmd', {})
  })
end

--- @param opts? {transparency?: integer, zindex?: integer}
function _M:setup(opts)
  self:_initialize()

  self.opts = vim.tbl_deep_extend("force", self.opts, opts or {})

  return self
end

--- @param opts? {transparency?: integer, zindex?: integer}
function _M:show(opts)
  self:_initialize()

  vim.api.nvim_exec_autocmds("User", { pattern = "BackdropVisible" })

  if self.backdrop_win then return self end

  opts = vim.tbl_deep_extend("keep", opts or {}, self.opts)

  local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
  local has_bg = normal and normal.bg ~= nil

  if has_bg and opts.transparency and opts.transparency < 100 and vim.o.termguicolors then
    local backdrop_buf = vim.api.nvim_create_buf(false, true)
    local backdrop_win = vim.api.nvim_open_win(backdrop_buf, false, {
      relative = "editor",
      width = vim.o.columns,
      height = vim.o.lines,
      row = 0,
      col = 0,
      style = "minimal",
      focusable = false,
      zindex = opts.zindex,
    })
    vim.api.nvim_set_hl(0, "LazyBackdrop", { bg = "#000000", default = true })
    vim.api.nvim_set_option_value("winhighlight", "Normal:LazyBackdrop", { scope = "local", win = backdrop_win })
    vim.api.nvim_set_option_value("winblend", opts.transparency, { scope = "local", win = backdrop_win })
    vim.bo[backdrop_buf].buftype = "nofile"
    vim.bo[backdrop_buf].filetype = "backdrop"

    self.backdrop_win = backdrop_win
  end

  return self
end

function _M:hide()
  if self.backdrop_win then
    vim.api.nvim_win_hide(self.backdrop_win)
    self.backdrop_win = nil
  end

  vim.api.nvim_exec_autocmds("User", { pattern = "BackdropHidden" })

  return self
end

return _M
