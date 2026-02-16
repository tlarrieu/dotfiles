; extends

; match operators of [ command
(command
  name: (word) @punctuation.bracket
  (#eq? @punctuation.bracket "[")
  (#set! priority 120))
