package.path = package.path .. ';/home/tlarrieu/scripts/?.lua'

require "bindings"

local xrdb = require('xrdb')
local set = require("settings")

set.window.home_page = os.getenv("HOME") .. "/.config/luakit/startpage.html"
set.webview.zoom_level = xrdb.apply_dpi(160, xrdb.load().font.dpi)
set.webview.enable_webgl = true

require("editor").editor_cmd = "kitty nvim {file} +{line} +'set ft=qutebrowser'"

set.window.search_engines = {
  default = "https://duckduckgo.com/?q=%s",
  a = "https://wiki.archlinux.org/index.php/%s",
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

local sel = require("select")
sel.label_maker = function ()
  local chars = charset("auie,ctsrn")
  return trim(sort(reverse(chars)))
end

local follow = require("follow")
follow.pattern_maker = follow.pattern_styles.match_label
follow.stylesheet = [===[
#luakit_select_overlay {
  position: absolute;
  left: 0;
  top: 0;
  z-index: 2147483647; /* Maximum allowable on WebKit */
}

#luakit_select_overlay .hint_overlay {
  display: block;
  position: absolute;
  background-color: #ffff99;
  border: 1px dotted #000;
  opacity: 0.2;
}

#luakit_select_overlay .hint_label {
  display: block;
  position: absolute;
  background-color: #d33682;
  color: #fdf6e3;
  padding: 2px;
  font-size: 12px;
  font-family: Fire Code, monospace, courier, sans-serif;
  opacity: 0.6;
}

#luakit_select_overlay .hint_selected {
  background-color: #00ff00 !important;
}
]===]
