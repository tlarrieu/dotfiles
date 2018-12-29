local modes = require("modes")

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

local mpv = function(uri, w)
  assert(type(uri) == "string")
  w:notify("Starting mpv: " .. uri)
  luakit.spawn("mpv " .. uri .. " --ytdl-format=95/22/43")
end

local mpc = function(uri, w)
  assert(type(uri) == "string")
  w:notify("Starting mpc: " .. uri)
  luakit.spawn('/bin/sh /home/tlarrieu/scripts/mpc-load "' .. uri .. '"')
end

modes.add_binds("normal", {
  -- Mode switching
  { "é", "Search for string on current page.", function (w) w:start_search("/") end },
  { "è", "Enter `command` mode.", function (w) w:set_mode("command") end, {} },

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

  -- Link following
  {
    "^E$",
    [[Start `follow` mode. Hint all clickable elements (as defined by the
      `follow.selectors.clickable` selector) and open links in the current tab.]],
    function (w)
      w:set_mode("follow", {
        selector = "clickable",
        evaluator = "click",
        func = function (s) w:emit_form_root_active_signal(s) end,
      })
    end
  },
  {
    "^e$",
    [[Start follow mode. Hint all links (as defined by the
      `follow.selectors.uri` selector) and open links in a new tab.]],
    function (w)
      w:set_mode("follow", {
        prompt = "new tab",
        selector = "uri",
        evaluator = "uri",
        func = function (uri)
          assert(type(uri) == "string")
          w:new_tab(uri, { switch = true, private = w.view.private })
        end
      })
    end
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

  {
    "<Control-e>",
    "Highlight and open URL in mpv",
    function (w)
      w:set_mode("follow", {
        prompt = "mpv",
        selector = "uri",
        evaluator = "uri",
        func = function(uri) mpv(uri, w) end
      })
    end
  },
  {
    "<Control-E>",
    "Open current URL in mpv",
    function (w) mpv(string.gsub(w.view.uri or "", " ", "%%20"), w) end
  },
  {
    "<Control-,>",
    "Highlight and open URL in mpc",
    function (w)
      w:set_mode("follow", {
        prompt = "mpc",
        selector = "uri",
        evaluator = "uri",
        func = function(uri) mpc(uri, w) end
      })
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
