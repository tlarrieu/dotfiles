require "lfs"

require "unique_instance"

-- Set the number of web processes to use. A value of 0 means 'no limit'.
luakit.process_limit = 4

-- Load library of useful functions for luakit
local lousy = require "lousy"

local globals = require "globals"

lousy.theme.init(lousy.util.find_config("theme.lua"))
assert(lousy.theme.get(), "failed to load theme")

local window = require "window"
local webview = require "webview"
local log_chrome = require "log_chrome"

window.add_signal("build", function (w)
    local widgets, l, r = require "lousy.widget", w.sbar.l, w.sbar.r

    -- Left-aligned status bar widgets
    l.layout:pack(widgets.uri())
    l.layout:pack(widgets.hist())
    l.layout:pack(widgets.progress())

    -- Right-aligned status bar widgets
    r.layout:pack(widgets.buf())
    r.layout:pack(log_chrome.widget())
    r.layout:pack(widgets.ssl())
    r.layout:pack(widgets.tabi())
    r.layout:pack(widgets.scroll())
end)

local modes = require "modes"
local binds = require "binds"

----------------------------------
-- Optional user script loading --
----------------------------------

local adblock = require "adblock"
local adblock_chrome = require "adblock_chrome"
local webinspector = require "webinspector"
local formfiller = require "formfiller"
local proxy = require "proxy"
local quickmarks = require "quickmarks"
local session = require "session"
local undoclose = require "undoclose"
local tabhistory = require "tabhistory"
local userscripts = require "userscripts"
local bookmarks = require "bookmarks"
local bookmarks_chrome = require "bookmarks_chrome"

local downloads = require "downloads"
downloads.add_signal("open-file", function (file)
  luakit.spawn(string.format("xdg-open %q", file))
  return true
end)
local downloads_chrome = require "downloads_chrome"

local viewpdf = require "viewpdf"
local follow = require "follow"
local cmdhist = require "cmdhist"
local search = require "search"
local taborder = require "taborder"
local history = require "history"
local history_chrome = require "history_chrome"
local help_chrome = require "help_chrome"
local introspector_chrome = require "introspector_chrome"
local completion = require "completion"

require("editor").editor_cmd = "kitty nvim {file} +{line} +'set ft=qutebrowser'"
local open_editor = require "open_editor"

local follow_selected = require "follow_selected"
local go_input = require "go_input"
local go_next_prev = require "go_next_prev"
local go_up = require "go_up"

require_web_module("referer_control_wm")

local error_page = require "error_page"
local styles = require "styles"
local hide_scrollbars = require "hide_scrollbars"
local domain_props = require "domain_props"
local image_css = require "image_css"
local newtab_chrome = require "newtab_chrome"
local tab_favicons = require "tab_favicons"
local view_source = require "view_source"

-----------------------------
-- End user script loading --
-----------------------------

require "bindings"

-- Restore last saved session
local w = (not luakit.nounique) and (session and session.restore())
if w then
  for i, uri in ipairs(uris) do
    w:new_tab(uri, { switch = i == 1 })
  end
else
  window.new(uris)
end
