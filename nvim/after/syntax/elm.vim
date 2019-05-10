syntax match elmNiceOperator " \zs\*\ze " conceal cchar=×
syntax match elmNiceOperator " \zs\/\ze " conceal cchar=÷
syntax match elmNiceOperator "&&" conceal cchar=∧
syntax match elmNiceOperator "||" conceal cchar=∨
syntax match elmNiceOperator "\\" conceal cchar=λ

hi! link elmBuiltinOp Operator
hi! link elmNiceOperator elmBuiltinOp
hi! link Conceal elmBuiltinOp
