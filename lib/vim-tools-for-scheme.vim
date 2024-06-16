augroup vtfs_sanity " {{{
	" Required
	au!
	set nocompatible
	filetype plugin indent on 
augroup END " }}}

augroup vtfs_set_options	" {{{
	au!
	au VimEnter Scheme syntax on
	au BufRead,BufNewFile *.ss,*.scm,*.sls,*.sps set filetype=scheme

	au FileType scheme set completeopt=menuone,noinsert,noselect,preview
	au FileType scheme setlocal foldmethod=marker
	au FileType scheme setlocal smartindent                                                  
	au FileType scheme setlocal lisp
	au FileType scheme setlocal shiftwidth=2                                                 
	au FileType scheme setlocal softtabstop=2                                                
	au FileType scheme setlocal tabstop=2
	au FileType scheme setlocal wrapmargin=0                                                 
augroup END " }}}

augroup vtfs_plugins " {{{
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
augroup END " }}}

augroup vtfs_rooter " {{{
	au!
	au FileType scheme let g:rooter_cd_cmd = 'cd'
	au FileType scheme let g:rooter_silent_chdir = 0
	au FileType scheme let g:rooter_resolve_links = 1
	au FileType scheme let g:rooter_patterns = [ '>.git', '.git', '>Akku.manifest', 'Akku.manifest' ]
augroup END " }}}

augroup vtfs_asyncomplete " {{{
	au!
	au FileType scheme let g:asyncomplete_auto_popup = 1
	au FileType scheme let g:asyncomplete_popup_delay = 200
	au FileType scheme let g:asyncomplete_auto_completeopt = 1
	au! CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END " }}}

augroup vtfs_ultisnips " {{{
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
augroup END " }}}

augroup vtfs_repl " {{{
	au!
	au FileType scheme,racket let g:vtfs_repl_cols = 50
	au FileType scheme,racket let g:vtfs_repl_rows = 12
	au FileType scheme,racket let b:simpl_mods = (winwidth(0) < 150 ? 'botright' : 'vertical')
	au FileType scheme,racket command! VtfsReplLoad execute "normal! :w\<CR>:call simpl#load('++close ++cols=".g:vtfs_repl_cols." ++rows=" . (winheight(0) < 30 ? ceil(g:vtfs_repl_rows * 0.66) : g:vtfs_repl_rows)."')\<CR>\<C-w>p'"
	au FileType scheme let b:interpreter = ".akku/env scheme --quiet --compile-imported-libraries"
	au FileType scheme call simpl#register(
				\ 'scheme',
				\ { s -> printf("\n(load \"%s\")\n", s)},
				\ {-> '(load) '})
augroup END " }}}

augroup vtfs_lsp_configuration " {{{
	au!

	au FileType scheme setlocal omnifunc=lsp#complete

	" Lsp logging configuration
	au FileType scheme,racket let g:today = strftime('%Y-%m-%d', localtime())
	au FileType scheme,racket let g:lsp_logs_dir = expand('~') . "/.local/share/vim-lsp-settings"
	au FileType scheme if !isdirectory(g:lsp_logs_dir) | call mkdir(g:lsp_logs_dir) | endif
	au FileType scheme let g:lsp_log_file = g:lsp_logs_dir . "/vim-lsp-" . g:today . ".log"
	au FileType scheme let g:lsp_show_message_log_level = 'warning'

	" Lsp sane defaults
	let g:lsp_settings = {
				\  'scheme-langserver': {'allowlist': ['scheme']},
				\  'racket-lsp': {'allowlist': ['racket', 'scheme']},
				\ }

	au FileType scheme let g:lsp_auto_enable = 1
	au FileType scheme let g:lsp_code_action_ui = 'float'
	au FileType scheme let g:lsp_completion_documentation_delay = 50
	au FileType scheme let g:lsp_completion_documentation_enabled = 1
	au FileType scheme let g:lsp_diagnostics_enabled = 1
	au FileType scheme let g:lsp_diagnostics_float_cursor = 0
	au FileType scheme let g:lsp_diagnostics_float_insert_mode_enabled = 0
	au FileType scheme let g:lsp_diagnostics_signs_delay = 1000
	au FileType scheme let g:lsp_diagnostics_signs_enabled = 1
	au FileType scheme let g:lsp_diagnostics_signs_error = {'text': '✗'}
	au FileType scheme let g:lsp_diagnostics_signs_priority = 11
	au FileType scheme let g:lsp_diagnostics_signs_warning = {'text': '‼'}
	au FileType scheme let g:lsp_diagnostics_virtual_text_align = 'below' " after, right, below, above
	au FileType scheme let g:lsp_diagnostics_virtual_text_delay = 1000
	au FileType scheme let g:lsp_diagnostics_virtual_text_enabled = 1
	au FileType scheme let g:lsp_diagnostics_virtual_text_insert_mode_enabled = 0
	au FileType scheme let g:lsp_diagnostics_virtual_text_padding_left = 10
	au FileType scheme let g:lsp_diagnostics_virtual_text_prefix = " ‣ "
	au FileType scheme let g:lsp_diagnostics_virtual_text_wrap = 'wrap'
	au FileType scheme let g:lsp_document_code_action_signs_hint = {'text': 'A>'}	
	au FileType scheme let g:lsp_document_highlight_delay = 25
	au FileType scheme let g:lsp_document_highlight_enabled = 1
	au FileType scheme let g:lsp_fold_enabled = 1
	au FileType scheme let g:lsp_ignorecase = 1
	au FileType scheme let g:lsp_inlay_hints_enabled = 1
	au FileType scheme let g:lsp_insert_text_enabled = 0
	au FileType scheme let g:lsp_peek_alignment = 'top'
	au FileType scheme let g:lsp_preview_keep_focus = 0
	au FileType scheme let g:lsp_preview_max_height = 50
	au FileType scheme let g:lsp_semantic_enabled = 1
	au FileType scheme let g:lsp_settings_enable_suggestions = 1
	au FileType scheme let g:lsp_snippet_expand = 1
	au FileType scheme let g:lsp_text_edit_enabled = 1
	au FileType scheme let g:lsp_textprop_enabled = 1
augroup END " }}}

augroup vtfs_lsp_chez_scheme " {{{
	au!
	au VimEnter * let g:vtfs_lsp_chez_scheme_multithread = 1
	au VimEnter * let g:vtfs_lsp_chez_scheme_type_inference = 1

	" Register scheme-langserver if it is installed
	if (executable('scheme-langserver'))
		au VimEnter * let g:scheme_langserver_logs_file = g:lsp_logs_dir . '/scheme-langserver-' . g:today . '.log'
		au VimEnter * call lsp#register_server({ 
					\ 'name': 'scheme-langserver',
					\ 'cmd': [
					\		'scheme-langserver',
					\		g:scheme_langserver_logs_file,
					\		g:vtfs_lsp_chez_scheme_multithread == 1 ? "enable" : "disable",
					\		g:vtfs_lsp_chez_scheme_type_inference == 1 ? "enable" : "disable"
					\	],
					\	'allowlist': ['scheme']
					\	})
	endif

	" On probation it doesn't restart the server today.
	" Am I missing dependencies?
	"
	" " The chez_scheme langserver crashes often, let's create a loop which
	" " detects that then automatically boot it back up, asyncronously.
	" au BufEnter,BufRead,BufNewFile *.ss,*.scm,*.sls,*.sps call timer_start(0, {-> s:VtfsLspChezSchemeStatus()})
	" let g:vtfs_my_vimrc = empty(expand('$MYVIMRC')) ? expand('~/.vimrc') : expand('$MYVIMRC')
	" function! s:VtfsLspChezSchemeStatus() abort
	" 	call timer_start(0, {-> s:VtfsLspChezSchemeStatusAsync()})
	" endfunction
	" function! s:VtfsLspChezSchemeStatusAsync() abort
	" 	try
	" 		let output = execute('LspStatus')
	" 		if match(output, 'scheme-langserver: not running') >= 0 || match(output, 'scheme-langserver: exited') >= 0
	" 			echo '/!\ scheme-langserver has died, re-booting it.'
	" 			source g:vtfs_my_vimrc
	" 			return 1
	" 		endif
	" 	catch
	" 		echo v:exception
	" 	endtry
	" endfunction
	
	
augroup END " }}}

augroup vtfs_lsp_helper_functions " {{{
	au!

	"  Toggle LSP Diagnostics {{{
	" -------------------------------------------
	" Allows to toggle LSP diagnostics on and off.
	" Useful for disabling intrusive virtual text.
	" Rather naive implementation but gets the work done.
	au BufEnter * let b:my_lsp_diagnostics_enabled = 1
	function! s:VtfsLspToggleDiagnostics()		
		if !exists('b:my_lsp_diagnostics_enabled')		
			let b:my_lsp_diagnostics_enabled = 1    		
		endif																					
		if b:my_lsp_diagnostics_enabled == 1					
			call lsp#disable_diagnostics_for_buffer()		
			let b:my_lsp_diagnostics_enabled = 0				
			echo "LSP Diagnostics : OFF"								
		else																					
			call lsp#enable_diagnostics_for_buffer()		
			let b:my_lsp_diagnostics_enabled = 1				
			echo "LSP Diagnostics : ON"									
		endif																					
	endfunction
	au FileType * command! VtfsLspToggleDiagnostics call s:VtfsLspToggleDiagnostics()
	" Toggle LSP Disagnostics }}}

	"  FindMatchingParenType  {{{
	" -------------------------------------------
	" Automatically insert ) ] or } when you type ] in vim 
	function! VtfsFindMatchingParenType() 
		if !has("syntax") || !exists("g:syntax_on")
			let skip = "0"
		else
			let skip = '!empty(filter(map(synstack(line("."), col(".")), ''synIDattr(v:val, "name")''), ' .
						\ '''v:val =~? "string\\|character\\|singlequote\\|escape\\|symbol\\|comment"''))'
			try
				exec 'if ' . skip . ' | let skip = "0" | endif'
			catch /:Vim\%((\a\+)\)\=:E363/
				return
			endtry
		endif
		let s:parenOfs = {} " using s: here so we can access it in the lambda below
		let parens = []
		for delims in split(&matchpairs, ',')
			let [left, right] = split(delims, ':')
			let parens += [right]
			let [line, col] = searchpairpos('\M'.left, '', '\M'.right, 'nbW', skip,
						\ s:paren_search_top, s:paren_search_timeout)
			let ofs = line2byte(line) + col
			let s:parenOfs[right] = ofs
		endfor
		eval parens->sort({lhs, rhs -> s:parenOfs[rhs] - s:parenOfs[lhs]})
		return parens[0]
	endfunction
	au FileType scheme let s:paren_search_top = 1
	au FileType scheme let s:paren_search_timeout = 50
	" FindMatchingParenType }}}

augroup END " }}}

" vim:foldmethod=marker:
