syntax match rubyNiceOperator ">=" conceal cchar=≥
syntax match rubyNiceOperator "<=" conceal cchar=≤
syntax match rubyNiceOperator "->" conceal cchar=→
syntax match rubyNiceOperator "=>" conceal cchar=⇒
syntax match rubyNiceOperator "<=>" conceal cchar=⇔
syntax match rubyNiceOperator "!=" conceal cchar=≠
syntax match rubyNiceOperator " \zs\*\ze " conceal cchar=×
syntax match rubyNiceOperator " \zs\/\ze " conceal cchar=÷
syntax match rubyNiceOperator "==" conceal cchar=≡
syntax match rubyNiceOperator "&&" conceal cchar=∧
syntax match rubyNiceOperator "||" conceal cchar=∨

syntax keyword rubyNiceOperator lambda conceal cchar=λ
syntax keyword rubyNiceOperator proc conceal cchar=π

hi link rubyNiceOperator Operator
hi! link Conceal Operator
