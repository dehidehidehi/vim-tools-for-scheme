# Vim tools for Scheme

The developper experience for Scheme using vanilla Vim is painful.  
The goal of this repository is to provide a modern developper experience in Vim for making RNRS compliant Scheme applications.  
Specifically R6RS.  

# Solutions 

This repository aims to provide a good developper experience for Scheme:
- [x] reasonable Vim settings tailored to Scheme.
- [x] sane and overridable LSP configuration defaults for Scheme.
- [x] a modern LSP experience combining the Racket LSP and the (in development) ChezScheme LSP.
- [x] a remap for the ']' key to automatically close parenthesis or brackets.
- [x] sane and overridable REPL defaults with library path detection using Akku.
- [ ] support for easy procedure discoverability, find what you need without leaving Vim.
- [ ] support for documentation pop-ups from within Vim.

# Motivation

Setting up a developping environment for Scheme requires many days of configuration for the developper who just wants to make a program.  

Examples of such overhead include:  
- The little tooling which may exist is difficult to discover.
- The tooling which exists requires far too much time to configure.
- Some tooling is specific to the Scheme language.
- Some tooling is specific to the RNRS standard used.
- ... and last but not least, the developper is forced to develop their own tooling which are usually provided in other more popular languages, which may be demoralizing.

# Installation

## 1. Plugin

Install this plugin using your plugin manager of choice.  
Depending on which plugins you have installed this plugins will have more or less features enabled.  
For a full range of functionality you should install all the following plugins.  

Here is an example using the `vim-plug` manager.

```
call plug#begin()
    " Required
    Plug 'dehidehidehi/vim-tools-for-scheme'

    " Recommended for full functionality of `vim-tools-for-scheme` plugin
    Plug 'airblade/vim-rooter'
    Plug 'dehidehidehi/vim-simpl', { 'branch': 'improvement/allow-do-load-to-pass-more-terminal-options' }
    Plug 'honza/vim-snippets'
    Plug 'mattn/vim-lsp-settings'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'sirver/ultisnips'
call plug#end()
packloadall
```

## 2. Dependencies 

### Optional : Akku 

It is recommended you install Akku, the Scheme library manager.  
You will benefit from neat REPL utilities and library loading.  
If Akku is not found on your system path, these functionalities are disabled.  

1. Execute the [Akku scheme package manager installation script](scripts/install-akku.sh)

### Optional : scheme-langserver

To benefit from the `scheme-langserver`, you [should `build` and install it](https://github.com/ufo5260987423/scheme-langserver?tab=readme-ov-file#building).  
Do note that I got it to compile properly on my system using the following command, which is slightly different than the one listed in the build instructions form the scheme-langserver repository.  
Specifically, I had to specify the parameter `--kernelobj`.  
```zsh
./configure --threads --kernelobj --enable-libffi --installdoc=$HOME/.cache/chez-scheme/docs --installprefix=/usr/.local
```

Building `chez-scheme` then building `scheme-langserver` isn't the easiest task, given the documentation is not the clearest.  
For now I have provided an [ansible script which details how I have automated this process](scripts/install-chez-scheme-and-langserver.yml).  
I have yet to convert this to a pure `shell` script, but I hope it will give you guidance.

## 3. Testing if it works for you

Let's load this plugin using a minimized .vimrc configuration.  

### Testing Vanilla

First `cd` into the root of this repository after having cloned it.

```zsh
vim -u test/test-vimrc.vim test/test-scheme-file.sps
```

This should open a vim buffer with a Scheme `Hello world` program.  
Try using the `<leader>l` remap to execute the program in a REPL buffer :)  
You should be prompted to install the Racket LSP.  
You should be able to see syntax highlighting provided by the LSP.

### Testing with the Akku package manager

First `cd` into the root of this repository after having cloned it.

```zsh
akku init test-with-akku
cd test-with-akku
akku install
.akku/env
```

Then
```zsh
cd ..
vim -u test/test-vimrc.vim test-with-akku/test-with-akku.sls
```

This should open a vim buffer with a Scheme `Hello world` program.  
This also happens to load the buffer with a Scheme library path, managed by Akku.  
You should be prompted to install the Racket LSP.  
You should be able to see syntax highlighting provided by the LSP.

Try using the `<leader>l` remap to execute the program in a REPL buffer :)   
You should see the REPL appear, now let's try to execute the `hello` procedure defined by default in the newly created Akku package.  
In the REPL, type:
```scheme
(import (test-with-akku))
(hello "world")
```
This should output `"Hello world!"`.  

Try installing a package using the shell command `akku install <package>`, then importing and using it in the REPL :)

# Usage

## Default Keybindings

The documentation for the LSP supported commands is available in the [vim-lsp repository](https://github.com/prabirshrestha/vim-lsp?tab=readme-ov-file#supported-commands).    

The bindings will not clobber your own vimrc configurations.  

| **Action**                                | default bindings / rebind with                                         |
|-------------------------------------------|------------------------------------------------------------------------|
| Insert the λ symbol                       | `inoremap <buffer> <unique> <C-\> <Plug>VtfsInsertLambdaSymbol;`       |
| Open Netrw at project root                | `nnoremap <buffer> <unique> <C-n> <Plug>VtfsNetrwEx;`                  |
| Autoclose bracket with appropriate symbol | `silent inoremap <buffer> <unique> ] <Plug>VtfsFindMatchingParenType;` |
| Load into the REPL                        | `silent nnoremap <buffer> <LocalLeader>l    <Plug>VtfsReplLoad;`       |
| Toggle LSP virtual text                   | `nnoremap <buffer> <LocalLeader>W    <Plug>VtfsLspToggleDiagnostics;`  |
| LspCodeAction                             | `nnoremap <buffer> <LocalLeader>a	<Plug>VtfsLspCodeAction;`          |
| LspReferences                             | `nnoremap <buffer> <LocalLeader>b	<Plug>VtfsLspReferences;`          |
| LspHover                                  | `nnoremap <buffer> <LocalLeader>k	<Plug>VtfsLspHover;`               |
| LspNextDiagnostic                         | `nnoremap <buffer> <LocalLeader>n	<Plug>VtfsLspNextDiagnostic;`      |
| LspPreviousDiagnostic                     | `nnoremap <buffer> <LocalLeader>p	<Plug>VtfsLspPreviousDiagnostic;`  |
| LspDefinition                             | `nnoremap <buffer> <LocalLeader>D	<Plug>VtfsLspDefinition;`          |
| LspPeekDefinition                         | `nnoremap <buffer> <LocalLeader>d	<Plug>VtfsLspPeekDefinition;`      |
| LspRename                                 | `nnoremap <buffer> <LocalLeader>r	<Plug>VtfsLspRename;`              |
| LspNextError                              | `nnoremap <buffer> <LocalLeader>e	<Plug>VtfsLspNextError;`           |
| LspPreviousError                          | `nnoremap <buffer> <LocalLeader>E	<Plug>VtfsLspPreviousError;`       |

## Also included

### A better Netrw

This opiniated package also provides settings and extra (more convenient) remappings for Netrw, the file system tray for Vim.   
Netrw keyboard mappings may seem unintuitive.  
You may refer to this great article for documentation on the remappings : [Using Netrw, the Vim built-in file explorer](https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/)  

These will be something you may disable in an upcoming release.  

Some examples of provided remaps :  
- normal mode:   `<C-n>`       -> Open Netrw
- netrw:        `ff`        -> create new file in current dir
- netrw:        `FF`        -> delete file under cursor
- netrw:        `d`        -> create new dir in current dir
- netrw:        `D`        -> delete dir under cursor

# Customizable settings

On large screens, the REPL appears on the side of the current buffer.  
When loading the Scheme REPL, defines how many column the REPL buffer should occupy on large screens.  
The default value is `50`.  
```vim
au FileType scheme let g:vtfs_repl_cols = 50
```

On smaller screens, the REPL appears under the current buffer.  
When loading the Scheme REPL, defines how many rows the REPL buffer should occupy on smaller screens.  
The default value is `12`.  
```vim
au FileType scheme let g:vtfs_repl_rows = 12
```

Disable multithreading for the `scheme-langserver` using `0`.  
Do note `multithreading` requires that the `chez scheme` executable on your system be built with the `--threads` parameter, as stated in the [`chez-scheme` build instructions](https://github.com/ufo5260987423/scheme-langserver?tab=readme-ov-file#building).  
```vim
au FileType scheme let g:vtfs_lsp_chez_scheme_multithread = 0
```

Disable type inference for the `scheme-langserver` using `0`.  
Do note the `type inference` feature of the LSP requires enabling `multithreading`.  
```vim
au FileType scheme let g:vtfs_lsp_chez_scheme_type_inference = 0
```

Disable provided netrw remaps using `0`.
```vim
au Filetype netrw let b:vtfs_enable_netrw_mappings = 0
```

Disable provided netrw settings using `0`.
```vim
au Filetype netrw let b:vtfs_enable_netrw_settings = 0
```

# Credits

- Vim Plugin        vim/simpl						[https://github.com/benknoble/vim-simpl](https://github.com/benknoble/vim-simpl)
- Function          VtfsToggleLspDiagnostics        [https://github.com/prabirshrestha/vim-lsp/issues/1312](https://github.com/prabirshrestha/vim-lsp/issues/1312)
- Function          VtfsFindMatchingParen           [https://gist.github.com/plane/8c872ed174ba4f026b95ea8eb934cead](https://gist.github.com/plane/8c872ed174ba4f026b95ea8eb934cead)
- Vim Gist          better-netrw                    [https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/](https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/)
- LSP               scheme-langserver               [https://github.com/ufo5260987423/scheme-langserver](https://github.com/ufo5260987423/scheme-langserver)

# References

- [The Scheme Index](https://index.scheme.org) ([repository](https://github.com/schemeorg-community/index.scheme.org])) : The Scheme index allows searching for Scheme procedures, syntax and constants through types, tags, and names.
- [Building Vim from source](https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source)
- [Compiling Vim](https://richrose.dev/posts/linux/vim/vim-compile/)

# TODO 

1. [ ] Understand why racket lsp is not installing
1. [ ] Make vimscript suggest installation of the Akku package manager if Akku is not detected on the system.
1. [ ] Make vimscript execute `LspInstallServer racket-lsp` if the `racket-lsp` is not installed.
1. [ ] Provide build scripts and LSP configuration for `scheme-langserver`
1. [ ] Provide functions and keybindings for RNRS documentation pop-ups from within Vim.

