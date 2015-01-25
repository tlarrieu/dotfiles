call signify#SignifyMatch("erbOperator", "erbLambdaOperator", "\"->\"", "→")
call signify#SignifyMatch("erbOperator", "erbHashRocketOperator", "\"=>\"", "⇒")
call signify#SignifyMatch("erbOperator", "erbSpaceShipOperator", "\"<=>\"", "⇔")
call signify#SignifyMatch("erbOperator", "erbDifferentOperator", "\"!=\"", "≠")
call signify#SignifyMatch("erbOperator", "erbGreaterEqualOperator", "\">=\"", "≥")
call signify#SignifyMatch("erbOperator", "erbLesserEqualOperator", "\"<=\"", "≤")
call signify#SignifyMatch("erbOperator", "erbTimesOperator", "\" \\zs\\*\\ze \"", "×")
call signify#SignifyMatch("erbOperator", "erbOverOperator", "\" \\zs/\\ze \"", "÷")
call signify#SignifyMatch("erbOperator", "erbAndOperator", "\"&&\"", "∧")
call signify#SignifyMatch("erbOperator", "erbAndOperator", "\"||\"", "∨")
call signify#SignifyMatch("erbOperator", "erbModuleOperator", "\"::\"", "∷")
" call signify#SignifyKeyword("erbKeyword", "erbLambda", "lambda", "λ")
" call signify#SignifyKeyword("erbKeyword", "erbProc", "proc", "π")

" nnoremap <buffer> k :!zeal --query ruby:"<cword>"&<cr><cr>
" nnoremap <buffer> K :Silent zeal --query ruby:""&<left><left>
