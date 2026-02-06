; extends

; variables
(keyword_parameter name: (_) @variable.key)
(pair key: (_) @variable.key)

; functions
(call method: (identifier) @keyword.function.ruby (#eq? @keyword.function.ruby "private_class_method"))
(_ method: ((identifier)) @type @function.method.call.class (#eq? @type "class"))
(_ method: ((identifier)) @function.method.call.flow (#eq? @function.method.call.flow "then"))
(_ method: ((identifier)) @function.method.call.flow (#eq? @function.method.call.flow "tap"))

; control flow keywords
(call method: (identifier) @keyword.exit (#eq? @keyword.exit "exit"))
((identifier) @keyword.exit (#eq? @keyword.exit "exit"))
(call method: (identifier) @keyword.raise (#eq? @keyword.raise "raise"))
((identifier) @keyword.raise (#eq? @keyword.raise "raise"))
("next") @keyword.next (#set! priority 110)
("break") @keyword.break (#set! priority 110)
(unless "end" @keyword.conditional)
(case "end" @keyword.conditional)
((_) . "?" @operator.ternary.ruby (_) ":"  @operator.ternary.ruby (_))

; class
(class name: (constant) @class (#set! priority 120))
(class name: (scope_resolution name: (constant)) @class (#set! priority 120))
((scope_resolution name: (constant)) @type (#set! priority 110))

; module
(module name: (constant) @class (#set! priority 120))
(module name: (scope_resolution name: (constant)) @class (#set! priority 120))

; constants
(assignment left: (constant) @constant.assignment)

(singleton_method object: (self) @keyword) ; "self" in singleton method definition

((comment) @comment.directive (#set! priority 120) (#match? @comment.directive "^# frozen_string_literal: (true|false)"))
