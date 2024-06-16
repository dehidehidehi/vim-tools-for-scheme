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

## Requirements

1. Compile and install with the [Vim compilation script](scripts/vim-compile.sh)
1. 


# Credits

- benkenoble

# Awesome Scheme projects

 - [The Scheme Index](https://index.scheme.org) ([repository](https://github.com/schemeorg-community/index.scheme.org]) : The Scheme index allows searching for Scheme procedures, syntax and constants through types, tags, and names.

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


# Back-burner
- [ ] Convert this all into a nicely packaged vim plugin
