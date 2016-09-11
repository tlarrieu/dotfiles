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

  let l:key = a:input[0]
  let l:cmd = s:getcmd(l:key)

  let l:entries = a:input[1:]
  for l:entry in l:entries
    let l:filename = split(l:entry)[-1]
    execute 'silent ' . l:cmd . ' ' . l:filename
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
  redir => l:ls
  silent ls
  redir END
  return split(l:ls, '\n')
endfunction

function! s:buf_sink(input)
  if len(a:input) < 2 | return | endif

  let l:key = a:input[0]
  let l:cmd = get({
    \ 'ctrl-x': 'split|buffer',
    \ 'ctrl-v': 'vertical split|buffer',
    \ 'ctrl-t': 'tab split|buffer',
    \ 'ctrl-d': 'bdelete!'
    \ }, l:key, 'buffer')

  let l:entries = a:input[1:]
  for l:entry in l:entries
    let l:buf = split(l:entry)[0]
    execute l:cmd . ' ' . l:buf
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

  let l:key = a:input[0]
  let l:cmd = s:getcmd(l:key)

  let l:entries = a:input[1:]
  for l:entry in l:entries
    let l:entry = split(l:entry)[0]
    let [l:file, l:line, l:column] = split(l:entry, ':')[0:2]
    execute l:cmd escape(l:file, ' %#\')
    call cursor(l:line, l:column)
    normal zz
  endfor
endfunction

command! -nargs=1 FZFsearch call fzf#run({
  \ 'source': 'ag -i --nogroup --column "' . escape(<q-args>, '"\') . '"',
  \ 'sink*': function('<sid>search_sink'),
  \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x -e --multi',
  \ 'down': '50%'
  \ })
" }}}
" {{{ ==| Tags |================================================================
function! s:tags_sink(input)
  if len(a:input) < 2 | return | endif

  let l:key = a:input[0]
  let l:cmd = s:getcmd(l:key)

  let l:entries = a:input[1:]
  let [l:magic, &magic] = [&magic, 0]
  for l:entry in l:entries
    let l:parts = split(l:entry, '\t\zs')
    let l:filename = l:parts[1][:-2]
    let l:pattern = matchstr(l:parts[2], '^.*\ze;"\t')

    execute 'silent ' . l:cmd . ' ' . l:filename
    execute l:pattern
  endfor
  let &magic = l:magic
endfunction

let s:fzf_tags_config = {
  \   'class': { 'identifiers': ['c', 'm'], 'prompt': 'class' },
  \   'function': { 'identifiers': ['f', 'F'], 'prompt': 'func' }
  \ }

function! s:fzf_tags_cmd(kind)
  let l:fzf_tags_config = {}
  if exists('b:fzf_tags_config')
    let l:fzf_tags_config = b:fzf_tags_config
  else
    let l:fzf_tags_config = s:fzf_tags_config
  end

  let l:cfg = get(
    \   l:fzf_tags_config,
    \   a:kind,
    \   { 'prompt': 'tags', 'identifiers': [] }
    \ )

  if empty(l:cfg['identifiers'])
    return [l:cfg['prompt'], '']
  endif

  let l:identifiers = join(l:cfg['identifiers'])
  let l:grepcmd = ' | grep -P "\t[' . l:identifiers . ']($|\t)"'

  return [l:cfg['prompt'], l:grepcmd]
endfunction

function! s:fzf_tags(kind)
  let l:tagfiles = tagfiles()

  if empty(l:tagfiles)
    echohl WarningMsg
    echom 'No tagfile found. Please run ctags first.'
    echohl None
    return
  endif

  let [l:prompt, l:grepcmd] = s:fzf_tags_cmd(a:kind)

  call fzf#run({
    \ 'source': 'cat '.join(map(l:tagfiles, 'fnamemodify(v:val, ":S")')) .
    \           '| grep -v ^! ' . l:grepcmd,
    \ 'options': '-d "\t" --with-nth 1,2,4.. --nth 1 --tiebreak=index ' .
    \            '--expect=ctrl-t,ctrl-v,ctrl-x --multi --ansi ' .
    \            '--prompt "' . l:prompt . '?> " -0 --exact',
    \ 'down': '50%',
    \ 'sink*': function('s:tags_sink')})
endfunction

command! -nargs=1 FZFtags call <sid>fzf_tags(<f-args>)
" }}}
