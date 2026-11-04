vim.pack.add({ 'https://github.com/j-hui/fidget.nvim' }, { confirm = false })

local format_group_name = function(name)
  if name == 'ruby_lsp' then return 'Ruby LSP' end
  if name == 'eslint' then return 'eslint LSP' end
  if name == 'ts_ls' then return 'TypeScript LSP' end
  return name
end

-- [[ System notifications ]] --------------------------------------------------
-- Under X, fidget's window stays closed and everything it receives (messages
-- and LSP progress) goes to the system notifications instead. Fidget still
-- records it all, so its history keeps working.

local in_x = vim.env.DISPLAY ~= nil and vim.fn.executable('notify-send') == 1

-- LSP progress updates replace their notification instead of stacking new
-- ones. As notify-send prints the id to replace asynchronously, updates arriving
-- in the meantime are coalesced into the latest one.
local slots = {} -- progress key => { id, busy, pending }

-- Awesome does not look icon names up in the icon theme: it needs a path
local maybe_icon = function(path) if vim.fn.filereadable(path) == 0 then return nil else return path end end
local icon = maybe_icon('/usr/share/icons/hicolor/128x128/apps/nvim.png')
    or maybe_icon('/usr/local/share/icons/hicolor/128x128/apps/nvim.png')
    or 'nvim'

local send
send = function(key, args, done)
  local slot = key ~= nil and (slots[key] or {}) or nil
  if slot then slots[key] = slot end

  if slot and slot.busy then
    slot.pending = { args = args, done = done }
    return
  end

  local cmd = { 'notify-send', '--app-name=nvim', '--icon=' .. icon, '--print-id' }
  if slot and slot.id then table.insert(cmd, '--replace-id=' .. slot.id) end
  vim.list_extend(cmd, args)

  if slot then slot.busy = true end
  vim.system(cmd, { text = true }, vim.schedule_wrap(function(out)
    if not slot then return end
    slot.id = tonumber(out.stdout) or slot.id
    slot.busy = false

    local pending = slot.pending
    slot.pending = nil
    if pending then
      send(key, pending.args, pending.done)
    elseif done then
      slots[key] = nil -- a later task with the same token gets its own notification
    end
  end))
end

local escape = function(text)
  return (text:gsub('&', '&amp;'):gsub('<', '&lt;'):gsub('>', '&gt;'))
end

local urgencies = {
  [vim.log.levels.ERROR] = 'critical',
  [vim.log.levels.WARN] = 'normal',
}

-- Tap on every notification: mirror it to the system, then let fidget record it
local redirect = function(msg, level, opts)
  opts = opts or {}
  local progress = opts.key ~= nil and type(opts.data) == 'boolean'
  local body = msg or ''
  if progress and opts.annote then
    body = body == '' and opts.annote or ('%s: %s'):format(opts.annote, body)
  end
  if body == '' then return false end

  local summary = progress and format_group_name(opts.group) or opts.title or opts.group or 'Neovim'
  local urgency = urgencies[level] or 'low'
  local args = { '--urgency=' .. urgency }

  if progress then
    -- Done tasks linger as long as in fidget, running ones until their next update
    table.insert(args, '--expire-time=' .. (opts.data and 5000 or 30000))
  elseif urgency ~= 'critical' then
    table.insert(args, '--expire-time=10000') -- errors stay until dismissed
  end

  vim.list_extend(args, { tostring(summary), escape(body) })
  send(progress and (tostring(opts.group) .. ':' .. tostring(opts.key)) or nil, args, progress and opts.data)
  return false
end

require('fidget').setup({
  progress = {
    poll_rate = 0,
    suppress_on_insert = false,
    ignore_done_already = false,
    ignore_empty_message = false,

    clear_on_detach = function(client_id)
      local client = vim.lsp.get_client_by_id(client_id)
      return client and client.name or nil
    end,

    notification_group = function(msg) return msg.lsp_client.name end,
    ignore = {},

    display = {
      render_limit = 16,
      done_ttl = 5,
      done_icon = '',
      done_style = 'FidgetDone',
      progress_ttl = math.huge,
      progress_icon = { pattern = { '', '', '' }, period = 1 },
      progress_style = 'FidgetProgress',
      group_style = 'FidgetGroup',
      icon_style = 'FidgetGroup',
      priority = 30,
      skip_history = true,
      format_group_name = format_group_name,
    },

    lsp = {
      progress_ringbuf_size = 0,
      log_handler = false,
    },
  },

  notification = {
    poll_rate = 10,
    filter = vim.log.levels.TRACE,
    history_size = 128,
    override_vim_notify = true,
    redirect = in_x and redirect or nil,
    configs = {
      default = {
        name = 'messages',
        icon = '󰂞',
        ttl = 10,
        group_style = 'FidgetGroup',
        icon_style = 'FidgetGroup',
        annote_style = 'String',
        debug_style = 'NotifyDEBUGTitle',
        info_style = 'NotifyINFOTitle',
        warn_style = 'NotifyWARNTitle',
        error_style = 'NotifyERRORTitle',
        debug_annote = ' DEBUG',
        info_annote = '󰋽  INFO',
        warn_annote = '  WARN',
        error_annote = ' ERROR',
        update_hook = false, -- do not deduplicate messages
      }
    },

    view = {
      align = 'message',
      reflow = true,
      stack_upwards = false,
      icon_separator = ' ',
      group_separator = '  ',
      group_separator_hl = 'FidgetGroupSeparator',
      render_message = function(msg, cnt) return cnt == 1 and msg or string.format("%s (%dx)", msg, cnt) end,
    },

    window = {
      normal_hl = 'FidgetNormal',
      border_hl = 'FidgetBorder',
      winblend = 0,
      border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', '' },
      zindex = 100,
      max_width = 120,
      max_height = 20,
      x_padding = 0,
      y_padding = 1,
      tabstop = 2,
      align = 'bottom',
      relative = 'editor',
    },
  },

  logger = {
    level = vim.log.levels.WARN,
    max_size = 10000,
    float_precision = 0.01,
    path = string.format('%s/fidget.nvim.log', vim.fn.stdpath('cache')),
  },
})

if in_x then require('fidget.notification').suppress(true) end

vim.keymap.set('n', '<leader>E', '<cmd>Fidget history<cr>g<')
