call signify#SignifyMatch("hsOperator", "hsLambda", "\"\\\\\\ze\[\[:alpha:\][:space:\]_(\[\]\"", "λ")
call signify#SignifyMatch("hsOperator", "hsListComprehensionOperator", "\"\\.\\.\"", "‥")
call signify#SignifyMatch("hsOperator", "hsDotOperator", "\" \\zs\\.\\ze \"", "∘")
call signify#SignifyMatch("hsOperator", "hsDifferentOperator", "\"/=\"", "≠")
call signify#SignifyMatch("hsOperator", "hsEqualOperator", "\"==\"", "≡")
call signify#SignifyMatch("hsOperator", "hsGreaterEqualOperator", "\">=\"", "≥")
call signify#SignifyMatch("hsOperator", "hsLesserEqualOperator", "\"<=\"", "≤")
call signify#SignifyMatch("hsOperator", "hsRightArrowOperator", "\"->\"", "→")
call signify#SignifyMatch("hsOperator", "hsLeftArrowOperator", "\"<-\"", "←")
call signify#SignifyMatch("hsOperator", "hsLeftArrowOperator", "\"=>\"", "⇒")
call signify#SignifyMatch("hsOperator", "hsModuleOperator", "\"::\"", "∷")
call signify#SignifyMatch("hsOperator", "hsAndOperator", "\"&&\"", "∧")
call signify#SignifyMatch("hsOperator", "hsAndOperator", "\"||\"", "∨")

nnoremap <buffer> k :!zeal --query haskell:"<cword>"&<cr><cr>
nnoremap <buffer> K :Silent zeal --query haskell:""&<left><left>
