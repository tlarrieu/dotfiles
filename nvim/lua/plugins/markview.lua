return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  priority = 10,
  -- https://github.com/OXY2DEV/markview.nvim/wiki/Markdown
  opts = {
    experimental = {
      check_rtp_message = false,
    },
    preview = {
      enable = true,
      icon_provider = 'devicons',
    },
    markdown_inline = {
      inline_codes = {
        enable = true,
        hl = "MarkviewInlineCode",
        padding_left = '',
        padding_right = '',
      },
    },
    markdown = {
      enable = true,

      code_blocks = {
        enable = true,

        style = 'block',

        label_direction = 'right',
        label_hl = 'MarkviewCodeLabel',

        border_hl = 'MarkviewCode',
        info_hl = 'MarkviewCodeInfo',

        default = {
          block_hl = 'MarkviewCode',
          pad_hl = 'MarkviewCode'
        },

        min_width = 60,
        pad_amount = 1,
        pad_char = ' ',

        sign = false,
      },

      block_quotes = {
        enable = true,
        wrap = true,

        default = {
          border = '┃',
          hl = 'MarkviewBlockQuoteDefault'
        },
      },

      headings = {
        enable = true,

        heading_1 = { style = 'icon', icon = '󰎤 ', hl = 'MarkviewHeading1', sign = '', },
        heading_2 = { style = 'icon', icon = '󰎧 ', hl = 'MarkviewHeading2', sign = '' },
        heading_3 = { style = 'icon', icon = '󰎪 ', hl = 'MarkviewHeading3' },
        heading_4 = { style = 'icon', icon = '󰎭 ', hl = 'MarkviewHeading4' },
        heading_5 = { style = 'icon', icon = '󰎱 ', hl = 'MarkviewHeading5' },
        heading_6 = { style = 'icon', icon = '󰎳 ', hl = 'MarkviewHeading6' },

        setext_1 = {
          style = 'decorated',
          sign = '',
          icon = '  ',
          hl = 'MarkviewHeading1',
          border = '▂'
        },
        setext_2 = {
          style = 'decorated',
          sign = '',
          sign_hl = 'MarkviewHeading2Sign',
          icon = '  ',
          hl = 'MarkviewHeading2',
          border = '▁'
        },

        shift_width = 0,
      },

      list_items = {
        enable = true,
        wrap = true,
        shift_width = 0,

        marker_minus = {
          add_padding = true,
          conceal_on_checkboxes = false,
          text = '◈',
          hl = 'MarkviewListItemMinus'
        },

        marker_plus = {
          add_padding = true,
          conceal_on_checkboxes = false,
          text = '◈',
          hl = 'MarkviewListItemPlus'
        },

        marker_star = {
          add_padding = true,
          conceal_on_checkboxes = false,
          text = '◈',
          hl = 'MarkviewListItemStar'
        },

        marker_dot = {
          add_padding = true,
          conceal_on_checkboxes = true
        },

        marker_parenthesis = {
          add_padding = true,
          conceal_on_checkboxes = true
        }
      },
      horizontal_rules = {
        enable = true,

        parts = {
          {
            type = 'repeating',
            direction = 'left',

            repeat_amount = function(buffer)
              local utils = require('markview.utils');
              local window = utils.buf_getwin(buffer)

              local width = vim.api.nvim_win_get_width(window)
              local textoff = vim.fn.getwininfo(window)[1].textoff;

              return math.floor((width - textoff - 3) / 2);
            end,

            text = '-',

            hl = {
              'MarkviewGradient1', 'MarkviewGradient1',
              'MarkviewGradient2', 'MarkviewGradient2',
              'MarkviewGradient3', 'MarkviewGradient3',
              'MarkviewGradient4', 'MarkviewGradient4',
              'MarkviewGradient5', 'MarkviewGradient5',
              'MarkviewGradient6', 'MarkviewGradient6',
              'MarkviewGradient7', 'MarkviewGradient7',
              'MarkviewGradient8', 'MarkviewGradient8',
              'MarkviewGradient9', 'MarkviewGradient9'
            }
          },
          {
            type = 'text',
            text = '  ',
            hl = 'MarkviewIcon3Fg'
          },
          {
            type = 'repeating',
            direction = 'right',

            repeat_amount = function(buffer)
              local utils = require('markview.utils');
              local window = utils.buf_getwin(buffer)

              local width = vim.api.nvim_win_get_width(window)
              local textoff = vim.fn.getwininfo(window)[1].textoff;

              return math.ceil((width - textoff - 3) / 2);
            end,

            text = '-',
            hl = {
              'MarkviewGradient1', 'MarkviewGradient1',
              'MarkviewGradient2', 'MarkviewGradient2',
              'MarkviewGradient3', 'MarkviewGradient3',
              'MarkviewGradient4', 'MarkviewGradient4',
              'MarkviewGradient5', 'MarkviewGradient5',
              'MarkviewGradient6', 'MarkviewGradient6',
              'MarkviewGradient7', 'MarkviewGradient7',
              'MarkviewGradient8', 'MarkviewGradient8',
              'MarkviewGradient9', 'MarkviewGradient9'
            }
          }
        }
      },
    },
  },
}
