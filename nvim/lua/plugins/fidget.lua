return {
  'j-hui/fidget.nvim',
  opts = {
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
        done_icon = '󰄬 ',
        done_style = '@diff.plus',
        progress_ttl = math.huge,
        progress_icon = {
          pattern = 'moon',
          period = 1,
        },
        progress_style = '@diff.delta',
        group_style = 'FidgetGroup',
        icon_style = '@diff.plus',
        priority = 30,
        skip_history = true,
        format_message = function(msg) require('fidget.progress.display').default_format_message(msg) end,
        format_annote = function(msg) return msg.title .. ' ' end,
        format_group_name = tostring,
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
      configs = {
        default = {
          name = 'message',
          icon = ' ',
          ttl = 10,
          group_style = 'FidgetGroup',
          icon_style = 'FidgetGroup',
          annote_style = 'String',
          debug_style = 'NotifyDEBUGTitle',
          info_style = 'NotifyINFOTitle',
          warn_style = 'NotifyWARNTitle',
          error_style = 'NotifyERRORTitle',
          debug_annote = 'DEBUG',
          info_annote = 'INFO',
          warn_annote = 'WARN',
          error_annote = 'ERROR',
          update_hook = function(item) require('fidget.notification').set_content_key(item) end,
        }
      },

      view = {
        stack_upwards = false,
        icon_separator = ' ',
        group_separator = '─── ',
        group_separator_hl = 'Comment',
      },

      window = {
        normal_hl = 'FidgetFloat',
        border_hl = 'FidgetFloat',
        winblend = 5,
        border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', '' }, -- we add padding to the bottom to compensate the empty line on top
        zindex = 100,
        max_width = 0,
        max_height = 0,
        x_padding = 2,
        y_padding = 1,
        align = 'top',
        relative = 'editor',
      },
    },

    logger = {
      level = vim.log.levels.WARN,
      max_size = 10000,
      float_precision = 0.01,
      path = string.format('%s/fidget.nvim.log', vim.fn.stdpath('cache')),
    },
  },
}
