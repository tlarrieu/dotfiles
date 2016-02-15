syntax match goNiceOperator ">=" conceal cchar=≥
syntax match goNiceOperator "<=" conceal cchar=≤
syntax match goNiceOperator "->" conceal cchar=→
syntax match goNiceOperator "=>" conceal cchar=⇒
syntax match goNiceOperator "<=>" conceal cchar=⇔
syntax match goNiceOperator "!=" conceal cchar=≠
syntax match goNiceOperator " \zs\*\ze " conceal cchar=×
syntax match goNiceOperator " \zs\/\ze " conceal cchar=÷
syntax match goNiceOperator "==" conceal cchar=≡
syntax match goNiceOperator "&&" conceal cchar=∧
syntax match goNiceOperator "||" conceal cchar=∨

syntax keyword goNiceOperator lambda conceal cchar=λ
syntax keyword goNiceOperator proc conceal cchar=π

hi link goNiceOperator Operator
hi! link Conceal Operator

