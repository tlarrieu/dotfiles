setlocal conceallevel=2
setlocal concealcursor=cni

nnoremap <buffer> <return> :call neoterm#test#rerun()<cr>
abbreviate <buffer> p <bar>>
inoremap <buffer> . .<esc>bvUf.a

nnoremap <silent> K :ExDoc<cr>
let g:alchemist_tag_stack_map = ''

augroup Test
  autocmd!
  autocmd BufEnter *_test.exs
        \ nnoremap <buffer> <leader><return>
        \ :call neoterm#test#run('file')<cr>
  autocmd BufEnter *_test.exs
        \ nnoremap <buffer> <return>
        \ :call neoterm#test#run('current')<cr>
augroup END

let b:fzf_tags_config = {
  \   'module': { 'identifiers': ['m', 'r'], 'prompt': 'mod' },
  \   'function': { 'identifiers': ['f', 'o'], 'prompt': 'op' }
  \ }
nnoremap <silent> <c-c> :FZFtags module<cr>
nnoremap <silent> <c-l> :FZFtags function<cr>
