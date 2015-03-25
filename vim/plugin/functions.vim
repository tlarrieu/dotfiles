function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

" {{{ == | Tags | " ============================================================

function! DelTagOfFile(file)
  let fullpath = a:file
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"
  let f = substitute(fullpath, cwd . "/", "", "")
  let f = escape(f, './')
  let cmd = 'sed -i "/' . f . '/d" "' . tagfilename . '"'
  let resp = system(cmd)
endfunction

function! UpdateTags()
  let f = expand("%:p")
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"

  if filereadable(tagfilename)
    let cmd = 'ctags -a -f ' . tagfilename . ' "' . f . '"'
    call DelTagOfFile(f)
    let resp = system(cmd)
  endif
endfunction

" }}} ==========================================================================

" {{{ == | Folding | ===========================================================

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

" {{{ == | Search | ============================================================

" Those 2 functions should be refactored into a single one
function! UsageOperator(type)
  let saved_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif

  silent execute "Ag! " . shellescape(@@) . " . \| grep -v def"

  let @@ = saved_register
endfunction

function! DefinitionOperator(type)
  let saved_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif

  silent execute "Ag! " . shellescape('(def (self.)?|class )' . @@) . " ."

  let @@ = saved_register
endfunction

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

" {{{ == | Buffer Handling | ===================================================

function! DeleteHiddenBuffers()
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    silent execute 'bwipeout' buf
  endfor
endfunction

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

" Unmerge a split into a new tab
function! UnmergeWindow()
  let bufferName = bufname("%")
  close!
  execute "tabe " . bufferName
endfunction

" Mark a split to be swapped
function! MarkSplitSwap()
  let g:markedWinNum = winnr()
endfunction

" Split swap
function! DoSplitSwap()
  "Mark destination
  let curNum = winnr()
  let curBuf = bufnr( "%" )
  exe g:markedWinNum . "wincmd w"
  "Switch to source and shuffle dest->source
  let markedBuf = bufnr( "%" )
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' curBuf
  "Switch to dest and shuffle source->dest
  exe curNum . "wincmd w"
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' markedBuf
endfunction

" Mark or split, depending on if any split has been marked
function! SplitSwap()
  if exists("g:markedWinNum")
    silent call DoSplitSwap()
    unlet g:markedWinNum
  else
    silent call MarkSplitSwap()
  end
endfunction

function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

function! ToggleFullSizeSplit()
  if exists('b:last_width')
    let widthResult = b:last_width
    unlet b:last_width
  else
    let b:last_width = winwidth(0)
    let maxWidth = max(map(getline(1,'$'), 'len(v:val)'))
    let g:blarghmatey#expandWidth#defaultMaxWidth = 200
    let widthResult = min([ ( maxWidth + 5 ), g:blarghmatey#expandWidth#defaultMaxWidth ])
  endif

  if exists('b:last_height')
    let heightResult = b:last_height
    unlet b:last_height
  else
    let b:last_height = winheight(0)
    let fileLength = line('$') + 2
    let maxHeight = &lines
    let heightResult = min([maxHeight, fileLength])
    if exists('g:blarghmatey#expandHeight#heightLimit')
      let heightLimit = g:blarghmatey#expandHeight#heightLimit
      let heightResult = min([heightResult, heightLimit])
    endif
  endif

  execute 'vertical resize ' . widthResult
  execute 'resize ' . heightResult
endfunction

" }}} ==========================================================================

" {{{ == |  Text Manipulation | ================================================

" This function extracts a pattern from the whole buffer and replaces it
" with a line for each match on a single line
function! Extract()
  let @z=""
  %s//\=setreg('Z', submatch(0), 'l')/g
  %d _
  pu z
  0d _
endfunction
command! Extract silent call Extract()

function! DeleteBloc(start, end)
  let tmp=@z
  let @z=''
  exec ':g/'.a:start.'\_.\{-}'.a:end.'.*\n$/normal! v/'.a:end.'$"Zd'
  let @"=@z
  let @z=tmp
endfunction
command! -nargs=+ DelBloc call call(function('DeleteBloc'), split(<q-args>, '\s\(\S\+\s*$\)\@='))

" Enforce UTF8
function! UTF8()
  execute ':set fileencoding=utf8'
  execute ':set fileformat=unix'
  execute ':w'
endfunction
command! UTF8 :call UTF8()

" Convert Rails interpolated variable to Mailchimp format
function! ToMailchimp()
  :%s/<%= \?\(.\{-}\) \?%>/*|\1|*/g
endfunction
command! Mailchimp :silent call ToMailchimp()

" Convert Rails interpolated variable to Handlebar format
function! ToMustach()
  :%s/<%= \?\(.\{-}\) \?%>/\{\{\1}}/g
endfunction
command! Mustach :silent call ToMustach()

function! ClearRegisters()
  let regs='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-="*+'
  let i=0
  while (i<strlen(regs))
    exec 'let @'.regs[i].'=""'
    let i=i+1
  endwhile
endfunction
command! ClearRegisters call ClearRegisters()

function! Redir(command)
  redir! >/tmp/vim_redir
  silent exec a:command
  redir END
  r /tmp/vim_redir
endfunction
command! -nargs=1 R call Redir(<q-args>)

" }}} ==========================================================================
