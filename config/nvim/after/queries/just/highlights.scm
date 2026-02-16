; extends

([
  ":="
  "?"
  "=="
  "!="
  "=~"
  "@"
  "="
  "$"
  "*"
  "+"
  "&&"
  "@-"
  "-@"
  "-"
  "/"
  ":"
] @operator (#set! "priority" 120))

([
  "("
  ")"
  "["
  "]"
  "{{"
  "}}"
  "{"
  "}"
] @punctuation.bracket (#set! "priority" 120))

[
  "`"
  "```"
] @punctuation.special

"," @punctuation.delimiter


(assignment (identifier) @variable (#set! "priority" 120))
(alias (identifier) @variable (#set! "priority" 120))
(value (identifier) @variable (#set! "priority" 120))
