setlocal updatetime=60000
setlocal foldmethod=marker
setlocal foldclose=all
setlocal foldopen=insert

" Tell the GnuPG plugin to armor new files.
let g:GPGPreferArmor=1

" Tell the GnuPG plugin to sign new files.
let g:GPGPreferSign=1

augroup GnuPGExtra
  autocmd!
  " Automatically close unmodified files after inactivity.
  autocmd CursorHold *.\(gpg\|asc\|pgp\) quit
augroup END
