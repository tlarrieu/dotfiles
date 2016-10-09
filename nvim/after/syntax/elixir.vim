syntax match elixirNiceOperator "|>" conceal cchar=▹
syntax match elixirNiceOperator "=\~" conceal cchar=∼
syntax match elixirNiceOperator ">=" conceal cchar=≥
syntax match elixirNiceOperator "<=" conceal cchar=≤
syntax match elixirNiceOperator "->" conceal cchar=→
syntax match elixirNiceOperator "=>" conceal cchar=⇒
syntax match elixirNiceOperator "<=>" conceal cchar=⇔
syntax match elixirNiceOperator "!=" conceal cchar=≠
syntax match elixirNiceOperator " \zs\*\ze " conceal cchar=×
syntax match elixirNiceOperator " \zs\/\ze " conceal cchar=÷
syntax match elixirNiceOperator "==" conceal cchar=≡
syntax match elixirNiceOperator "&&" conceal cchar=∧
syntax match elixirNiceOperator "||" conceal cchar=∨
syntax match elixirNiceOperator "fn" conceal cchar=λ
syntax match elixirNiceOperator "<>" conceal cchar=⊙
syntax match elixirNiceOperator "++" conceal cchar=⊕

highlight link elixirNiceOperator Operator
highlight! link Conceal Operator
