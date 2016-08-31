function! s:getcmd(key)
  return get({
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vertical split',
    \ 'ctrl-t': 'tab split',
    \ }, a:key, 'edit')
endfunction

" {{{ ==| Git files |===========================================================
function! s:git_files_sink(input)
  if len(a:input) < 2 | return | endif

  let key = a:input[0]
  let cmd = s:getcmd(key)

  let entries = a:input[1:]
  for entry in entries
    let filename = split(entry)[-1]
    execute 'silent ' . cmd . ' ' . filename
  endfor
endfunction

command! FZFGitFiles call fzf#run({
  \ 'source': 'git -c color.status=always status --short',
  \ 'sink*': function('<sid>git_files_sink'),
  \ 'options': '--expect=ctrl-t,ctrl-v,ctrl-x --ansi --multi --prompt "git?> "',
  \ 'down': 10
  \})
" }}}
" {{{ ==| Buffers |=============================================================
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:buf_sink(input)
  if len(a:input) < 2 | return | endif

  let key = a:input[0]
  let cmd = get({
    \ 'ctrl-x': 'split|buffer',
    \ 'ctrl-v': 'vertical split|buffer',
    \ 'ctrl-t': 'tab split|buffer',
    \ 'ctrl-d': 'bdelete!'
    \ }, key, 'buffer')

  let entries = a:input[1:]
  for entry in entries
    let buf = split(entry)[0]
    execute cmd . ' ' . buf
  endfor
endfunction

command! FZFbuf call fzf#run({
  \   'source':  reverse(<sid>buflist()),
  \   'sink*':    function('<sid>buf_sink'),
  \   'options': '--expect=ctrl-t,ctrl-v,ctrl-x,ctrl-d --multi',
  \   'down':    len(<sid>buflist()) + 2
  \ })
" }}}
" {{{ ==| Search |==============================================================
function! s:search_sink(input)
  if len(a:) < 2 | return | endif

  let key = a:input[0]
  let cmd = s:getcmd(key)

  let entries = a:input[1:]
  for entry in entries
    let entry = split(entry)[0]
    let [file, line, column] = split(entry, ':')[0:2]
    execute cmd escape(file, ' %#\')
    call cursor(line, column)
    normal zz
  endfor
endfunction

command! -nargs=1 FZFsearch call fzf#run({
  \ 'source': 'ag -i --nogroup --column "' . escape(<q-args>, '"\') . '"',
  \ 'sink*': function('<sid>search_sink'),
  \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --color hl:68,hl+:110 -e --multi',
  \ 'down': '50%'
  \ })
" }}}
" {{{ ==| Tags |================================================================
function! s:tags_sink(input)
  if len(a:input) < 2 | return | endif

  let key = a:input[0]
  let cmd = s:getcmd(key)

  let entries = a:input[1:]
  let [magic, &magic] = [&magic, 0]
  for entry in entries
    let parts = split(entry, '\t\zs')
    let filename = parts[1][:-2]
    let pattern = matchstr(parts[2], '^.*\ze;"\t')

    execute 'silent ' . cmd . ' ' . l:filename
    execute pattern
  endfor
  let &magic = magic
endfunction

function! s:fzf_tags(kind)
  let tagfiles = tagfiles()

  if empty(tagfiles)
    echohl WarningMsg
    echom 'No tagfile found. Please run ctags first.'
    echohl None
    return
  endif

  let grepcmd = ' | grep -P '
  let prompt = ''
  if a:kind == 'function'
    let grepcmd .= '"\t[fF]($|\t)"'
    let prompt = 'func'
  else
    if a:kind == 'class'
      let grepcmd .= '"\t[cm]($|\t)"'
      let prompt = 'class'
    else
      let grepcmd = ''
      let prompt = 'tags'
    endif
  endif

  call fzf#run({
    \ 'source': 'cat '.join(map(tagfiles, 'fnamemodify(v:val, ":S")')) .
    \           '| grep -v ^! ' . grepcmd,
    \ 'options': '-d "\t" --with-nth 1,2,4.. --nth 1 --tiebreak=index ' .
    \            '--expect=ctrl-t,ctrl-v,ctrl-x --multi --ansi ' .
    \            '--prompt "' . prompt . '?> " -0 --exact',
    \ 'down': '50%',
    \ 'sink*': function('s:tags_sink')})
endfunction

command! -nargs=1 FZFtags call <sid>fzf_tags(<f-args>)
" }}}
