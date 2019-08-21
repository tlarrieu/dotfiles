nnoremap <buffer> 6 :YamlGoToKey<space>
nnoremap <buffer> 7 :YamlGoToParent<cr>
nnoremap <buffer> 8 :YamlGetFullPath<cr>

augroup YAML
  autocmd!
  autocmd  BufWritePost package.yaml execute 'silent! close'
augroup END
