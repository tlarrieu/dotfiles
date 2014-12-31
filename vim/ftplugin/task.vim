hi taskWorkingIcon ctermfg=2 gui=italic guifg=#d33682
hi taskWorkingItem ctermfg=2 gui=italic guifg=#d33682
hi taskDoneIcon    ctermfg=1 guifg=#719e07
hi taskDoneItem    ctermfg=1 guifg=#719e07
hi sectionTitle    guifg=#96CBFE guibg=NONE gui=underline ctermfg=4 ctermbg=NONE cterm=underline
hi taskKeyword     ctermfg=5 guifg=Blue guibg=Yellow

noremap <silent> <buffer> <return> :call Toggle_task_status()<cr>
xnoremap <silent> <buffer> <return> :call Toggle_task_status()<cr>gv
nmap <silent> <buffer> <leader><return> vii<return><esc>
