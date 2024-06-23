# Vim tools for Scheme

The developper experience for Scheme using vanilla Vim is painful.
The goal of this repository is to provide a modern developper experience in Vim for making Scheme applications.

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
TODO make vimscript install akku if not detected on system?
TODO make vimscript execute LspInstallServer racket-lsp

1. 
	" todo provide script to install Akku
	" todo provide script to install racket lsp
	" todo provide script to install chez Scheme lsp

## 2. Adding the vim configuration

1. Copy [vim-tools-for-scheme.vim](lib/vim-tools-for-scheme.vim) to some place on your disk.
1. In your `.vimrc` add `source LOCATION_OF_VIM_TOOLS_FOR_SCHEME`
1. Re-source your `.vimrc`

# Credits

- Vim Plugin        vim/simpl                   [https://github.com/benknoble/vim-simpl](https://github.com/benknoble/vim-simpl)
- Function          ToggleLspDiagnostics        [https://github.com/prabirshrestha/vim-lsp/issues/1312](https://github.com/prabirshrestha/vim-lsp/issues/1312)
- Function          FindMatchingParen           [https://gist.github.com/plane/8c872ed174ba4f026b95ea8eb934cead](https://gist.github.com/plane/8c872ed174ba4f026b95ea8eb934cead)
                                                                                                                                                                                                                    et parens += [right]

# Awesome Scheme projects

 - [The Scheme Index](https://index.scheme.org) ([repository](https://github.com/schemeorg-community/index.scheme.org])) : The Scheme index allows searching for Scheme procedures, syntax and constants through types, tags, and names.

# Other references

- [Building Vim from source](https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source)
- [Compiling Vim](https://richrose.dev/posts/linux/vim/vim-compile/)

# TODO list

## a new vim rc file to include

- [ ] move all my lisp and scheme config into a separate rc file
- [ ] organize the rc file
- [ ] make sure everything is in augroups and overridable and commented and credited 
- [ ] finalize LSP configuration for Scheme

## scripts to install external tooling

- [ ] ...
- [ ] ...
- [ ] ...
- [ ] ...
- [ ] ...
- [ ] ...

" Do note that the LSPs behave together nicely only when using r6rs
	
    provide script to install and build the chez-scheme lsp? 
	" todo tackle LSP configurations
	"
	"
	" readme document these vars
	"
		" au FileType Scheme,Racket let g:vtfs_repl_cols = 50
		" au FileType Scheme,Racket let g:vtfs_repl_rows = 12
	<!-- au FileType Scheme let g:vtfs_lsp_chez_scheme_multithread = 1 -->
	<!-- au FileType Scheme let g:vtfs_lsp_chez_scheme_type_inference = 1 -->
	document this variable let g:vtfs_my_vimrc = expand($MYVIMRC)
	" readme provide default keyremaps for
	" - togglelspdiagnostics
	" - LSP mapping defaults
	" - propose default mapping for loading the REPL
	" - mapping for autocmd FileType scheme,racket inoremap <expr> ] FindMatchingParenType()
	" - mapping for			au FileType Scheme inoremap <C-\> λ
	"
	
	
	
	

# Back-burner
- [ ] Convert this all into a nicely packaged vim plugin
