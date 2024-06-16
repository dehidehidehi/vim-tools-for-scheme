augroup vim_tooling_for_scheme
	au!
	set nocompatible
	filetype plugin indent on 

	augroup vtfs_set_options
		au!
		au VimEnter Scheme syntax on
		au BufRead,BufNewFile *.ss,*.scm,*.sls,*.sps set filetype=scheme
		au FileType Scheme set completeopt=menuone,noinsert,noselect,preview
		au FileType Scheme set lisp
		au FileType Scheme set smartindent                                                  
		au FileType Scheme set wildmenu
		au FileType Scheme set wildmode+=list:longest
		au FileType Scheme setlocal shiftwidth=2                                                 
		au FileType Scheme setlocal softtabstop=2                                                
		au FileType Scheme setlocal tabstop=2
		au FileType Scheme setlocal wrapmargin=0                                                 
	augroup END

	augroup vtfs_plugins
		au!
		" Install vim-plug if not found
		if empty(glob('~/.vim/autoload/plug.vim')) 
			silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
		endif
		source $HOME/.vim/autoload/plug.vim
    call plug#begin('~/.vim/plugged')
    Plug 'honza/vim-snippets'
    Plug 'sirver/ultisnips'
    Plug 'airblade/vim-rooter'
    Plug 'dehidehidehi/vim-simpl', { 'branch': 'improvement/allow-do-load-to-pass-more-terminal-options' }
    Plug 'mattn/vim-lsp-settings'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/vim-lsp'
    call plug#end()
		packloadall
		" Run PlugInstall if there are missing plugins
		if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
			PlugInstall --sync
			source expand('%:p')
		endif
	augroup END

	augroup vtfs_rooter
		au!
		au FileType scheme let g:rooter_cd_cmd = 'cd'
		au FileType scheme let g:rooter_silent_chdir = 0
		au FileType scheme let g:rooter_resolve_links = 1
		au FileType scheme let g:rooter_patterns = [ '>.git', '.git', '>Akku.manifest', 'Akku.manifest' ]
	augroup END

	augroup vtfs_asyncomplete
		au!
		au FileType scheme let g:asyncomplete_auto_popup = 1
		au FileType scheme let g:asyncomplete_popup_delay = 200
		au FileType scheme let g:asyncomplete_auto_completeopt = 1
		au! CompleteDone * if pumvisible() == 0 | pclose | endif
	augroup END

	augroup vtfs_ultisnips
		au!
		" Automatically creates user-specific snippets dir if it doesn't exist
		au FileType scheme if !isdirectory($HOME."/.vim/".$USER."-snippets") | call mkdir($HOME."/.vim/".$USER."-snippets", "p") | endif
		au FileType scheme let g:UltiSnipsEditSplit = "tabdo"
		au FileType scheme let g:UltiSnipsEnableSnipMate = 1                               						
		au FileType scheme let g:UltiSnipsExpandTrigger="<tab>"
		au FileType scheme let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
		au FileType scheme let g:UltiSnipsJumpForwardTrigger="<tab>"
		au FileType scheme let g:UltiSnipsSnippetDirectories = ["UltiSnips", $USER . "-snippets"]
		" UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit must be absolute
		" This means that any custom snippets you make will be saved to the following dir.
		" This means that on top of sourcing snippets from third parties, snippets will also be sources from here if specified in g:UltiSnipsSnippetDirectories.
		au FileType scheme let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = $HOME."/.vim/".$USER."-snippets"
	augroup END

	" testing the configuration with
	" vim -u lib/vim-tools-for-scheme.vim testing.ss
	" I was here about to tackle LSP configurations
	"
	" todo provide script to install Akku
	" todo provide script to install racket lsp
	" todo provide script to install chez scheme lsp
	
augroup END

