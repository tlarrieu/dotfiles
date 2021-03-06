setlocal textwidth=130
setlocal formatoptions+=t
setlocal foldlevel=1
setlocal foldlevelstart=10
setlocal spell
setlocal conceallevel=2

let b:deoplete_sources = ['tag', 'buffer', 'file']
let b:switch_custom_definitions = [[ '- [ ]', '- [X]' ]]

augroup MARKDOWN
  autocmd!
  autocmd InsertCharPre *.md if search('\v(%^|[.!?]\_s)\_s*%#', 'bcnw') != 0 | let v:char = toupper(v:char) | endif
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
