setlocal formatoptions+=t

function! RenderMarkdown()
  let l:filename = expand('%')
  vnew
  call termopen('markfly ' . l:filename . ' 2> /dev/null')
  execute "normal! \<c-w>p"
endfunction

function! s:WriteToLocationList(msg)
  laddexpr a:msg
  lopen
  execute "normal \<c-w>p"
endfunction

function! s:PandocSuccess(job_id, data)
  call s:WriteToLocationList('Pandoc stdout: ' . join(a:data))
endfunction

function! s:PandocError(job_id, data)
  call s:WriteToLocationList('Pandoc stderr: ' . join(a:data))
endfunction

function! s:PandocExit(job_id, data)
  echo 'Done.'
endfunction

function! Pandoc()
  lexpr ''
  lclose

  let l:filename = expand('%')
  let l:pdf_name = expand('%:r') . '.pdf'

  let s:callbacks = {
  \   'on_stdout': function('s:PandocSuccess'),
  \   'on_stderr': function('s:PandocError'),
  \   'on_exit': function('s:PandocExit')
  \ }

  call jobstart(
    \['pandoc', '--latex-engine=xelatex', '-s', l:filename, '-o', l:pdf_name],
    \extend({'shell': 'shell 2'}, s:callbacks)
  \)
endfunction
command! Pandoc :call Pandoc()

nnoremap <silent> <buffer> <cr> :call RenderMarkdown()<cr>
nnoremap <silent> <buffer> <leader><cr> :call Pandoc()<cr>

setlocal foldlevel=1
setlocal foldlevelstart=10

execute 'UltiSnipsAddFiletypes markdown.tex'

let b:deoplete_sources = ['tag', 'buffer', 'file']

augroup MARKDOWN
  autocmd!
  autocmd InsertCharPre *.md if search('\v(%^|[.!?]\_s)\_s*%#', 'bcnw') != 0 | let v:char = toupper(v:char) | endif
augroup END
