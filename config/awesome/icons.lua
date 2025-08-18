local _M = {}

local default = '󰣆'

local config = {
  -- 󰊭 office suite
  { icon = '󰊫', rule = { class = 'Chromium', instance = 'www.gmail.com' } },
  {
    icon = '󱎏',
    rules = {
      { class = 'Chromium', name = 'Google Sheets' },
      { class = 'Chromium', instance = 'docs.google.com.*spreadsheets' },
    }
  },
  {
    icon = '󱎐',
    rules = {
      { class = 'Chromium', instance = 'docs.google.com.*slides' },
      { class = 'Chromium', name = 'Google Slides' },
    }
  },
  {
    icon = '󱎒',
    rules = {
      { class = 'Chromium', instance = 'docs.google.com' },
      { class = 'Chromium', name = 'Google Docs' }, }
  },
  {
    icon = '󰋉',
    rules = {
      { class = 'Chromium', instance = 'hangouts.google.com' },
      { class = 'Chromium', instance = 'meet.google.com' },
    }
  },
  {
    icon = '󰃭',
    rules = {
      { class = 'Chromium', instance = 'calendar.google.com' },
      { class = 'Chromium', instance = 'cal.new' }
    }
  },
  { icon = '󰊶', rule = { class = 'Chromium', instance = 'drive.google.com' } },
  { icon = '', rule = { class = 'Chromium', instance = 'groups.google.com' } },

  { icon = '', rule = { class = 'Chromium', name = 'Google Photos' } },
  { icon = '', rule = { class = 'Chromium', instance = 'keep.google.com' } },
  { icon = '', rule = { class = 'Chromium', instance = 'photos.google.com' } },

  --   Work
  { icon = '󰙃', rule = { class = 'Chromium', instance = 'lucca' } },
  { icon = '󰚒', rule = { class = 'Chromium', instance = 'calendly.com' } },
  { icon = '', rule = { class = 'Chromium', instance = 'app.swarmia.com' } },
  { icon = '', rule = { class = 'Chromium', instance = 'app.spendesk.com' } },
  { icon = '', rule = { class = 'Chromium', instance = 'docusign' } },
  { icon = '', rule = { class = 'Chromium', instance = 'slack' } },
  { icon = '󱞠', rule = { class = 'Chromium', instance = 'metroretro.io' } },
  { icon = '󰠮', rule = { class = 'Chromium', instance = 'notion.so' } },
  { icon = '󱙺', rule = { class = 'Chromium', instance = 'dust.tt' } },
  { icon = '', rule = { class = 'Chromium', instance = 'linear.app' } },
  { icon = '󰨰', rule = { class = 'Chromium', instance = 'sentry.io' } },
  { icon = '', rule = { class = 'Chromium', instance = 'figma.com' } },
  { icon = '󱘶', rule = { class = 'Chromium', instance = 'metabase' } },
  { icon = '󱤢', rule = { class = 'Chromium', instance = 'dalibo' } },
  {
    icon = '󰡴',
    rules = {
      { class = 'Chromium', instance = 'datadoghq.com' },
      { class = 'Chromium', name = 'Datadog' }
    }
  },
  { icon = '', rule = { class = '1Password' } },
  { icon = '󰳴', rule = { class = 'Chromium', instance = 'app.pennylane.com' } },

  --  Videos
  { icon = '', rule = { class = 'Chromium', instance = 'www.twitch.tv' } },
  { icon = '', rule = { class = 'Chromium', name = 'YouTube' } },

  --  Social
  { icon = '', rule = { class = 'Chromium', instance = 'www.gettr.com' } },
  { icon = '', rule = { class = 'Chromium', instance = 'www.twitter.com' } },
  { icon = '', rule = { class = 'Chromium', name = 'Twitter' } },
  { icon = '', rule = { class = 'Chromium', instance = 'reddit.com' } },
  { icon = '', rule = { class = 'Chromium', instance = 'linkedin.com' } },

  -- 󰔬 Travel
  { icon = '󰔬', rule = { class = 'Chromium', instance = 'trainline' } },
  { icon = '', rule = { class = 'Chromium', instance = 'citymapper.com' } },
  {
    icon = '',
    rules = {
      { class = 'Chromium', instance = 'maps.google.com' },
      { class = 'Chromium', instance = 'google.com__maps' },
    }
  },

  --  Programming
  { icon = '󱘫', rule = { class = 'postgres' } },
  { icon = '', rule = { class = 'Chromium', instance = 'rubygems' } },
  { icon = '', rule = { class = 'Chromium', instance = 'hoogle' } },
  {
    icon = '',
    rules = {
      { class = 'Chromium', instance = 'github.com', name = '/issues' },
      { class = 'Chromium', instance = 'github.com.*projects' }
    },
  },
  { icon = '', rule = { class = 'Chromium', instance = 'github.com' } },
  { icon = '', rule = { class = 'Chromium', instance = 'fly.io' } },
  { icon = '', rule = { class = 'Chromium', instance = 'www.nerdfonts.com' } },
  { icon = '', rule = { class = 'Chromium', instance = 'www.flaticon.com' } },

  --  Drawing
  { icon = '', rule = { class = 'Chromium', instance = 'whimsical.co' } },
  { icon = '', rule = { class = 'Chromium', instance = 'app.diagrams.net' } },
  { icon = '', rule = { class = 'Chromium', instance = 'www.excalidraw.com' } },

  -- Training
  { icon = '', rule = { class = 'Chromium', instance = 'tryhackme.com' } },
  { icon = '', rule = { class = 'Chromium', instance = 'www.exercism.io' } },
  { icon = '', rule = { class = 'Chromium', instance = 'app.envoituresimone.com' } },

  --  Money
  { icon = '', rule = { class = 'Chromium', name = ', espace client,' } },
  { icon = '󰆭', rule = { class = 'Chromium', instance = 'boursedirect' } },
  { icon = '', rule = { class = 'Chromium', instance = 'paypal' } },
  { icon = '󰯝', rule = { class = 'Chromium', instance = 'swile' } },
  { icon = '󰗑', rule = { class = 'accounting' } },

  --  Pictures
  { icon = '', rule = { class = 'Chromium', instance = 'pinterest.com' } },
  { icon = '', rule = { class = 'Chromium', instance = 'wallhaven.cc' } },
  { icon = '󰥶', rule = { class = 'feh' } },
  { icon = '󰹑', rule = { class = 'screenshot' } },

  --  Coms
  { icon = '', rule = { class = 'Chromium', instance = 'web.whatsapp.com' } },
  { icon = '󰙯', rule = { class = 'Chromium', instance = 'discord.com' } },

  -- 󰉚 Food
  { icon = '', rule = { class = 'Chromium', instance = 'www.deliveroo.fr' } },
  { icon = '', rule = { class = 'Chromium', instance = 'ubereats.com' } },

  -- 󰞇 RPG
  { icon = '󰨁', rule = { class = 'Chromium', instance = 'watabou.itch.io' } },
  { icon = '󰴹', rule = { class = 'Chromium', instance = 'rolladvantage.com' } },
  { icon = '󰺿', rule = { class = 'Chromium', instance = 'app.legendkeeper.com' } },
  { icon = '󱅕', rule = { class = 'Chromium', instance = 'roll20.net' } },

  --  Shopping
  { icon = '', rule = { class = 'Chromium', instance = 'amazon' } },
  { icon = '󰨈', rule = { class = 'Chromium', instance = 'pratebay' } },

  --  Misc
  { icon = '󰓙', rule = { class = 'Chromium', instance = 'doctolib' } },
  { icon = '󰚗', rule = { class = 'Chromium', instance = 'malt' } },
  { icon = '󱌣', rule = { class = 'Chromium', instance = 'yoojo' } },
  { icon = '', rule = { class = 'Chromium', instance = 'monkeytype.com', } },

  --  Default browser
  { icon = '󰖟', rule = { class = 'Chromium', instance = 'localhost' } },
  { icon = '󰊯', rule = { class = 'Chromium', name = 'DevTool' } },
  { icon = '', rule = { class = 'Chromium' } },

  --  Games
  { icon = '󰓥', rule = { class = 'steam_app_1086940' } }, -- Baldur's gate III
  { icon = '󰸓', rule = { class = 'Backpack Battles' } },
  { icon = '', rule = { class = 'Wine' } },
  { icon = '', rule = { class = 'steam' } },
  { icon = '', rule = { class = 'Cockatrice' } },

  { icon = '', rule = { class = 'Gpick' } },
  { icon = '', rule = { class = 'man' } },
  { icon = '', rule = { class = 'dungeondraft.exe' } },
  { icon = '', rule = { class = 'Nemo' } },
  { icon = '', rule = { class = 'config' } },
  { icon = '', rule = { class = 'work' } },
  { icon = '', rule = { class = 'firefox' } },
  { icon = '', rule = { class = 'Lxappearance' } },
  { icon = '', rule = { class = 'Mainwindow.py' } }, --[[ PlayOnLinux ]]
  { icon = '', rule = { name = 'yay' } },
  { icon = '', rule = { class = 'Seahorse' } },
  { icon = '', rule = { class = 'Signal' } },
  { icon = '', rule = { class = 'wiki' } },
  { icon = '󰢨', rule = { class = 'gtd' } },
  { icon = '', rule = { class = 'Luakit' } },
  { icon = '', rule = { class = 'nyxt' } },
  { icon = '', rule = { class = 'Gimp' } },
  { icon = '', rule = { name = 'aria2c' } },
  { icon = '', rule = { class = 'download' } },
  { icon = '', rule = { class = 'Zathura' } },
  { icon = '󰤽', rule = { class = 'Flowblade' } },
  { icon = '', rule = { class = 'gtgf' } },
  { icon = '󰙯', rule = { class = 'discord' } },
  { icon = '', rule = { class = 'help' } },
  { icon = '', rule = { class = 'Sxiv' } },
  { icon = '', rule = { class = 'Viewnior' } },
  { icon = '󱊄', rule = { class = 'Dungeondraft' } },
  { icon = '', rule = { class = 'Godot' } },
  { icon = '', rule = { class = 'Xephyr' } },
  { icon = '󱜏', rule = { class = 'mpv' } },
  { icon = '', rule = { class = 'Audacity' } },
  { icon = '󰆒', rule = { class = 'scratchpad' } },
  { icon = '󰕼', rules = { { class = 'Vlc' }, { class = 'vlc' } } },
  { icon = '󰖀', rule = { class = 'mixer' } },
  { icon = 'ﮩ', rule = { name = 'Document Scanner' } },
  { icon = '', rule = { name = 'pass: ' } },
  { icon = '󰇅', rule = { class = 'VirtualBox Manager' } },
  { icon = '󰍛', rule = { class = 'VirtualBox Machine' } },

  { icon = '󰫏', rule = { class = 'kitty', name = 'rails' } },
  { icon = '', rule = { class = 'kitty', name = 'sidekiq' } },
  { icon = '', rule = { class = 'kitty', name = 'yarn' } },
  { icon = '', rule = { class = 'kitty', name = 'redis%-server' } },
  { icon = '', rule = { class = 'kitty', name = 'dotfiles' } },
  { icon = '', rule = { class = 'kitty', name = 'exercism' } },
  { icon = '', rule = { class = 'kitty', name = 'Nvim' } },
  {
    icon = '',
    rules = {
      { class = 'newsboat' },
      { class = 'kitty', name = 'newsboat' },
      { class = 'quake', name = 'newsboat' } }
  },
  { icon = '', rule = { class = 'kitty', name = 'htop' } },
  { icon = '', rule = { class = 'kitty', name = 'vifm' } },
  { icon = '', rule = { class = 'kitty', name = 'vpn' } },
  { icon = '󰆍', rule = { class = 'kitty' } },
  { icon = '', rule = { class = 'quake' } },
}

local match = function(client, rule)
  return (not rule.name or (client.name or ''):find(rule.name)) and
      (not rule.instance or (client.instance or ''):find(rule.instance)) and
      (not rule.class or (client.class or ''):find(rule.class))
end

_M.fetch = function(client)
  for i = 1, #config do
    local icon = config[i].icon

    if config[i].rules then
      for j = 1, #config[i].rules do
        if match(client, config[i].rules[j]) then return icon end
      end
    else
      if match(client, config[i].rule) then return icon end
    end
  end

  return default
end

return _M
