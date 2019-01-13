setlocal textwidth=80
setlocal formatoptions+=t
setlocal foldlevel=1
setlocal foldlevelstart=10

execute 'UltiSnipsAddFiletypes markdown.tex'

let b:deoplete_sources = ['tag', 'buffer', 'file']

augroup MARKDOWN
  autocmd!
  autocmd InsertCharPre *.md if search('\v(%^|[.!?]\_s)\_s*%#', 'bcnw') != 0 | let v:char = toupper(v:char) | endif
augroup END

nnoremap <silent> <buffer> <cr> :T mdprev w '%'<cr>
