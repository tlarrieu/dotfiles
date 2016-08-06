" {{{ ==| Git files |===========================================================
function! s:git_files_sink(e)
  if len(a:e) < 2 | return | endif
  let key = a:e[0]
  let lines = a:e[1:]

  if key == 'ctrl-r'
    let files = map(lines, 'split(v:val, " ")[1]')
    execute 'call jobstart("git checkout -- ' . join(files, ' ') . '")'
    return
  endif

  let cmd = get({
    \ 'ctrl-x': 'new',
    \ 'ctrl-v': 'vnew',
    \ 'ctrl-t': 'tabnew',
    \ }, key, 'e')

  for buf in map(lines, 'split(v:val, " ")[-1]')
    execute cmd . ' ' . buf
  endfor
endfunction

command! FZFGitFiles call fzf#run({
  \ 'source': 'git -c color.status=always status --short',
  \ 'sink*': function('<sid>git_files_sink'),
  \ 'options': '--expect=ctrl-t,ctrl-v,ctrl-x,ctrl-r --ansi --multi --prompt "git?> "',
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

function! s:buf_sink(e)
  if len(a:e) < 2 | return | endif
  let key = a:e[0]
  let lines = a:e[1:]

  let cmd = get({
    \ 'ctrl-x': 'split|buffer',
    \ 'ctrl-v': 'vertical split|buffer',
    \ 'ctrl-t': 'tab split|buffer',
    \ 'ctrl-d': 'bdelete!'
    \ }, key, 'buffer')

  for buf in map(lines, 'split(v:val, " ")[0]')
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
function! s:search_sink(e)
  if len(a:) < 2 | return | endif

  let key = a:e[0]
  let cmd = get({
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vertical split',
    \ 'ctrl-t': 'tabe'
    \ }, key, 'e')

  let lines = a:e[1:]
  for line in map(lines, 'split(v:val, " ")[0]')
    let [file, line, column] = split(line, ':')[0:2]
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
function! s:tags_sink(e)
  if len(a:e) < 2 | return | endif

  let key = a:e[0]
  let taglines = a:e[1:]

  let cmd = get({
    \ 'ctrl-x': 'new',
    \ 'ctrl-v': 'vnew',
    \ 'ctrl-t': 'tabnew',
    \ }, key, 'e')

  let [magic, &magic] = [&magic, 0]
  for tagline in taglines
    let parts = split(l:tagline, '\t\zs')
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
