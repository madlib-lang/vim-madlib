`vim-madlib` is a plugin for madlib written in VimScript. It is still very much a work-in-progress plugin. It provides syntax highlighting (but not yet perfect syntax highlighting) and should make working with Madlib in vim less painful.

Work is largely paused on this effort; the future plan is to move this plugin into Lua and design for usage within NeoVim (this plugin works with NeoVim but if you have a mixed Lua / VimScript configuration it is slightly painful).

## Usage with vim-plug

```
Plug 'madlib-lang/vim-madlib'
```

## Auto-format on save

This passes the current file to madlib format via `exec`:

```vimscript
function! MadlibFormat()
  let l:view = winsaveview()
  exec "%! xargs -J{} -0 madlib format --text {}"
  if v:shell_error != 0
    undo
  endif
  call winrestview(l:view)
endfunction

autocmd BufWritePre *.mad call MadlibFormat()
```

## Recommended Additional Plugins:

* [vim-commentary](https://github.com/tpope/vim-commentary) - This adds comment toggling behavior. Add `autocmd FileType madlib setlocal commentstring=//\ %s` for single-line comments
