setlocal conceallevel=2
setlocal concealcursor=c
setlocal concealcursor+=n
setlocal concealcursor+=i

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
