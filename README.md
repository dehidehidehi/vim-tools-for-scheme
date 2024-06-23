# Vim tools for Scheme

The developper experience for Scheme using vanilla Vim is painful.  
The goal of this repository is to provide a modern developper experience in Vim for making RNRS compliant Scheme applications.  
Specifically R6RS.  

# Solutions 

This repository aims to provide a good developper experience for Scheme:
- reasonable Vim settings tailored to Scheme.
- support for easy procedure discoverability, find what you need without leaving Vim.
- support for documentation pop-ups from within Vim.
- sane and overridable LSP configuration defaults for Scheme.
- a modern LSP experience combining the Racket LSP and the (in development) ChezScheme LSP.
- a remap for the ']' key to automatically close parenthesis or brackets.
- sane and overridable REPL defaults with library path detection using Akku.

# Motivation

Setting up a developping environment for Scheme requires many days of configuration for the developper who just wants to make a program.  

Examples of such overhead include:  
- The little tooling which may exist is difficult to discover.
- The tooling which exists requires far too much time to configure.
- Some tooling is specific to the Scheme language.
- Some tooling is specific to the RNRS standard used.
- ... and last but not least, the developper is forced to develop their own tooling which are usually provided in other more popular languages, which may be demoralizing.

# Installation

## 1. Dependencies 

1. Compile and install with the [Vim compilation script](scripts/vim-compile.sh)
1. Execute the [Akku scheme package manager installation script](scripts/install-akku.sh)

## 2. Adding the vim configuration

1. Copy [vim-tools-for-scheme.vim](lib/vim-tools-for-scheme.vim) to some place on your disk.
1. In your `.vimrc` add `source LOCATION_OF_VIM_TOOLS_FOR_SCHEME`
1. Re-source your `.vimrc`

# Usage

## Default Keybindings

All default mappings are rebindable using, for example:  
```vim
au FileType scheme,racket nnoremap <leader>a	:LspCodeAction<CR>        
```

### Normal mode default keybindings

- `VtfsReplLoad`                -> `<leader>l`  
   Opens your Scheme REPL and evaluates the contents of the buffer into the REPL.
- `VtfsFindMatchingParenType`   -> `]`  
   Automatically closes a statement with the proper closing bracket, parenthesis, etc.  

### Insert mode default keybindings

- `<C-\>`                       -> `λ`  
  Shortcut for inserting the lambda symbol.


### Normal mode LSP default keybindings

- `VtfsLspToggleDiagnostics`    -> `<leader>W`  
  Hides/Unhides the LSP diagnostics which may hinder code readability.

The documentation for the LSP supported commands is available in the [vim-lsp repository](https://github.com/prabirshrestha/vim-lsp?tab=readme-ov-file#supported-commands).  

- `LspCodeAction`                 -> `<leader>a`
- `LspDefinition`                 -> `<leader>D`
- `LspHover`                      -> `<leader>k`
- `LspNextDiagnostic`             -> `<leader>n`
- `LspNextError`                  -> `<leader>e`
- `LspPeekDefinition`             -> `<leader>d`
- `LspPreviousDiagnostic`         -> `<leader>p`
- `LspPreviousError`              -> `<leader>E`
- `LspReferences`                 -> `<leader>b`
- `LspRename`                     -> `<leader>r`

# Credits

- Vim Plugin        vim/simpl                   [https://github.com/benknoble/vim-simpl](https://github.com/benknoble/vim-simpl)
- Function          VtfsToggleLspDiagnostics        [https://github.com/prabirshrestha/vim-lsp/issues/1312](https://github.com/prabirshrestha/vim-lsp/issues/1312)
- Function          VtfsFindMatchingParen           [https://gist.github.com/plane/8c872ed174ba4f026b95ea8eb934cead](https://gist.github.com/plane/8c872ed174ba4f026b95ea8eb934cead)
                                                                                                                                                                                                                    et parens += [right]
# References

 - [The Scheme Index](https://index.scheme.org) ([repository](https://github.com/schemeorg-community/index.scheme.org])) : The Scheme index allows searching for Scheme procedures, syntax and constants through types, tags, and names.
- [Building Vim from source](https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source)
- [Compiling Vim](https://richrose.dev/posts/linux/vim/vim-compile/)

# TODO list

1. [ ] Make vimscript suggest installation of the Akku package manager if Akku is not detected on the system.
1. [ ] Make vimscript execute `LspInstallServer racket-lsp` if the `racket-lsp` is not installed.
1. [ ] Provide build scripts and LSP configuration for `scheme-langserver`
1. [ ] Convert to a proper Vim plugin.
1. [ ] Provide functions and keybindings for RNRS documentation pop-ups from within Vim.
1. [ ] Document then allow redefinition of the following configuration variables:  
```vim
let g:vtfs_my_vimrc = expand($MYVIMRC)
au FileType Scheme,Racket let g:vtfs_repl_cols = 50
au FileType Scheme,Racket let g:vtfs_repl_rows = 12
au FileType Scheme let g:vtfs_lsp_chez_scheme_multithread = 1
au FileType Scheme let g:vtfs_lsp_chez_scheme_type_inference = 1
```
