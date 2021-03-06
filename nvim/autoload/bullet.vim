function bullet#config()
  inoremap <buffer> <cr> <esc>:InsertNewBullet<cr>
  inoremap <buffer> <C-cr> <cr>
  nnoremap <buffer> o :InsertNewBullet<cr>
  vnoremap <buffer> gn :RenumberSelection<cr>
  nnoremap <buffer> <leader>x :ToggleCheckbox<cr>
  onoremap <buffer> it :SelectBulletText<cr>
  onoremap <buffer> at :SelectBullet<cr>
endfunction
