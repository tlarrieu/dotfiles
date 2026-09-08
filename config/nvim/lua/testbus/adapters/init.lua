---@class Handler
---@field handle fun(data: table<string>, path: string): boolean, Report?
---@field options table<string>

---@type table<string, Handler>
return {
  rspec = require('testbus.adapters.rspec'),
  default = require('testbus.adapters.default'),
}
