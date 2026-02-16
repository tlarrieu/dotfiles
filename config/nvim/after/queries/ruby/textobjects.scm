; extends

; @parameters ------------------------------------------------------------------

(argument_list
  "," @_start .
  (_) @parameter.inner
 (#make-range! "parameter.outer" @_start @parameter.inner))
(argument_list
  . (_) @parameter.inner
  . ","? @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))

(method_parameters
  "," @_start .
  (_) @parameter.inner
 (#make-range! "parameter.outer" @_start @parameter.inner))
(method_parameters
  . (_) @parameter.inner
  . ","? @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))

(hash
  "," @_start .
  (_) @parameter.inner
 (#make-range! "parameter.outer" @_start @parameter.inner))
(hash
  . (_) @parameter.inner
  . ","? @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))

(array
  "," @_start .
  (_) @parameter.inner
 (#make-range! "parameter.outer" @_start @parameter.inner))
(array
  . (_) @parameter.inner
  . ","? @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))

(block_parameters
  "," @_start .
  (_) @parameter.inner
 (#make-range! "parameter.outer" @_start @parameter.inner))
(block_parameters
  . (_) @parameter.inner
  . ","? @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))

(lambda_parameters
  "," @_start .
  (_) @parameter.inner
 (#make-range! "parameter.outer" @_start @parameter.inner))
(lambda_parameters
  . (_) @parameter.inner
  . ","? @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))

(when
  "," @_start .
  (_) @parameter.inner
 (#make-range! "parameter.outer" @_start @parameter.inner))
(when
  . (_) @parameter.inner
  . ","? @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))

; @conditional -----------------------------------------------------------------

((_ condition: (_) @conditional.inner)?) @conditional.outer
((unless_modifier body: (_) @block.inner)?) @conditional.outer @block.outer
((if_modifier body: (_) @block.inner)?) @conditional.outer @block.outer
(else . (_) @_start (_)* @_end (#make-range! "block.inner" @_start @_end)) @block.outer
(then . (_) @_start (_)* @_end (#make-range! "block.inner" @_start @_end)) @block.outer
(case value: (_) @conditional.inner)
(case (when pattern: (_) @conditional.inner)) @conditional.outer

; @assignment ------------------------------------------------------------------

(pair key: (_) @assignment.lhs value: (_) @assignment.rhs) @assignment
(assignment left: (_) @assignment.lhs right: (_) @assignment.rhs) @assignment
(keyword_parameter name: (identifier) @assignment.lhs value: (nil) @assignment.rhs) @assignment
