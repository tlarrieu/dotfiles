local bootstrap = function()
  local luasnip = require('luasnip')
  -- Index all snippets for filetypes
  local xs = {}
  for ft in vim.o.filetype:gmatch("([^.]+)") do
    for _, item in pairs(luasnip.available()[ft] or {}) do
      xs[item.name] = true
    end
  end

  -- query projectionist
  local skeleton = (vim.fn['projectionist#query']('skeleton')[1] or {})[2]
  local found = skeleton ~= nil
  if found then skeleton = '__' .. skeleton end

  if skeleton and not xs[skeleton] then
    vim.notify(
      'Skeleton "' .. skeleton .. '" not found for filetype "' .. vim.o.filetype .. '"',
      vim.log.levels.WARN,
      { title = "skeleton.lua" }
    )
    return false
  end

  skeleton = skeleton or "__skel"

  if not xs[skeleton] then return false end

  -- NOTE: skeletons have to be in the auto expand section of the snippet file
  -- I could not find a way to make it work cleanly in all situation by triggering
  -- the snippet manually (with vim.api.nvim_input)
  vim.cmd.startinsert()
  vim.api.nvim_feedkeys(skeleton, "insert", true)

  return true
end

vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*',
  -- NOTE: for some reason, passing a closure only works for the first file
  -- opened. After this, it does not seem to be triggering anymore
  callback = function() bootstrap() end,
  group = vim.api.nvim_create_augroup("luasnip_hooks", {})
})
