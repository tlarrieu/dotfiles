
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

noremap <buffer> <leader><return> :TestFile<cr>
noremap <buffer> <return> :TestNearest<cr>

nmap <buffer> <Leader>gi <Plug>(go-implements)
nmap <buffer> <Leader>gI <Plug>(go-info)
nmap <buffer> <Leader>gd <Plug>(go-doc-vertical)
nmap <buffer> <leader>gr <Plug>(go-run)
nmap <buffer> <leader>gt <Plug>(go-test)
nmap <buffer> yd <Plug>(go-def)

let g:go_fmt_command = "goimports"
