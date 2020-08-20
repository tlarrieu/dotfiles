let g:neoterm_shell = 'rlwrap sbcl'

highlight! lispParen ctermfg=14
highlight! link lispFunc Keyword
highlight! link lispDecl Define

vnoremap <buffer> <cr> :TREPLSendSelection<cr>
nnoremap <buffer> <cr> m`vip:TREPLSendSelection<cr>``
nnoremap <buffer> <leader><cr> :call lisp#test()<cr>

nmap <buffer> <leader>i :call lisp#wrapSExpression()<cr>a
nmap <buffer> dae :call lisp#unwrapSExpression()<cr>
nmap <buffer> cae :call lisp#editSurroundingSExpression()<cr>i
nmap <buffer> cie :call lisp#editSExpression()<cr>a

nnoremap <buffer> <silent> 4 :<C-U>call lisp#findOpening('(',')',0)<CR>
nnoremap <buffer> <silent> 5 :<C-U>call lisp#findClosing('(',')',0)<CR>
vnoremap <buffer> <silent> 4 <Esc>:<C-U>call lisp#findOpening('(',')',1)<CR>
vnoremap <buffer> <silent> 5 <Esc>:<C-U>call lisp#findClosing('(',')',1)<CR>

" Specific to nyxt configuration
" This should not clash with anything but in case of indentation screw-ups,
" we should be smarter about that
setlocal lispwords+=define-command,define-configuration,define-mode

command! -nargs=1 Package call lisp#package(<q-args>)
cnoreabbrev <buffer> <expr> p
  \ getcmdtype() == ":" && getcmdline() == 'p' ? 'Package' : 'p'

augroup Lisp
  autocmd!
  autocmd BufWritePost *.lisp call lisp#loadInREPL(expand('%'))
augroup END

function! lisp#package(package)
  call execute('T (in-package #:' . a:package . ')', "Topen")
endfunction

function! lisp#wrapSExpression()
  call lisp#beginningOfSExpression()
  " Works because of parinfer plugin
  normal i(
endfunction

function! lisp#unwrapSExpression()
  call lisp#beginningOfSExpression()
  normal dab
  call lisp#beginningOfSExpression()
  normal vabp%
endfunction

function! lisp#editSExpression()
  call lisp#beginningOfSExpression()
  normal lciw
endfunction

function! lisp#editSurroundingSExpression()
  call lisp#beginningOfSExpression()
  normal dab
  call lisp#beginningOfSExpression()
  normal vibp%
endfunction

function! lisp#loadInREPL(filename)
  call execute('T (load "' . a:filename . '")', "Topen")
endfunction

function! lisp#test()
  let filename = expand('%:r')

  echom filename

  if (match(filename, '-test$') == -1)
    call lisp#loadInREPL(filename . '-test.lisp')
  else
    call lisp#loadInREPL(filename . '.lisp')
  endif
endfunction

let s:skip_sc = '(synIDattr(synID(line("."), col("."), 0), "name") =~ "[Ss]tring\\|[Cc]omment\\|[Ss]pecial\\|clojureRegexp\\|clojurePattern" || getline(line("."))[col(".")-2] == "\\")'

function! lisp#beginningOfSExpression()
  let curchar = matchstr(getline('.'), '\%' . col('.') . 'c.')
  if (l:curchar != "(" && l:curchar != ")")
    call lisp#findOpening('(',')',0)
  endif
endfunction

function! lisp#findOpening(open, close, select)
  let open  = escape(a:open, '[]')
  let close = escape(a:close, '[]')
  call searchpair(open, '', close, 'bW', s:skip_sc)
  if a:select
    call searchpair(open, '', close, 'W', s:skip_sc)
    let save_ve = &ve
    set ve=all
    normal! lvh
    let &ve = save_ve
    call searchpair(open, '', close, 'bW', s:skip_sc)
    if &selection == 'inclusive'
      " Trim last character from the selection, it will be included anyway
      normal! oho
    endif
  endif
endfunction

function! lisp#findClosing(open, close, select)
  let open  = escape(a:open, '[]')
  let close = escape(a:close, '[]')
  if a:select
    let line = getline('.')
    if line[col('.')-1] != a:open
      normal! h
    endif
    call searchpair(open, '', close, 'W', s:skip_sc)
    call searchpair(open, '', close, 'bW', s:skip_sc)
    normal! v
    call searchpair(open, '', close, 'W', s:skip_sc)
    if &selection != 'inclusive'
      normal! l
    endif
  else
    call searchpair(open, '', close, 'W', s:skip_sc)
  endif
endfunction
