setlocal nocompatible
filetype plugin indent on
au BufRead scheme syntax on
set backspace=indent,eol,start " make that backspace key work the way it should

map <Space> <Nop>
let mapleader = " "
let maplocalleader = " "

call plug#begin()
    " Required
    Plug 'dehidehidehi/vim-tools-for-scheme'

    " For full functionality
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

