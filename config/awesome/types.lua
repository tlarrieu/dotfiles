---@meta
-- Type definitions for the awesome config (panel and widgets), for
-- lua-language-server only (never required). Awesome ships no annotations, so
-- its objects get minimal shapes.

---@class Widget A wibox widget (textbox, layout, container…)
---@field visible boolean
---@field markup string Pango markup (textboxes)
---@field buttons fun(self: Widget, buttons: table)
---@field set_children fun(self: Widget, children: Widget[])

---@class Timer A gears.timer
---@field started boolean
---@field start fun(self: Timer)
---@field stop fun(self: Timer)
---@field connect_signal fun(self: Timer, name: string, callback: fun())

---@class Tooltip An awful.tooltip
---@field text string
---@field markup string

---@alias SpawnCallback fun(stdout: string, stderr: string, reason: 'exit'|'signal', code: integer)

---@class PanelWidget What a widgets/ module returns, for panel.lua
---@field widget Widget The widget to place in the wibar
---@field update fun() Repaint it from its source

---@class Awesome The awesome global (only what the config uses)
---@field connect_signal fun(name: string, callback: fun(...))
---@field emit_signal fun(name: string, ...)
---@field kill fun(pid: integer, signal: integer): boolean
---@field unix_signal table<string, integer> Signal numbers by name (SIGTERM…)
---@type Awesome
---@diagnostic disable-next-line: missing-fields
awesome = {}

---@class Screen An awesome screen
---@field index integer
---@field tags table[]
---@field wibar table? The panel (see panel.lua)

-- The screen global, iterated with `for s in screen do`
---@type fun(): Screen?
screen = nil
