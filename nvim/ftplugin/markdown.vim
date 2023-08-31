setlocal textwidth=130
setlocal formatoptions+=t
setlocal foldlevel=1
setlocal foldlevelstart=10
setlocal spell
setlocal concealcursor=ncv
setlocal conceallevel=2

nnoremap <silent> <leader>i :call ToggleConceal()<cr>
function! ToggleConceal()
  if &conceallevel == 2
    setlocal conceallevel=0
  else
    setlocal conceallevel=2
  end
endfunction

let b:deoplete_sources = ['tag', 'buffer', 'file']
let b:switch_custom_definitions = [[ '- [ ]', '- [X]' ]]

augroup MARKDOWN
  autocmd!
  autocmd InsertCharPre *.md call helpers#Capitalize()
  autocmd InsertLeave * setlocal conceallevel=2
augroup END

nnoremap <silent> <buffer> <cr> :T mdprev w '%'<cr>

call bullet#config()

let b:sql_comment = '```'
call sql#configure()

nmap <silent> <buffer> <leader>$ vip:ExecuteSQL<cr>
vmap <silent> <buffer> <leader>$ :'<,'>ExecuteSQL<cr>

vmap <buffer> <leader>b S*gvS*eee
vmap <buffer> <leader>i S*ee
vmap <buffer> <leader>s S~gvS~eee

function! Review()
  let date = strftime("%Y-%m-%d")
  let entry = "# [" . l:date . "](" . l:date . ")"
  keepjumps execute "normal! ggO" . l:entry . "\<esc>"
endfunction

command!
  \ -buffer
  \ Review
  \ call Review()

cnoreabbrev <expr> rev
  \ getcmdtype() == ":" && getcmdline() == 'rev' ? 'Review' : 'rev'
