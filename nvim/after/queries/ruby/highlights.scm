; extends

(keyword_parameter name: (_) @variable.key)
(pair key: (_) @variable.key)

(call
  method: (identifier)
  @keyword.function.ruby
  (#eq? @keyword.function.ruby "private_class_method"))

(class name: (constant) @class)
(module name: (constant) @class)
(assignment left: (constant) @constant.assignment)

((next) @keyword.next (#set! priority 110))
((break) @keyword.break (#set! priority 110))

(unless
  "end" @keyword.conditional)
