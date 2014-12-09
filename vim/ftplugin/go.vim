call signify#SignifyMatch("goOperator", "goGreaterEqualOperator", "\">=\"", "≥")
call signify#SignifyMatch("goOperator", "goLesserEqualOperator", "\"<=\"", "≤")
call signify#SignifyMatch("goOperator", "goLambdaOperator", "\"->\"", "→")
call signify#SignifyMatch("goOperator", "goHashRocketOperator", "\"=>\"", "⇒")
call signify#SignifyMatch("goOperator", "goSpaceShipOperator", "\"<=>\"", "⇔")
call signify#SignifyMatch("goOperator", "goDifferentOperator", "\"!=\"", "≠")
call signify#SignifyMatch("goOperator", "goTimesOperator", "\" \\zs\\*\\ze \"", "×")
call signify#SignifyMatch("goOperator", "goOverOperator", "\" \\zs/\\ze \"", "÷")
call signify#SignifyMatch("goOperator", "goEqualOperator", "\"==\"", "≡")
call signify#SignifyMatch("goOperator", "goAndOperator", "\"&&\"", "∧")
call signify#SignifyMatch("goOperator", "goAndOperator", "\"||\"", "∨")

nnoremap <buffer> k :!zeal --query go:"<cword>"&<cr><cr>
nnoremap <buffer> K :Silent zeal --query go:""&<left><left>
