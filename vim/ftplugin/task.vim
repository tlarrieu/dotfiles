hi taskWorkingIcon ctermfg=1 guifg=#FF6C60
hi taskWorkingItem ctermfg=1 guifg=#FF6C60
hi taskDoneIcon    ctermfg=2 gui=italic guifg=#80A441
hi taskDoneItem    ctermfg=2 gui=italic guifg=#80A441
hi sectionTitle    guifg=#96CBFE guibg=NONE gui=underline ctermfg=4 ctermbg=NONE cterm=underline
hi taskKeyword     ctermfg=5 guifg=Blue guibg=Yellow

noremap <silent> <buffer> <return> :call Toggle_task_status()<cr>
xnoremap <silent> <buffer> <return> :call Toggle_task_status()<cr>gv
nnoremap <silent> <buffer> <leader><return> vii:call Toggle_task_status()<cr>
