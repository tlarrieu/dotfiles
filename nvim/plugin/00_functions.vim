" {{{ ==| Folding |=============================================================
function! FoldText()
  let line = getline(v:foldstart)

  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
  return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction
" }}} ==========================================================================

" {{{ ==| Search |==============================================================
" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    set ignorecase
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: OFF'
    return 0
  else
    set noignorecase
    augroup auto_highlight
      au!
      au CursorMoved * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    setl updatetime=200
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction
" }}} ==========================================================================

" {{{ ==| Buffer Handling |=====================================================
function! ClearBuffers()
  silent! bufdo bdelete
  silent! tabdo tabclose
  edit .
endfunction
command! B :call ClearBuffers()

function! DeleteHiddenBuffers()
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  let filter = 'bufexists(v:val) && index(tpbl, v:val) == -1 && match(bufname(v:val), "term://") == -1'
  for buf in filter(range(1, bufnr('$')), filter)
    silent execute 'bwipeout' buf
  endfor
endfunction
command! BD :call DeleteHiddenBuffers()

" Merge a tab into a split in the previous window
function! MergeTabs()
  if tabpagenr() == 1
    return
  endif
  let bufferName = bufname("%")
  if tabpagenr("$") == tabpagenr()
    close!
  else
    close!
    tabprev
  endif
  execute "vs " . bufferName
endfunction

function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
" }}} ==========================================================================

" {{{ ==| Text Manipulation |===================================================
" Enforce UTF8
function! UTF8()
  execute ':set fileencoding=utf8'
  execute ':set fileformat=unix'
  execute ':w'
endfunction
command! UTF8 :call UTF8()

function! ClearTrailingSpaces()
  let l:_s=@/
  %substitute/\v(^\s+$|[\\]\s\zs\s+$|[^\\]\zs\s+$)//e
  let @/=l:_s
  nohl
endfunction
" }}} ==========================================================================

" {{{ ==| align mode |==========================================================
function! AlignMode()
  if &virtualedit ==# 'all'
    setlocal virtualedit=""
  else
    setlocal virtualedit=all
  end
  setlocal cursorcolumn!
  setlocal cursorline!
endfunction
" }}} ==========================================================================
