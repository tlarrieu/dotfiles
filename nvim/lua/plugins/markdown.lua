return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  -- https://github.com/OXY2DEV/markview.nvim/wiki/Markdown
  opts = {
    preview = {
      enable = false,
      icon_provider = 'devicons',
    },
    markdown_inline = {
      inline_codes = {
        enable = true,
        hl = "MarkviewInlineCode",
        padding_left = '',
        padding_right = ''
      },
    },
    markdown = {
      enable = true,

      code_blocks = {
        enable = true,

        style = 'block',

        label_direction = 'left',

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
    },
  },
}
