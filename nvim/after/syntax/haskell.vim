syntax match hsNiceOperator " \zs\*\ze " conceal cchar=×
syntax match hsNiceOperator " \zs\/\ze " conceal cchar=÷
syntax match hsNiceOperator "++" conceal cchar=⊕
syntax match hsNiceOperator "&&" conceal cchar=∧
syntax match hsNiceOperator "||" conceal cchar=∨
syntax match hsNiceOperator "/=" conceal cchar=≠
syntax match hsNiceOperator "=>" conceal cchar=⇒
syntax match hsNiceOperator "->" conceal cchar=→
syntax match hsNiceOperator "<-" conceal cchar=←
syntax match hsNiceOperator "<=" conceal cchar=≤
syntax match hsNiceOperator ">=" conceal cchar=≥
syntax match hsNiceOperator "==" conceal cchar=≡
syntax match hsNiceOperator "\.\." conceal cchar=‥
syntax match hsNiceOperator "\\" conceal cchar=λ
syntax match hsNiceOperator " \zs\.\ze " conceal cchar=∘
syntax match hsNiceOperator " \zs::\ze " conceal cchar=∷

hi link hsNiceOperator Operator
hi! link Conceal Operator
