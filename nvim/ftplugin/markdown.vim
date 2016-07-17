function! RenderMarkdown()
  let filename = expand('%')
  vnew
  call termopen('markfly ' . filename . ' 2> /dev/null')
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

  let path = expand('%:h')
  let filename = expand('%')
  let pdf_name = expand('%:r') . '.pdf'

  let s:callbacks = {
  \   'on_stdout': function('s:PandocSuccess'),
  \   'on_stderr': function('s:PandocError'),
  \   'on_exit': function('s:PandocExit')
  \ }

  call jobstart(
    \['pandoc', '--latex-engine=xelatex', '-s', filename, '-o', pdf_name],
    \extend({'shell': 'shell 2'}, s:callbacks)
  \)
endfunction
command! Pandoc :call Pandoc()

nnoremap <silent> <buffer> <cr> :call RenderMarkdown()<cr>
nnoremap <silent> <buffer> <leader><cr> :call Pandoc()<cr>

setlocal foldlevel=1
setlocal foldlevelstart=10

execute "UltiSnipsAddFiletypes markdown.tex"
