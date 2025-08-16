return {
  'nvim-neorg/neorg',
  version = '*',
  config = true,
  keys = {
    { '<leader>ei', '<cmd>tabnew<cr><cmd>Neorg index<cr>', desc = 'Neorg index' },
    { '<leader>eq', '<cmd>Neorg return<cr>', desc = 'Leave neorg' },
    { '<leader>et', '<cmd>Neorg toc left<cr>', desc = 'Neorg ToC' },
  },
  ft = 'norg',
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
              ['1'] = { prefix = '+@markup.heading.1', title = '+@markup.heading.1' },
              ['2'] = { prefix = '+@markup.heading.2', title = '+@markup.heading.2' },
              ['3'] = { prefix = '+@markup.heading.3', title = '+@markup.heading.3' },
              ['4'] = { prefix = '+@markup.heading.4', title = '+@markup.heading.4' },
              ['5'] = { prefix = '+@markup.heading.5', title = '+@markup.heading.5' },
              ['6'] = { prefix = '+@markup.heading.6', title = '+@markup.heading.6' },
            },
            tags = {
              ranged_verbatim = {
                ['begin'] = '+NeorgCodeBlock',
                ['end'] = '+NeorgCodeBlock',
                ['code_block'] = '+NeorgCodeBlock',
              }
            },
            todo_items = {
              done = '+NeorgDone',
              cancelled = '+NeorgCancelled',
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
