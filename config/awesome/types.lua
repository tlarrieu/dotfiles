---@meta
--- Type definitions for the awesome config (panel, widgets, keymaps…), for
--- lua-language-server only (never required). Awesome ships no annotations, so
--- its objects get minimal shapes: only what the config uses.
--- Globals are declared with ---@class on their assignment (not ---@type), so
--- that the table defines the class instead of having to fill all its fields.

-- [[ Objects ]] ---------------------------------------------------------------

---@class Widget A wibox widget (textbox, layout, container…)
---@field visible boolean
---@field markup string Pango markup (textboxes)
---@field buttons fun(self: Widget, buttons: table)
---@field set_children fun(self: Widget, children: Widget[])

---@class ProgressBar: Widget A wibox.widget.progressbar
---@field value number
---@field background_color string #rrggbb (the filled part, with our theme)

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

---@class Screen An awesome screen
---@field index integer
---@field tags table[]
---@field selected_tag table?
---@field wibar table? The panel (see panel.lua)

---@class Client An awesome client (window); only the fields read off typed values
---@field valid boolean
---@field screen Screen
---@field immortal boolean? Ours: hidden instead of killed (see spawner.soft_kill)
---@field raise fun(self: Client)
---@field emit_signal fun(self: Client, name: string, ...)

--- Called on every pointer event while grabbing; return false to release
---@alias MousegrabberCallback fun(mouse: { x: number, y: number, buttons: boolean[] }): boolean

-- [[ Globals ]] ---------------------------------------------------------------

---@class Awesome The awesome global
---@field connect_signal fun(name: string, callback: fun(...))
---@field emit_signal fun(name: string, ...)
---@field restart fun()
---@field kill fun(pid: integer, signal: integer): boolean
---@field unix_signal table<string, integer> Signal numbers by name (SIGTERM…)
awesome = {}

--- Signal callbacks stay untyped (fun(...)): they reach into many client fields
---@class ClientGlobal The client global
---@field focus Client? The focused client (assign nil to unfocus)
---@field get fun(): Client[]
---@field connect_signal fun(name: string, callback: fun(...))
client = {}

---@class MouseGlobal The mouse global
---@field screen Screen The screen under the pointer
---@field coords fun(coords?: { x: number, y: number }, silent?: boolean): { x: number, y: number }
mouse = {}

---@class RootGlobal The root (desktop) global
---@field keys fun(keys: table)
---@field buttons fun(buttons: table)
root = {}

---@class MousegrabberGlobal The mousegrabber global
---@field run fun(callback: MousegrabberCallback, cursor: string)
mousegrabber = {}

--- The screen global, iterated with `for s in screen do`
---@type fun(): Screen?
screen = nil
