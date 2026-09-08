---@class StatusConfig
---@field icon string
---@field color string?

---@class StatusesConfig
---@field running StatusConfig
---@field cmdline StatusConfig
---@field stopped StatusConfig
---@field success StatusConfig
---@field failure StatusConfig
---@field panic StatusConfig

---@class MarkerConfig
---@field [1] string icon
---@field [2] string color or highlight group

---@class MarkersConfig
---@field passed MarkerConfig virtual text for passed test
---@field mixed MarkerConfig virtual text for partially passed test
---@field failed MarkerConfig virtual text for failed tests

---@class Config
---@field status StatusesConfig
---@field markers MarkersConfig
---@field diagnostics vim.diagnostics.Opts
---@field json_path string path to the JSON output by tests
return {
  status = {
    running = { icon = '󰐌', color = nil }, -- white
    cmdline = { icon = '', color = 'DiagnosticHint' },
    stopped = { icon = '', color = 'DiagnosticWarn' },
    success = { icon = '󰗠', color = 'DiagnosticOk' },
    failure = { icon = '󰅙', color = 'DiagnosticError' },
    panic = { icon = '󰀨', color = 'DiagnosticUnnecessary' },
  },
  markers = {
    passed  = { ' ✔ ', 'DiagnosticPass' },
    mixed   = { ' ➠ ', 'DiagnosticMixed' },
    failed  = { ' ✘ ', 'DiagnosticFail' },
    pending = { ' 󰔟 ', 'DiagnosticPending' },
  },
  diagnostics = { virtual_lines = true, virtual_text = false, underline = false },
  json_path = '/tmp/testbus.json',
}
