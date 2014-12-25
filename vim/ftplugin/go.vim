
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

nmap <buffer> <Leader>gI <Plug>(go-implements)
nmap <buffer> <Leader>i <Plug>(go-info)

nmap <buffer> <leader><return> <Plug>(go-run)
nmap <buffer> <return> <Plug>(go-test)

nmap <buffer> yd <Plug>(go-def)

noremap <buffer> <leader>è :<c-u>GoLint<cr>

let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
