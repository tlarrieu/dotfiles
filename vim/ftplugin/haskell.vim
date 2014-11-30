call signify#SignifyMatch("hsOperator", "hsLambda", "\"\\\\\\ze\[\[:alpha:\][:space:\]_(\[\]\"", "λ")
call signify#SignifyMatch("hsOperator", "hsDotOperator", "\"\\.\"", "∘")
call signify#SignifyMatch("hsOperator", "hsDifferentOperator", "\"/=\"", "≠")
call signify#SignifyMatch("hsOperator", "hsEqualOperator", "\"==\"", "≡")
call signify#SignifyMatch("hsOperator", "hsGreaterEqualOperator", "\">=\"", "≥")
call signify#SignifyMatch("hsOperator", "hsLesserEqualOperator", "\"<=\"", "≤")
call signify#SignifyMatch("hsOperator", "hsRightArrowOperator", "\"->\"", "→")
call signify#SignifyMatch("hsOperator", "hsLeftArrowOperator", "\"<-\"", "←")
call signify#SignifyMatch("hsOperator", "hsModuleOperator", "\"::\"", "∷")

noremap <buffer> K :!zeal --query haskell:"<cword>"&<cr><cr>
