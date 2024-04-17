return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    extensions = {
      'man',
      'toggleterm',
      'quickfix',
      'oil',
      'lazy',
      'fugitive',
      'mason',
    },
    sections = {
      lualine_c = { { 'filename', path = 3 } },
    },
    tabline = {
      lualine_b = { {
        'tabs',
        mode = 2,
        path = 0,
        max_length = 1000,
        tab_max_length = 25,
        tabs_color = {
          active = 'lualine_a_visual',
          inactive = 'lualine_c_normal',
        },
        show_modified_status = false,
        fmt = function(name, context)
          -- Modifier
          local modifier
          local buflist = vim.fn.tabpagebuflist(context.tabnr)
          local winnr = vim.fn.tabpagewinnr(context.tabnr)
          local bufnr = buflist[winnr]
          local modified = vim.fn.getbufvar(bufnr, '&mod') == 1

          -- Icon
          local defaulticon = ''
          local icon = require('nvim-web-devicons').get_icon(name, context.filetype) or defaulticon

          -- Name
          if context.filetype == 'help' then
            name = name:match('^help:(.*)', 1)
          elseif context.filetype == 'harpoon' then
            name = 'harpoon'
          elseif context.filetype == 'backdrop' then
            name = ''
          elseif context.filetype == 'mason' then
            name = 'mason'
          elseif context.filetype == 'lazy' then
            name = 'lazy'
          elseif context.filetype == 'TelescopePrompt' then
            name = 'telescope'
          elseif context.filetype == 'qf' then
            name = 'quickfix'
          elseif name == '[No Name]' then -- unnamed buffer?
            name = '…'
          elseif modified then
            modifier = '∙'
          end

          return (icon or defaulticon) .. ' ' .. name .. (modifier and ' ' .. modifier or '')
        end
      } },
    },
    winbar = {},
  },
  config = function(_, opts)
    local lualine = require('lualine')

    lualine.setup(opts)

    vim.keymap.set('n', '<leader>tl', ':LualineRename ')
    vim.keymap.set('n', '<leader>tr', ':LualineRename<cr>', { silent = true })
  end,
}
