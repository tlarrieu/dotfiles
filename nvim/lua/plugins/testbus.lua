return {
  'tlarrieu/testbus',
  opts = {
    markers = {
      passed = { ' ✔ ', 'DiagnosticPass' },
      mixed  = { ' ➠ ', 'DiagnosticMixed' },
      failed = { ' ✘ ', 'DiagnosticFail' },
    },
  },
}
