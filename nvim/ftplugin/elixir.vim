setlocal conceallevel=2
setlocal concealcursor=cni
setlocal iskeyword+=:
setlocal iskeyword+=?
setlocal iskeyword+=!

nnoremap <buffer> <return> :TestLast<cr>
abbreviate <buffer> é <bar>>

nnoremap <silent> K :ExDoc<cr>
let g:alchemist_tag_stack_map = ''

augroup Test
  autocmd!
  autocmd BufEnter *_test.exs
        \ nnoremap <buffer> <leader><return>
        \ :TestFile<cr>
  autocmd BufEnter *_test.exs
        \ nnoremap <buffer> <return>
        \ :TestNearest<cr>
augroup END
let b:neomake_elixir_lint_maker = {}

vnoremap <leader>f :Neoformat "mix format"<cr>
nnoremap <leader>f :Neoformat "mix format"<cr>
