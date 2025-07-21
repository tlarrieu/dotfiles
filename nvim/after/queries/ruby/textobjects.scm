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

(array
  "," @_start .
  (_) @parameter.inner
 (#make-range! "parameter.outer" @_start @parameter.inner))
(array
  . (_) @parameter.inner
  . ","? @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))

; @conditional -----------------------------------------------------------------

((_ condition: (_) @conditional.inner)?) @conditional.outer
((unless_modifier body: (_) @conditional.inner)?) @conditional.outer
((if_modifier body: (_) @conditional.inner)?) @conditional.outer

(else
  . (_) @_start
  (_)* @_end
  (#make-range! "conditional.inner" @_start @_end))
(then
  . (_) @_start
  (_)* @_end
  (#make-range! "conditional.inner" @_start @_end))

(case value: (_) @conditional.inner)
(case (when pattern: (_) @conditional.inner)) @conditional.outer
