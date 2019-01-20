package.path = package.path .. ';/home/tlarrieu/scripts/?.lua'

require "bindings"

local xrdb = require('xrdb')
local s = require("settings")

s.window.home_page = os.getenv("HOME") .. "/.config/luakit/startpage.html"
s.webview.zoom_level = xrdb.apply_dpi(120, xrdb.load().font.dpi)
s.webview.enable_webgl = true

s.window.search_engines = {
  default = "https://duckduckgo.com/?q=%s",
  g = "https://github.com/%s",
  gh = "https://github.com/search?q=%s",
  h = "https://www.haskell.org/hoogle?hoogle=%s",
  r = "https://reddit.com/r/%s",
  rg = "https://rubygems.org/search?query=%s",
  v = "https://vimawesome.com/?q=%s",
  w = "https://alpha.wallhaven.cc/search?q=%s&categories=111&purity=100&sorting=relevance&order=desc&page=1&atleast=1920x1080",
  wi = "https://en.wikipedia.org/wiki/Special:Search?search=%s",
  yt = "https://www.youtube.com/results?search_query=%s",
}
