; extends

; @parameters ------------------------------------------------------------------

(array (_) @parameter.inner @parameter.outer . ","? @parameter.outer)
(hash (_) @parameter.inner @parameter.outer . ","? @parameter.outer)
(argument_list (_) @parameter.inner @parameter.outer . ","? @parameter.outer)
(method_parameters (_) @parameter.inner @parameter.outer . ","? @parameter.outer)
(block_parameters (_) @parameter.inner @parameter.outer . ","? @parameter.outer)
(when pattern: (_) @parameter.inner @parameter.outer . ","? @parameter.outer)

; @conditional -----------------------------------------------------------------

(_ condition: (_) @conditional.inner consequence: (then (_) @block.inner)) @conditional.outer
(_ alternative: (else (_) @block.inner)) @conditional.outer
(case value: (_) @conditional.inner)
(case (when pattern: (_) @conditional.inner)) @conditional.outer

; @assignment ------------------------------------------------------------------

(pair key: (_) @assignment.lhs value: (_) @assignment.rhs) @assignment
(assignment left: (_) @assignment.lhs right: (_) @assignment.rhs) @assignment
(keyword_parameter name: (_) @assignment.lhs value: (_) @assignment.rhs) @assignment
