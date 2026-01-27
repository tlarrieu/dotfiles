; extends

; variables
(keyword_parameter name: (_) @variable.key)
(pair key: (_) @variable.key)

; functions
(call method: (identifier) @keyword.function.ruby (#eq? @keyword.function.ruby "private_class_method"))

; control flow keywords
(call method: (identifier) @keyword.raise (#eq? @keyword.raise "raise"))
((identifier) @keyword.raise (#eq? @keyword.raise "raise"))
("next") @keyword.next (#set! priority 110)
("break") @keyword.break (#set! priority 110)
(unless "end" @keyword.conditional)
(case "end" @keyword.conditional)
((_) . "?" @operator.ternary.ruby (_) ":"  @operator.ternary.ruby (_))

(_ method: ((identifier)) @type @function.method.class (#eq? @type "class"))

; class
(class name: (constant) @class)

; module
(module name: (constant) @class)

; constants
(assignment left: (constant) @constant.assignment)

(singleton_method object: (self) @keyword) ; "self" in singleton method definition

((comment) @comment.directive (#set! priority 120) (#match? @comment.directive "^# frozen_string_literal: (true|false)"))
