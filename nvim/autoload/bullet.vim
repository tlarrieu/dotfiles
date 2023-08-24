function bullet#config()
  inoremap <silent> <buffer> <cr> <esc>:InsertNewBullet<cr>
  inoremap <silent> <buffer> <C-cr> <cr>
  nnoremap <silent> <buffer> o :InsertNewBullet<cr>
  vnoremap <silent> <buffer> gn :RenumberSelection<cr>
  nnoremap <silent> <buffer> <leader>x :ToggleCheckbox<cr>
  onoremap <silent> <buffer> it :SelectBulletText<cr>
  onoremap <silent> <buffer> at :SelectBullet<cr>
endfunction
