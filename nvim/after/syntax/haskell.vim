syntax match hsNiceOperator " \zs\*\ze " conceal cchar=×
syntax match hsNiceOperator " \zs\/\ze " conceal cchar=÷
syntax match hsNiceOperator "++" conceal cchar=‡
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
syntax match hsNiceOperator "\\\ze[[:alpha:][:space:]_([]" conceal cchar=λ
syntax match hsNiceOperator " \zs\.\ze " conceal cchar=∘
syntax match hsNiceOperator " \zs::\ze " conceal cchar=∷

syntax match hsNiceOperator "<|" conceal cchar=⊲
syntax match hsNiceOperator "|>" conceal cchar=⊳
syntax match hsNiceOperator "><" conceal cchar=⋈

syntax match hsNiceOperator ">>=\ze\_[[:alpha:][:space:]_()[\]]" conceal cchar=↪
syntax match hsNiceOperator "=<<\ze\_[[:alpha:][:space:]_()[\]]" conceal cchar=↩

syntax match hsNiceOperator "\<sqrt\>\(\ze\s*[.$]\|\s*\)" conceal cchar=√

syntax match hsNiceOperator "\<Bool\>" conceal cchar=𝔹
syntax match hsNiceOperator "\<Int\>"  conceal cchar=ℤ
syntax match hsNiceOperator "\<Double\>" conceal cchar=𝔻
syntax match hsNiceOperator "\<String\>" conceal cchar=𝕊
syntax match hsNiceOperator "\<Text\>" conceal cchar=𝕋

" syntax match hsNiceOperator "\<Maybe\>" conceal cchar=𝐌
syntax match hsNiceOperator "\<Just\>" conceal cchar=𝐽
syntax match hsNiceOperator "\<Nothing\>" conceal cchar=𝑁

" syntax match hsNiceOperator "\<Either\>" conceal cchar=𝐄
syntax match hsNiceOperator "\<Right\>" conceal cchar=𝑅
syntax match hsNiceOperator "\<Left\>" conceal cchar=𝐿

syntax match hsNiceSpecial "\<True\>"  conceal cchar=𝐓
syntax match hsNiceSpecial "\<False\>" conceal cchar=𝐅

syntax match hsNiceOperator "\(\*\*\|\^\|\^\^\)1\ze\_W" conceal cchar=¹
syntax match hsNiceOperator "\(\*\*\|\^\|\^\^\)2\ze\_W" conceal cchar=²
syntax match hsNiceOperator "\(\*\*\|\^\|\^\^\)3\ze\_W" conceal cchar=³
syntax match hsNiceOperator "\(\*\*\|\^\|\^\^\)4\ze\_W" conceal cchar=⁴
syntax match hsNiceOperator "\(\*\*\|\^\|\^\^\)5\ze\_W" conceal cchar=⁵
syntax match hsNiceOperator "\(\*\*\|\^\|\^\^\)6\ze\_W" conceal cchar=⁶
syntax match hsNiceOperator "\(\*\*\|\^\|\^\^\)7\ze\_W" conceal cchar=⁷
syntax match hsNiceOperator "\(\*\*\|\^\|\^\^\)8\ze\_W" conceal cchar=⁸
syntax match hsNiceOperator "\(\*\*\|\^\|\^\^\)9\ze\_W" conceal cchar=⁹

syntax match hsNiceOperator "`elem`" conceal cchar=∈
syntax match hsNiceOperator "`notElem`" conceal cchar=∉
syntax match hsNiceOperator "`isSubsetOf`" conceal cchar=⊆
syntax match hsNiceOperator "`union`" conceal cchar=∪
syntax match hsNiceOperator "`intersect`" conceal cchar=∩

syntax match hsNiceOperator "\<empty\>" conceal cchar=ø
syntax match hsNiceOperator "\<mzero\>" conceal cchar=ø
syntax match hsNiceOperator "\<mempty\>" conceal cchar=ø

hi! link hsNiceOperator Operator
hi! link Conceal Operator
hi! link hsNiceSpecial hsType
