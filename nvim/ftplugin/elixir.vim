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
  autocmd BufWrite *.exs,*.ex silent! undojoin | Neoformat! elixir
augroup END
let b:neomake_elixir_lint_maker = {}

let b:fzf_tags_config = {
  \   'module': { 'identifiers': ['m', 'r'], 'prompt': 'mod' },
  \   'function': { 'identifiers': ['f', 'o'], 'prompt': 'op' }
  \ }
nnoremap <silent> <c-c> :FZFtags module<cr>
nnoremap <silent> <c-l> :FZFtags function<cr>
