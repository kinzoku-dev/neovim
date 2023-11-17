return {
  'MattesGroeger/vim-bookmarks',
  config = true,
  keys = {
    { '<leader>bt', '<cmd>BookmarkToggle<cr>', desc = 'Toggle bookmark' },
    { '<leader>ba', '<cmd>BookmarkAnnotate<cr>', desc = 'Annotate bookmark' },
    { '<leader>bs', '<cmd>BookmarkShowAll<cr>', desc = 'Show all bookmarks' },
    { '<leader>bn', '<cmd>BookmarkNext<cr>', desc = 'Go to next bookmark' },
    { '<leader>bp', '<cmd>BookmarkPrev<cr>', desc = 'Go to previous bookmark' },
    { '<leader>bc', '<cmd>BookmarkClear<cr>', desc = 'Clear bookmark' },
    { '<leader>bx', '<cmd>BookmarkClearAll<cr>', desc = 'Clear all bookmarks' },
  },
}
