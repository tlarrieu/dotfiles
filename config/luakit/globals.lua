package.path = package.path .. ';/home/tlarrieu/scripts/?.lua'

local xrdb = require('xrdb')

local globals = {
  homepage            = os.getenv("HOME") .. "/.config/luakit/startpage.html",
  scroll_step         = 40,
  zoom_step           = 0.1,
  max_cmd_history     = 100,
  max_srch_history    = 100,
  default_window_size = "800x600",
  vertical_tab_width  = 200,
  default_zoom_level  = xrdb.apply_dpi(120, xrdb.load().font.dpi),
  term                = "kitty",
}

globals.search_engines = {
  duckduckgo = "https://duckduckgo.com/?q=%s",
  g          = "https://github.com/%s",
  gh         = "https://github.com/search?q=%s",
  h          = "https://www.haskell.org/hoogle?hoogle=%s",
  r          = "https://reddit.com/r/%s",
  rg         = "https://rubygems.org/search?query=%s",
  v          = "https://vimawesome.com/?q=%s",
  w          = "https://alpha.wallhaven.cc/search?q=%s&categories=111&purity=100&sorting=relevance&order=desc&page=1&atleast=1920x1080",
  wi         = "https://en.wikipedia.org/wiki/Special:Search?search=%s",
  yt         = "https://www.youtube.com/results?search_query=%s",
}

globals.search_engines.default = globals.search_engines.duckduckgo

globals.domain_props = {
  ["all"] = { enable_webgl = true, },
}

soup.accept_policy = "no_third_party"
soup.cookies_storage = luakit.data_dir .. "/cookies.db"

return globals
