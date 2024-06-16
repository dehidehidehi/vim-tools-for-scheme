
aug vim_tooling_for_scheme
	au!

	aug vtfs_plugins
		au FileType Scheme call plug#begin()
		au FileType Scheme Plug 'honza/vim-snippets'
		au FileType Scheme Plug 'sirver/ultisnips'
		au FileType Scheme plug 'airblade/vim-rooter'                                  
		au FileType Scheme plug 'dehidehidehi/vim-simpl',					{ 'branch': 'improvement/allow-do-load-to-pass-more-terminal-options' }
		au FileType Scheme plug 'mattn/vim-lsp-settings'                               
		au FileType Scheme plug 'prabirshrestha/asyncomplete-lsp.vim'                  
		au FileType Scheme plug 'prabirshrestha/asyncomplete.vim'                      
		au FileType Scheme plug 'prabirshrestha/vim-lsp'                               
		au FileType Scheme call plug#end()
		au FileType Scheme packloadall
	aug END

	aug vtfs_set_options
		au!
		au FileType Scheme set completeopt=menuone,noinsert,noselect,preview
		au FileType Scheme set lisp
		au FileType Scheme set smartindent                                                  
		au FileType Scheme set wildmenu
		au FileType Scheme set wildmode+=list:longest
		au FileType Scheme setlocal shiftwidth=2                                                 
		au FileType Scheme setlocal softtabstop=2                                                
		au FileType Scheme setlocal tabstop=2
		au FileType Scheme setlocal wrapmargin=0                                                 
	aug END

	aug vtfs_rooter
		au!
		au FileType scheme let g:rooter_cd_cmd = 'cd'
		au FileType scheme let g:rooter_silent_chdir = 0
		au FileType scheme let g:rooter_resolve_links = 1
		au FileType scheme let g:rooter_patterns = [
					\ '>.git',
					\ '.git',
					\ '>Akku.manifest',
					\ 'Akku.manifest',
					\ ]

	aug END

	aug vtfs_asyncomplete
		au FileType scheme let g:asyncomplete_auto_popup = 1
		au FileType scheme let g:asyncomplete_popup_delay = 200
		au FileType scheme let g:asyncomplete_auto_completeopt = 1
		au! CompleteDone * if pumvisible() == 0 | pclose | endif
	aug END

	aug vtfs_ultisnips
		" Automatically creates user-specific snippets dir if it doesn't exist
		au FileType scheme if !isdirectory($HOME."/.vim/".$USER."-snippets") |
					\ call mkdir($HOME."/.vim/".$USER."-snippets", "p") |
					\ endif
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
	aug END

	" todo first try and see if the above imports and executes properly
	" I was here about to tackle LSP configurations
aug END

