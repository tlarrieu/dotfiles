local modes = require("modes")
local luakit = require("luakit")

modes.remove_binds(
  "normal",
  {
    "y",
    "<Control-w>",
  }
)

modes.add_binds("completion", {
  {
    "<Escape>",
    "Return to `normal` mode.",
    function (w) w:set_prompt(); w:set_mode() end
  },
})

local script = function(name)
  return function(uri)
    local command = "/bin/sh %s/scripts/%s '%s'"
    luakit.spawn(string.format(command, os.getenv('HOME'), name, uri))
  end
end

local mpv = script("mpv-load")
local mpc = script("mpc-load")
local aria2c = script("aria2c-load")

modes.add_binds("normal", {
  -- Mode switching
  { "é", "Search for string on current page.", function (w) w:start_search("/") end },
  { "è", "Enter `command` mode.", function (w) w:set_mode("command") end, {} },
  { "\"", "Set zoom to 100%", function (w) w:zoom_set(1) end },
  { "«", "Set zoom to 200%", function (w) w:zoom_set(2) end },

  -- Tab control
  { "<Control-p>", "Go to previous tab.", function (w) w:prev_tab() end },
  { "<Control-n>", "Go to next tab.", function (w) w:next_tab() end },
  {
    "^co$",
    "Close other tabs",
    function (w)
      local current_tab = w.tabs[w.tabs:current()]

      for _, tab in ipairs(w.tabs.children) do
        if current_tab ~= tab then
          w:close_tab(tab)
        end
      end
    end
  },

  -- URL opening
  {
    "o",
    "Open one or more URLs.",
    function (w) w:enter_cmd(":open ") end
  },
  {
    ",",
    "Open one or more URLs in a new tab.",
    function (w) w:enter_cmd(":tabopen ") end
  },
  {
    "O",
    "Open one or more URLs based on current location.",
    function (w) w:enter_cmd(":open " .. (w.view.uri or "")) end
  },
  {
    ";",
    "Open one or more URLs based on current location in a new tab.",
    function (w) w:enter_cmd(":tabopen " .. (w.view.uri or "")) end
  },

  -- Link following
  {
    "^e$",
    [[Start `follow` mode. Hint all clickable elements (as defined by the
      `follow.selectors.clickable` selector) and open links in the current tab.]],
    function (w)
      w:set_mode("follow",
        { selector = "uri"
        , evaluator = "click"
        , func = function (s) w:emit_form_root_active_signal(s) end
        }
      )
    end
  },
  {
    "^t$",
    [[Start follow mode. Hint all links (as defined by the
      `follow.selectors.uri` selector) and open links in a new tab.]],
    function (w)
      w:set_mode("follow",
        { prompt = "new tab"
        , selector = "uri"
        , evaluator = "uri"
        , func = function (uri)
            w:new_tab(uri, { switch = false, private = w.view.private })
          end
        }
      )
    end
  },
  {
    "<Control-.>",
    "Highlight and open URL in aria2c",
    function (w)
      w:set_mode("follow",
        { prompt = "aria2c"
        , selector = "uri"
        , evaluator = "uri"
        , func = aria2c
        }
      )
    end
  },
  {
    "<Control-e>",
    "Highlight and open URL in mpv",
    function (w)
      w:set_mode("follow",
        { prompt = "mpv"
        , selector = "uri"
        , evaluator = "uri"
        , func = mpv
        }
      )
    end
  },
  {
    "<Control-,>",
    "Highlight and open URL in mpc",
    function (w)
      w:set_mode("follow",
        { prompt = "mpc"
        , selector = "uri"
        , evaluator = "uri"
        , func = mpc
        }
      )
    end
  },
  {
    "<Control-E>",
    "Open current URL in mpv",
    function (w) mpv(string.gsub(w.view.uri or "", " ", "%%20")) end
  },

  -- Yanking / Pasting
  {
    "^ye$",
    "Yank followed URI to clipboard.",
    function (w)
      w:set_mode("follow", {
        prompt = "yank URI",
        selector = "uri",
        evaluator = "uri",
        func = function (uri)
          assert(type(uri) == "string")
          luakit.selection.clipboard = uri
          w:notify("Yanked uri: " .. uri)
        end
      })
    end
  },
  {
    "^yi$",
    "Yank followed image URI to clipboard.",
    function (w)
      w:set_mode("follow", {
        prompt = "yank image URI",
        selector = "image",
        evaluator = "uri",
        func = function (uri)
          assert(type(uri) == "string")
          luakit.selection.clipboard = uri
          w:notify("Yanked uri: " .. uri)
        end
      })
    end
  },
  {
    "yy",
    "Yank current URI to clipboard.",
    function (w)
      local uri = string.gsub(w.view.uri or "", " ", "%%20")
      luakit.selection.clipboard = uri
      w:notify("Yanked uri: " .. uri)
    end
  },
  {
    "pp",
    "Paste URI from clipboard",
    function (w)
      local uri = luakit.selection.clipboard
      w:new_tab(uri, { switch = true, private = w.view.private })
    end
  },
})

modes.add_binds("completion", {
  {
    "<Control-p>",
    "Select previous matching completion item.",
    function (w) w.menu:move_up() end
  },
  {
    "<Control-n>",
    "Select next matching completion item.",
    function (w) w.menu:move_down() end
  },
})
