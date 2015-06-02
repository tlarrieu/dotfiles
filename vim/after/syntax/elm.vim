syntax match elmNiceOperator " \zs\*\ze " conceal cchar=×
syntax match elmNiceOperator " \zs\/\/\ze " conceal cchar=⊘
syntax match elmNiceOperator " \zs\/\ze " conceal cchar=÷
syntax match elmNiceOperator "&&" conceal cchar=∧
syntax match elmNiceOperator "->" conceal cchar=→
syntax match elmNiceOperator "/=" conceal cchar=≠
syntax match elmNiceOperator "::" conceal cchar=∷
syntax match elmNiceOperator "<-" conceal cchar=←
syntax match elmNiceOperator "<=" conceal cchar=≤
syntax match elmNiceOperator "<\~" conceal cchar=↜
syntax match elmNiceOperator "<|" conceal cchar=◁
syntax match elmNiceOperator "==" conceal cchar=≡
syntax match elmNiceOperator ">=" conceal cchar=≥
syntax match elmNiceOperator "\.\." conceal cchar=‥
syntax match elmNiceOperator "\\" conceal cchar=λ
syntax match elmNiceOperator "\~" conceal cchar=∼
syntax match elmNiceOperator "|>" conceal cchar=▷
syntax match elmNiceOperator "||" conceal cchar=∨

hi! link elmBuiltinOp Function
hi! link elmNiceOperator elmBuiltinOp
hi! link Conceal elmBuiltinOp
