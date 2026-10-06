vim.schedule(function()
  if not vim.bo.modifiable then return end

  require('conform').format({ async = true }, function(_, did_edit)
    if did_edit then vim.cmd.w('++p') end
  end)
end)
