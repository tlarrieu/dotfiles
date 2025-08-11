; extends

(keyword_parameter name: (_) @variable.key)
(pair key: (_) @variable.key)

(call
  method: (identifier)
  @keyword.function.ruby
  (#eq? @keyword.function.ruby "private_class_method"))
