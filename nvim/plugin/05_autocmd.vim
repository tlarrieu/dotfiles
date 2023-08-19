" {{{ ==| File Related |========================================================
augroup vimrc_autocmd
  autocmd!
  "Go to the cursor position before buffer was closed
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif"`""'")
  autocmd BufWritePost * call UpdateTags()
  " Don't add the comment prefix when I hit enter or o/O on a comment line.
  autocmd FileType * setlocal formatoptions-=o formatoptions-=r
  " Don't screw up folds when inserting text that might affect them, until
  " leaving insert mode. Foldmethod is local to the window.
  autocmd Bufenter * let w:last_fdm=&foldmethod
  autocmd InsertEnter * let w:last_fdm=&foldmethod | setlocal foldmethod=manual
  autocmd InsertLeave * let &l:foldmethod=w:last_fdm
augroup END

augroup NoSimultaneousEdits
  autocmd!
  autocmd SwapExists * let v:swapchoice = 'o'
  autocmd SwapExists * echomsg 'Duplicate edit session (readonly)'
  autocmd SwapExists * echohl None
  autocmd SwapExists * sleep 1
augroup END
" }}}

" {{{ ==| General options |=====================================================
function! Autosize()
  let l:tabnr = tabpagenr()
  tabdo normal! =
  exec "normal! " . l:tabnr . "gt"
endfunction

augroup dimensions
  autocmd!
  " autoreflow splits upon changing nvim size (most often happens when tiling
  " windows)
  autocmd VimResized * call Autosize()
augroup END
" }}}
