function bullet#config()
  let g:bullets_set_mappings = 0
  inoremap <cr> <esc>:InsertNewBullet<cr>
  inoremap <C-cr> <cr>
  nnoremap o :InsertNewBullet<cr>
  vnoremap gn :RenumberSelection<cr>
  nnoremap <leader>x :ToggleCheckbox<cr>
  onoremap it :SelectBulletText<cr>
  onoremap at :SelectBullet<cr>
endfunction
