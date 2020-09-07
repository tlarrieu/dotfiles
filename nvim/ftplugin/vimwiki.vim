" All maps are disabled in init.vim
" We thus have to enable those we actually need
nmap <buffer> <cr> <Plug>VimwikiFollowLink
vmap <buffer> <cr> <Plug>VimwikiNormalizeLinkVisualCR
nmap <buffer> <leader><cr> <Plug>VimwikiVSplitLink
nmap <buffer> <backspace> <Plug>VimwikiGoBackLink

nmap <Leader>i <Plug>VimwikiIndex

nmap <buffer> Þ <Plug>VimwikiNextLink
nmap <buffer> ẞ <Plug>VimwikiPrevLink

nmap <buffer> gl <Plug>VimwikiToggleListItem

cnoreabbrev <expr> toc
  \ getcmdtype() == ":" && getcmdline() == 'toc' ? 'VimwikiTOC' : 'toc'
