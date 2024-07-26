return {
  'nvim-neorg/neorg',
  lazy = false,
  version = '*',
  config = true,
  keys = {
    { '<leader>ei', '<cmd>tabnew<cr><cmd>Neorg index<cr>', desc = 'Neorg index' },
    { '<leader>eq', '<cmd>Neorg return<cr>',               desc = 'Leave neorg' },
    { '<leader>et', '<cmd>Neorg toc left<cr>',             desc = 'Neorg ToC' },
  },
  opts = {
    load = {
      ['core.defaults'] = {},
      ['core.summary'] = {},
      ['core.autocommands'] = {},
      ['core.concealer'] = {
        config = {
          folds = true,
          icons = {
            heading = {
              icons = { '◉', '◎', '◆', '❖', '○', '◇', '⋄', '⟡' },
            },
            footnote = {
              single = { icon = '' },
              multi_prefix = { icon = ' ' },
              multi_suffix = { icon = ' ' },
            },
            todo = {
              done = { icon = '×' },
              pending = { icon = '󰔟' },
              undone = { icon = ' ' },
              uncertain = { icon = '' },
              on_hold = { icon = '󰏤' },
              cancelled = { icon = '󰩺' },
              recurring = { icon = '↺' },
              urgent = { icon = '' },
            },
            code_block = {
              width = 'content',
              conceal = false,
            },
          },
        }
      },
      ['core.integrations.treesitter'] = {},
      ['core.qol.todo_items'] = {
        config = {
          order = {
            { 'undone', ' ' },
            { 'pending', '-' },
            { 'done', 'x' }
          },
        }
      },
      ['core.qol.toc'] = { config = { close_after_use = true } },
      ['core.dirman'] = {
        config = {
          workspaces = {
            work = '~/.neorg/work',
            home = '~/.neorg/home',
            gtd = '~/.neorg/gtd',
          },
          default_workspace = 'home'
        }
      },
      ['core.highlights'] = {
        config = {
          dim = {
            tags = {
              ranged_verbatim = {
                code_block = {
                  affect = 'background',
                  percentage = 5,
                },
              }
            },
          },
          highlights = {
            links = {
              description = '+NeorgLinkDescription',
            },
            headings = {
              ['1'] = {
                prefix = '+NeorgHeading1',
                title = '+NeorgHeading1',
              },
              ['4'] = {
                prefix = '+NeorgHeading4',
                title = '+NeorgHeading4',
              },
            },
            todo_items = {
              done = '+NeorgDone',
              on_hold = '+NeorgOnHold',
              undone = '+NeorgUndone',
              pending = '+NeorgPending',
            },
          },
        }
      },
    }
  }
}
