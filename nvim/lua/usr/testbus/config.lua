return {
  status = {
    running = { id = 'running', icon = '󰐌', color = nil }, -- white
    cmdline = { id = 'cmdline', icon = '', color = 'DiagnosticHint' }, -- violet
    stopped = { id = 'stopped', icon = '', color = 'DiagnosticWarn' }, -- yellow
    success = { id = 'success', icon = '󰗠', color = 'DiagnosticOk' }, -- green
    failure = { id = 'failure', icon = '󰅙', color = 'DiagnosticError' }, -- red
    panic = { id = 'panic', icon = '󰀨', color = 'DiagnosticUnnecessary' }, -- pink
  },
  markers = {
    passed = { ' ✔ ', 'DiagnosticPass' },
    mixed  = { ' ✘ ', 'DiagnosticMixed' },
    failed = { ' ✘ ', 'DiagnosticFail' },
  },
  diagnostics = { virtual_lines = true, virtual_text = false, underline = false },
  json_path = '/tmp/testbus.json',
}
