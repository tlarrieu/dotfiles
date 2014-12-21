function! RangerChooser(starting_directory)
  let temp = tempname()
  exec 'silent !ranger ' . shellescape(a:starting_directory) . ' --choosefiles='
        \ . shellescape(temp)
  if !filereadable(temp)
    redraw!
    " Do nothing if temp file is not readable
    return
  endif
  let names = readfile(temp)
  if empty(names)
    redraw!
    " Do nothing if selection is empty
    return
  endif
  " Edit the first item.
  exec 'edit ' . fnameescape(names[0])
  " Add any remaning items to the arg list/buffer list.
  for name in names[1:]
    exec 'argadd ' . fnameescape(name)
  endfor
  redraw!
endfunction
command! -bar RangerChooser call RangerChooser('%:p:h')
command! -bar RangerChooserRoot call RangerChooser('.')
