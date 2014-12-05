call signify#SignifyMatch("rubyOperator", "rubyGreaterEqualOperator", "\">=\"", "≥")
call signify#SignifyMatch("rubyOperator", "rubyLesserEqualOperator", "\"<=\"", "≤")
call signify#SignifyMatch("rubyOperator", "rubyLambdaOperator", "\"->\"", "→")
call signify#SignifyMatch("rubyOperator", "rubyHashRocketOperator", "\"=>\"", "⇒")
call signify#SignifyMatch("rubyOperator", "rubySpaceShipOperator", "\"<=>\"", "⇔")
call signify#SignifyMatch("rubyOperator", "rubyDifferentOperator", "\"!=\"", "≠")
call signify#SignifyMatch("rubyOperator", "rubyTimesOperator", "\" \\zs\\*\\ze \"", "×")
call signify#SignifyMatch("rubyOperator", "rubyOverOperator", "\" \\zs/\\ze \"", "÷")
call signify#SignifyMatch("rubyOperator", "rubyEqualOperator", "\"==\"", "≡")
call signify#SignifyMatch("rubyOperator", "rubyAndOperator", "\"&&\"", "∧")
call signify#SignifyMatch("rubyOperator", "rubyAndOperator", "\"||\"", "∨")
call signify#SignifyMatch("rubyOperator", "rubyModuleOperator", "\"::\"", "∷")
call signify#SignifyMatch("rubyOperator", "rubyLambdaKeyword", "\"lambda\"", "λ")
call signify#SignifyMatch("rubyOperator", "rubyProcKeyword", "\"proc\"", "π")

call signify#SignifyKeyword("rubyKeyword", "rubyLambdaKeyword", "lambda", "λ")
call signify#SignifyKeyword("rubyKeyword", "rubyProcKeyword", "proc", "π")

nnoremap <buffer> k :!zeal --query ruby:"<cword>"&<cr><cr>
nnoremap <buffer> K :Silent zeal --query ruby:""&<left><left>
