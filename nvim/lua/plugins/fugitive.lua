return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>a', ':Git commit --quiet --amend --no-edit<cr>')
    vim.keymap.set('n', '<leader>A', ':Git commit --quiet --amend<cr>')
    vim.keymap.set('n', '<leader>b', ':Git blame<cr>')
    vim.keymap.set('n', '<leader>c', ':Git commit --quiet<cr>')
    vim.keymap.set('n', '<leader>d', ':Gvdiff<cr>')
    vim.keymap.set('n', '<leader>D', ':Gvdiff master<cr>')
    vim.keymap.set('n', '<leader>ed', ':tab Git diff --staged<cr>')
    vim.keymap.set('n', '<leader>r', ':Gread<cr>')
    vim.keymap.set('n', '<leader>R', ':Git reset %<cr>')
    vim.keymap.set('n', '<leader>s', ':Git<cr>')
    vim.keymap.set('n', '<leader>S', ':GV<cr>')
    vim.keymap.set('x', '<leader>S', ":'<,'>GV<cr>")
    vim.keymap.set('n', '<leader>w', ':Gwrite<cr>')
  end
}
