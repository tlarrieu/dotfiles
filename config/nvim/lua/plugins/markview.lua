local ruler_repeat_amount = function(buf)
  local window = require('markview.utils').buf_getwin(buf)

  local width = vim.api.nvim_win_get_width(window)
  local textoff = vim.fn.getwininfo(window)[1].textoff;

  return math.floor((width - textoff - 3) / 2);
end

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
        padding_left = ' ',
        padding_right = ' ',
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
        enable         = true,
        wrap           = true,
        default        = { border = '┃', hl = 'MarkviewBlockQuoteDefault' },
        ["ABSTRACT"]   = { icon = "󱉫", preview = "󱉫 Abstract", hl = "MarkviewBlockQuoteNote" },
        ["SUMMARY"]    = { icon = "󱉫", preview = "󱉫 Summary", hl = "MarkviewBlockQuoteNote" },
        ["TLDR"]       = { icon = "󱉫", preview = "󱉫 tl;dr", hl = "MarkviewBlockQuoteNote" },
        ["TODO"]       = { icon = "", preview = " Todo", hl = "MarkviewBlockQuoteNote" },
        ["INFO"]       = { icon = "󰋼", preview = "󰋼 Info", hl = "MarkviewBlockQuoteNote" },
        ["SUCCESS"]    = { icon = "󰗠", preview = "󰗠 Success", hl = "MarkviewBlockQuoteOk" },
        ["CHECK"]      = { icon = "󰗠", preview = "󰗠 Check", hl = "MarkviewBlockQuoteOk" },
        ["DONE"]       = { icon = "󰗠", preview = "󰗠 Done", hl = "MarkviewBlockQuoteOk" },
        ["QUESTION"]   = { icon = "󰋗", preview = "󰋗 Question", hl = "MarkviewBlockQuoteWarn" },
        ["HELP"]       = { icon = "󰋗", preview = "󰋗 Help", hl = "MarkviewBlockQuoteWarn" },
        ["FAQ"]        = { icon = "󰋗", preview = "󰋗 Faq", hl = "MarkviewBlockQuoteWarn" },
        ["FAILURE"]    = { icon = "󰅙", preview = "󰅙 Failure", hl = "MarkviewBlockQuoteError" },
        ["FAIL"]       = { icon = "󰅙", preview = "󰅙 Fail", hl = "MarkviewBlockQuoteError" },
        ["MISSING"]    = { icon = "󰅙", preview = "󰅙 Missing", hl = "MarkviewBlockQuoteError" },
        ["DANGER"]     = { icon = "", preview = " Danger", hl = "MarkviewBlockQuoteError" },
        ["ERROR"]      = { icon = "", preview = " Error", hl = "MarkviewBlockQuoteError" },
        ["BUG"]        = { icon = "", preview = " Bug", hl = "MarkviewBlockQuoteError" },
        ["EXAMPLE"]    = { icon = "", preview = " Example", hl = "MarkviewBlockQuoteSpecial" },
        ["QUOTE"]      = { icon = "", preview = " Quote", hl = "MarkviewBlockQuoteDefault" },
        ["CITE"]       = { icon = "", preview = " Cite", hl = "MarkviewBlockQuoteDefault" },
        ["HINT"]       = { icon = "", preview = " Hint", hl = "MarkviewBlockQuoteOk" },
        ["TIP"]        = { icon = "", preview = " Tip", hl = "MarkviewBlockQuoteOk" },
        ["ATTENTION"]  = { icon = "", preview = " Attention", hl = "MarkviewBlockQuoteWarn" },
        ["NOTE"]       = { icon = "󰋼", preview = "󰋼 Note", hl = "MarkviewBlockQuoteNote" },
        ["IMPORTANT"]  = { icon = "󰅽", preview = "󰅽 Important", hl = "MarkviewBlockQuoteSpecial" },
        ["WARNING"]    = { icon = "", preview = " Warning", hl = "MarkviewBlockQuoteWarn" },
        ["CAUTION"]    = { icon = "󰒡", preview = "󰒡 Caution", hl = "MarkviewBlockQuoteError" },

        ["DEFINITION"] = { icon = "", preview = " Def.", hl = "MarkviewBlockQuoteOk", title = false },
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
          text = '',
          hl = 'MarkviewListItemMinus'
        },
        marker_star = {
          add_padding = true,
          conceal_on_checkboxes = false,
          text = '◈',
          hl = 'MarkviewListItemStar'
        },
        marker_plus = {
          add_padding = true,
          conceal_on_checkboxes = false,
          text = '◇',
          hl = 'MarkviewListItemPlus'
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
            repeat_amount = ruler_repeat_amount,
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
            repeat_amount = ruler_repeat_amount,
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
  init = function()
    vim.keymap.set('n', '<leader><tab>', '<cmd>Markview toggle<cr>')
  end
}
