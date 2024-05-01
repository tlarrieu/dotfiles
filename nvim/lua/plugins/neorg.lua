return {
  'nvim-neorg/neorg',
  lazy = false,
  dependencies = { 'luarocks.nvim' },
  version = 'v7.0.0',
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
          folds = false,
          icons = {
            heading = {
              icons = { "◉", "◎", "◆", "❖", "○", "◇", "⋄", "⟡" },
            },
            footnote = {
              single = { icon = "" },
              multi_prefix = { icon = " " },
              multi_suffix = { icon = " " },
            },
            todo = {
              done = { icon = "×" },
              pending = { icon = "󰔟" },
              undone = { icon = " " },
              uncertain = { icon = "" },
              on_hold = { icon = "󰏤" },
              cancelled = { icon = "󰩺" },
              recurring = { icon = "↺" },
              urgent = { icon = "" },
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
      ["core.keybinds"] = {
        config = {
          hook = function(keybinds)
            local task_actions = {
              ['<leader>td'] = 'done',    -- task “done”
              ['<leader>tr'] = 'undone',  -- task “reset”
              ['<leader>tp'] = 'on_hold', -- task “pause”
              ['<leader>ts'] = 'pending', -- task “start”
              ['<leader>tc'] = 'cancelled', -- task “cancelled”
              ['gs'] = 'cycle',
              ['gS'] = 'cycle_reverse',
            }
            for key, value in pairs(task_actions) do
              keybinds.remap_event("norg", "n", key, "core.qol.todo_items.todo.task_" .. value)
            end

            keybinds.remap_event("norg", "i", "<c-cr>", "core.itero.next-iteration")
          end
        },
      },
      ["core.highlights"] = {
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
