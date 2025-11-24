; extends

(keyword_parameter name: (_) @variable.key)
(pair key: (_) @variable.key)

(call method: (identifier) @keyword.function.ruby (#eq? @keyword.function.ruby "private_class_method"))

(call method: (identifier) @keyword.raise (#eq? @keyword.raise "raise"))
((identifier) @keyword.raise (#eq? @keyword.raise "raise"))

(class name: (constant) @class)
(module name: (constant) @class)
(assignment left: (constant) @constant.assignment)

((_) . "?" @operator.ternary.ruby (_) ":"  @operator.ternary.ruby (_))

("next") @keyword.next (#set! priority 110)
("break") @keyword.break (#set! priority 110)
(unless "end" @keyword.conditional)
(case "end" @keyword.conditional)
(singleton_method object: (self) @keyword) ; "self" in singleton method definition

((comment) @comment.directive (#set! priority 120) (#match? @comment.directive "^# frozen_string_literal: (true|false)"))
