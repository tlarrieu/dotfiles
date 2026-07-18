; extends

((command name: (_) @keyword.exit) (#eq? @keyword.exit "exit") (#set! priority 120))
((command name: (_) @keyword.return) (#eq? @keyword.return "return") (#set! priority 120))
