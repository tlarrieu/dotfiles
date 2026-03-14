local docker = ''
local favicon = ''
local git = ''
local ignore = ''
local lock = '󰈡'
local xdefaults = ''

local ruby = ''
local css = '󰐣'
local html = ''
local javascript = ''
local typescript = ''
local react = '󰜈'

return {
  'nvim-tree/nvim-web-devicons',
  opts = {
    default = true,
    color_icons = false,
    override = {
      [''] = { icon = '' }, -- hack for telescope to display folders icon

      help = { icon = '󰭣' },
      man = { icon = '󰭣' },
      qf = { icon = '󰁨' },
      telescope = { icon = '' },
      query = { icon = '' }, -- treesitter tree view
      vim = { icon = '' },
      harpoon = { icon = '󱡁' },
      mason = { icon = '󰺾' },
      lazy = { icon = '󰘧' },
      TelescopePrompt = { icon = '', name = 'telescope' },
      oil = { icon = '' },

      text = { icon = '' },
      txt = { icon = '' },
      log = { icon = '' },
      lock = { icon = lock },
      typst = { icon = '' },
      yaml = { icon = '󰷐' },

      gabc = { icon = '󰽲' },

      todotxt = { icon = '󰃯' },
      ledger = { icon = '󰭣' },

      xf86conf = { icon = xdefaults },
      xdefaults = { icon = xdefaults },
      xresources = { icon = xdefaults },
      xprofile = { icon = xdefaults },
      conf = { icon = '' },
      confini = { icon = '' },
      toml = { icon = '' },
      dir_colors = { icon = '󰌁' },
      dircolors = { icon = '󰌁' },
      desktop = { icon = '󱕷' },

      bashrc = { icon = '󱆃' },
      make = { icon = '󱌣' },
      just = { icon = '' },
      json = { icon = '󰅩' },
      html = { icon = html },
      css = { icon = css },
      scss = { icon = css },
      go = { icon = '󰟓' },
      templ = { icon = html },
      gomod = { icon = '' },
      gosum = { icon = '󰎠' },
      ocaml = { icon = '' },
      dune = { icon = '' },
      markdown = { icon = '' },
      lua = { icon = '󰢱' },
      ruby = { icon = ruby },
      eruby = { icon = html },
      python = { icon = '' },
      cpp = { icon = '' },
      c = { icon = '' },
      haskell = { icon = '󰲒' },
      rust = { icon = '' },
      lisp = { icon = '' },
      java = { icon = '' },
      jar = { icon = '' },
      javascript = { icon = javascript },
      jsx = { icon = react },
      javascriptreact = { icon = react },
      ['javascript.jsx'] = { icon = react },
      ['test.js'] = { icon = javascript },
      ['test.jsx'] = { icon = react },
      ['spec.js'] = { icon = javascript },
      ['spec.jsx'] = { icon = react },
      typescript = { icon = typescript },
      typescriptreact = { icon = typescript },
      ['test.ts'] = { icon = typescript },
      ['test.tsx'] = { icon = react },
      ['spec.ts'] = { icon = typescript },
      ['spec.tsx'] = { icon = react },
      perl = { icon = '' },

      gitcommit = { icon = git },
      gitrebase = { icon = git },
      gitignore = { icon = ignore },
      ['.gitignore'] = { icon = ignore },
      ['.gitconfig'] = { icon = git },
      ['.gitmodules'] = { icon = git },
      ['gitconfig'] = { icon = git },
      ['.gitattributes'] = { icon = git },
      fugitive = { icon = git },
      GV = { icon = git },
      ['gitsigns-blame'] = { icon = git },

      ['vifm-rename'] = { icon = '' },
      zathurarc = { icon = '' },
    },
    override_by_extension = {
      mod = { icon = '' },
      rb = { icon = ruby },
      ru = { icon = ruby },
      erb = { icon = '' },
      jbuilder = { icon = ruby },
      png = { icon = '' },
      jpg = { icon = '' },
      svg = { icon = '' },
      js = { icon = '' },
      md = { icon = '' },
      ml = { icon = '' },
      mli = { icon = '' },
      exe = { icon = '' },
      log = { icon = '' },
      yml = { icon = '󰷐' },
      pl = { icon = '' },

      fish = { icon = '󰈺' },
      kitty = { icon = '󰄛' },
    },
    override_by_filename = {
      ['.keep'] = { icon = '' },

      ['.ignore'] = { icon = '' },
      ['.rgignore'] = { icon = '' },
      ['.fdignore'] = { icon = '' },

      ['dune-project'] = { icon = '' },
      makefile = { icon = '󱌣' },

      ['robots.txt'] = { icon = '󱚝' },
      gemfile = { icon = ruby },
      rake = { icon = '󰣖' },
      rakefile = { icon = '󰣖' },
      ['.irbrc'] = { icon = ruby },
      ['.irbrc.local'] = { icon = ruby },
      ['.pryrc'] = { icon = ruby },
      ['.pryrc.local'] = { icon = ruby },
      ['config.ru'] = { icon = ruby },
      ['routes.rb'] = { icon = '󰑪' },
      ['seeds.rb'] = { icon = '󰹢' },
      ['database.yml'] = { icon = '󱙋' },
      ['.ruby-version'] = { icon = '󰎠' },
      ['.ruby-gemset'] = { icon = '󰹢' },
      ['.rubocop.yml'] = { icon = '' },

      ['go.sum'] = { icon = '󰎠' },
      ['go.mod'] = { icon = '' },

      ['package.json'] = { icon = '' },
      ['package-lock.json'] = { icon = lock },
      ['yarn.lock'] = { icon = lock },
      ['Gemfile.lock'] = { icon = lock },
      ['tailwind.config.js'] = { icon = '󱏿' },

      dockerfile = { icon = docker },
      ['docker-compose.yml'] = { icon = docker },
      ['.dockerignore'] = { icon = docker },

      license = { icon = '󰿃' },
      ['favicon.ico'] = { icon = favicon },
      ['favicon_dev.ico'] = { icon = favicon },
      ['favicon_staging.ico'] = { icon = favicon },
    }
  },
}
