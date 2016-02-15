" File: calcium.vim
" Author: Thomas Larrieu (thomas DOT larrieu AT gmail DOT com)
" Version: 1.0
" Last Modified: Jan 18, 2014
"
if exists('loaded_calcium') || &cp
    finish
endif
let loaded_calcium=1

let CalciumLogBufferName = "__Calcium_Log__"

" CalciumTabOpen
"   Open the calcium buffer
function! s:CalciumLogOpen(cmd)
  if bufexists(g:CalciumLogBufferName)
    exe "bdelete! " . g:CalciumLogBufferName
  end
  exe "tab sview " . g:CalciumLogBufferName
  silent exe ".!" . a:cmd
endfunc

let CalciumDiffBufferName = "__Calcium_Diff__"
function! s:CalciumDiffOpen(cmd)
  if bufexists(g:CalciumDiffBufferName)
    exe "bdelete! " . g:CalciumDiffBufferName
  end
  exe "vert sview " . g:CalciumDiffBufferName
  silent exe ".!" . a:cmd
endfunc

" CalciumMarkBuffer
"   Mark a buffer as calcium
function! s:CalciumMarkBuffer(type)
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal nolist
    setlocal readonly
    setlocal noswapfile
    setlocal buflisted
    setlocal nowrap
    if a:type == 0
      nmap <silent> <buffer> o xiw
      nnoremap <silent> <buffer> x :silent set operatorfunc=GrepOperator<cr>g@
      vnoremap <silent> <buffer> x :silent <c-u>call GrepOperator(visualmode())<cr>
    else
      setlocal ft=diff
    end
    noremap <silent> <buffer> <Tab> <C-w>w
    noremap <buffer> q :q<CR>
endfunction

autocmd BufNewFile __Calcium_Log__ call s:CalciumMarkBuffer(0)
autocmd BufNewFile __Calcium_Diff__ call s:CalciumMarkBuffer(1)

command! -nargs=0 CalciumLog call s:CalciumLogOpen("hg log -g --graph --git -b `hg branch`")

function! GrepOperator(type)
    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    call s:CalciumDiffOpen("hg log -p -X '**.csv' -X '**.tsv' -X '**.json' -r " . shellescape(@@))
endfunction

