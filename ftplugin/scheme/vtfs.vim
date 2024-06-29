" Vim filetype plugin for bootstrapping the tooling required for developping applications in Scheme.
" Maintainer:	dehidehi
" License:	This file is placed in the public domain.

if exists("b:loaded_vtfs")
	finish
endif
let b:loaded_vtfs = 1

" Required
setlocal nocompatible& nocompatible
filetype plugin indent on
au BufRead scheme syntax on

augroup vtfs_user_settings " {{{
	if !exists('b:vtfs_enable_netrw_mappings')                     | let b:vtfs_enable_netrw_mappings = 1 | endif
	if !exists('b:vtfs_enable_netrw_settings')                     | let b:vtfs_enable_netrw_settings = 1 | endif
	if !exists('b:vtfs_lsp_diagnostics_echo_enabled')              | let b:vtfs_lsp_diagnostics_echo_enabled = 1 | endif
	if !exists('b:vtfs_no_lsp_maps')                               | let b:vtfs_no_lsp_maps = 0 | endif
	if !exists('b:vtfs_paren_search_timeout')                      | let b:vtfs_paren_search_timeout = 50 | endif
	if !exists('b:vtfs_paren_search_top')                          | let b:vtfs_paren_search_top = 1 | endif
	if !exists('b:vtfs_repl_cols')                                 | let b:vtfs_repl_cols = 50 | endif
	if !exists('b:vtfs_repl_rows')                                 | let b:vtfs_repl_rows = 12 | endif
	if !exists('g:vtfs_lsp_chez_scheme_multithread')               | let g:vtfs_lsp_chez_scheme_multithread = 1 | endif
	if !exists('g:vtfs_lsp_chez_scheme_type_inference')            | let g:vtfs_lsp_chez_scheme_type_inference = 1 | endif
	if !exists('g:vtfs_lsp_chez_scheme_lsp_executable_name')       | let g:vtfs_lsp_chez_scheme_lsp_executable_name = "scheme-langserver" | endif
augroup END " }}}

augroup vtfs_state " {{{
	let b:vtfs_lsp_diagnostics_enabled = 1
augroup END " }}}

augroup vtfs_set_options	" {{{
	setlocal completeopt& completeopt+=menuone,noinsert,noselect,preview
	setlocal foldmethod& foldmethod=marker
	setlocal smartindent& smartindent
	setlocal lisp& lisp
	setlocal shiftwidth& shiftwidth=2
	setlocal softtabstop& softtabstop=2
	setlocal tabstop& tabstop=2
	setlocal wrapmargin& wrapmargin=0
augroup END " }}}

augroup vtfs_plugins " {{{

	if !exists("*s:IsPluginFound")
		function! s:IsPluginFound(plugin_name) abort
				" The vim runtime only uses the name of the package, not the author
				" namespace
				let plugin_name = split(a:plugin_name, '/')[1]
				return match(&runtimepath, plugin_name) != -1
		endfunction
	endif

	if !exists("*s:IsMapped")
		function! s:IsMapped(mapping, mode) abort
			let result = mapcheck(a:mapping, a:mode)
			return empty(result) || result == '<Nop>' ? 1 : 0
		endfunction
	endif

augroup END " }}}

augroup vtfs_rooter " {{{
	if (s:IsPluginFound("airblade/vim-rooter"))
		let b:rooter_cd_cmd = 'cd'
		let b:rooter_silent_chdir = 0
		let b:rooter_resolve_links = 1
		let b:rooter_patterns = [ '>.git', '.git', '>Akku.manifest', 'Akku.manifest' ]
		if exists('g:rooter_patterns')
			let b:rooter_patterns += g:rooter_patterns
		endif
	endif
augroup END " }}}

augroup vtfs_asyncomplete " {{{
	if (s:IsPluginFound("prabirshrestha/asyncomplete.vim"))
		let b:asyncomplete_auto_popup = 1
		let b:asyncomplete_popup_delay = 200
		let b:asyncomplete_auto_completeopt = 1
		au! CompleteDone * if pumvisible() == 0 | pclose | endif
	endif
augroup END " }}}

augroup vtfs_ultisnips " {{{
	if (s:IsPluginFound("sirver/ultisnips"))
		" Automatically creates user-specific snippets dir if it doesn't exist
		if !isdirectory($HOME."/.vim/".$USER."-snippets") | call mkdir($HOME."/.vim/".$USER."-snippets", "p") | endif
		if !exists('g:UltiSnipsEditSplit')
			let b:UltiSnipsEditSplit = "tabdo"
		endif
		if !exists('g:UltiSnipsEnableSnipMate')
			let b:UltiSnipsEnableSnipMate = 1
		endif
		if !exists('g:UltiSnipsExpandTrigger')
			let b:UltiSnipsExpandTrigger="<tab>"
		endif
		if !exists('g:UltiSnipsJumpBackwardTrigger')
			let b:UltiSnipsJumpBackwardTrigger="<s-tab>"
		endif
		if !exists('g:UltiSnipsJumpForwardTrigger')
			let b:UltiSnipsJumpForwardTrigger="<tab>"
		endif
		if !exists('g:UltiSnipsSnippetDirectories')
			let b:UltiSnipsSnippetDirectories = ["UltiSnips", $USER . "-snippets"]
		endif
		" UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit must be absolute
		" This means that any custom snippets you make will be saved to the following dir.
		" This means that on top of sourcing snippets from third parties, snippets will also be sources from here if specified in g:UltiSnipsSnippetDirectories.
		if !exists('g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit')
			let b:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = $HOME."/.vim/".$USER."-snippets"
		endif
	endif
augroup END " }}}

augroup vtfs_repl " {{{
	if (s:IsPluginFound("dehidehidehi/vim-simpl"))
		if !exists('g:simpl_mods')
			let b:simpl_mods = (winwidth(0) < 150 ? 'botright' : 'vertical')
		endif
		if !exists(":VtfsReplLoad")
			command -buffer VtfsReplLoad silent execute "normal! :w\<CR>:call simpl#load('++cols=".b:vtfs_repl_cols." ++rows=" . (winheight(0) < 30 ? ceil(b:vtfs_repl_rows * 0.66) : b:vtfs_repl_rows)."')\<CR>\<C-w>p'"
		endif
		if !exists('g:interpreter')
			let b:interpreter = (isdirectory(".akku") == 1 && executable("akku") == 1 ? ".akku/env " : "") . "scheme --quiet --compile-imported-libraries"
		endif
		call simpl#register(
					\ 'scheme',
					\ { s -> printf("\n(load \"%s\")\n", s)},
					\ {-> '(load) '})
	endif
augroup END " }}}

augroup vtfs_lsp_configuration " {{{
	if (s:IsPluginFound("prabirshrestha/vim-lsp"))
		setlocal omnifunc& omnifunc=lsp#complete

		" Lsp logging configuration
		let s:today = strftime('%Y-%m-%d', localtime())
		let s:lsp_logs_dir = expand('~') . "/.local/share/vim-lsp-settings"
		if !exists('g:lsp_log_file') | let g:lsp_log_file = s:lsp_logs_dir . "/vim-lsp-" . s:today . ".log" | endif
		if !exists('g:lsp_show_message_log_level') | let g:lsp_show_message_log_level = 'warning' | endif
		if !isdirectory(s:lsp_logs_dir) | call mkdir(s:lsp_logs_dir) | endif

		" Lsp sane defaults
		let g:lsp_settings = {
					\  'scheme-langserver': {'allowlist': ['scheme']},
					\  'racket-lsp': {'allowlist': ['racket', 'scheme']},
					\ }

		if !exists('g:lsp_auto_enable')                                    | let g:lsp_auto_enable = 1 | endif
		if !exists('g:lsp_code_action_ui')                                 | let g:lsp_code_action_ui = 'float' | endif
		if !exists('g:lsp_completion_documentation_delay')                 | let g:lsp_completion_documentation_delay = 50 | endif
		if !exists('g:lsp_completion_documentation_enabled')               | let g:lsp_completion_documentation_enabled = 1 | endif
		if !exists('g:lsp_diagnostics_enabled')                            | let g:lsp_diagnostics_enabled = 1 | endif
		if !exists('g:lsp_diagnostics_float_cursor')                       | let g:lsp_diagnostics_float_cursor = 0 | endif
		if !exists('g:lsp_diagnostics_float_insert_mode_enabled')          | let g:lsp_diagnostics_float_insert_mode_enabled = 0 | endif
		if !exists('g:lsp_diagnostics_signs_delay')                        | let g:lsp_diagnostics_signs_delay = 1000 | endif
		if !exists('g:lsp_diagnostics_signs_enabled')                      | let g:lsp_diagnostics_signs_enabled = 1 | endif
		if !exists('g:lsp_diagnostics_signs_error')                        | let g:lsp_diagnostics_signs_error = {'text': '✗'} | endif
		if !exists('g:lsp_diagnostics_signs_priority')                     | let g:lsp_diagnostics_signs_priority = 11 | endif
		if !exists('g:lsp_diagnostics_signs_warning')                      | let g:lsp_diagnostics_signs_warning = {'text': '‼'} | endif
		if !exists('g:lsp_diagnostics_virtual_text_align')                 | let g:lsp_diagnostics_virtual_text_align = 'below' | endif
		if !exists('g:lsp_diagnostics_virtual_text_delay')                 | let g:lsp_diagnostics_virtual_text_delay = 1000 | endif
		if !exists('g:lsp_diagnostics_virtual_text_enabled')               | let g:lsp_diagnostics_virtual_text_enabled = 1 | endif
		if !exists('g:lsp_diagnostics_virtual_text_insert_mode_enabled')   | let g:lsp_diagnostics_virtual_text_insert_mode_enabled = 0 | endif
		if !exists('g:lsp_diagnostics_virtual_text_padding_left')          | let g:lsp_diagnostics_virtual_text_padding_left = 10 | endif
		if !exists('g:lsp_diagnostics_virtual_text_prefix')                | let g:lsp_diagnostics_virtual_text_prefix = " ‣ " | endif
		if !exists('g:lsp_diagnostics_virtual_text_wrap')                  | let g:lsp_diagnostics_virtual_text_wrap = 'wrap' | endif
		if !exists('g:lsp_document_code_action_signs_hint')                | let g:lsp_document_code_action_signs_hint = {'text': 'A>'} | endif
		if !exists('g:lsp_document_highlight_delay')                       | let g:lsp_document_highlight_delay = 25 | endif
		if !exists('g:lsp_document_highlight_enabled')                     | let g:lsp_document_highlight_enabled = 1 | endif
		if !exists('g:lsp_fold_enabled')                                   | let g:lsp_fold_enabled = 1 | endif
		if !exists('g:lsp_ignorecase')                                     | let g:lsp_ignorecase = 1 | endif
		if !exists('g:lsp_inlay_hints_enabled')                            | let g:lsp_inlay_hints_enabled = 1 | endif
		if !exists('g:lsp_insert_text_enabled')                            | let g:lsp_insert_text_enabled = 0 | endif
		if !exists('g:lsp_peek_alignment')                                 | let g:lsp_peek_alignment = 'top' | endif
		if !exists('g:lsp_preview_keep_focus')                             | let g:lsp_preview_keep_focus = 0 | endif
		if !exists('g:lsp_preview_max_height')                             | let g:lsp_preview_max_height = 50 | endif
		if !exists('g:lsp_semantic_enabled')                               | let g:lsp_semantic_enabled = 1 | endif
		if !exists('g:lsp_settings_enable_suggestions')                    | let g:lsp_settings_enable_suggestions = 1 | endif
		if !exists('g:lsp_snippet_expand')                                 | let g:lsp_snippet_expand = 1 | endif
		if !exists('g:lsp_text_edit_enabled')                              | let g:lsp_text_edit_enabled = 1 | endif
		if !exists('g:lsp_textprop_enabled')                               | let g:lsp_textprop_enabled = 1 | endif
	endif
augroup END " }}}

augroup vtfs_lsp_chez_scheme " {{{
	if (s:IsPluginFound("prabirshrestha/vim-lsp"))
		" Register scheme-langserver if it is installed
		if (executable(g:vtfs_lsp_chez_scheme_lsp_executable_name))
			if !exists('g:scheme_langserver_logs_file') | let g:scheme_langserver_logs_file = s:lsp_logs_dir . '/scheme-langserver-' . s:today . '.log' | endif
			call lsp#register_server({
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
	" if !exists("*s:VtfsLspChezSchemeStatus)
	" function! s:VtfsLspChezSchemeStatus() abort
	" 	call timer_start(0, {-> s:VtfsLspChezSchemeStatusAsync()})
	" endfunction
	" endif
	" if !exists("*s:VtfsLspChezSchemeStatusAsync")
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
	" endif
	endif
augroup END " }}}

augroup vtfs_helper_functions " {{{
	if (s:IsPluginFound("prabirshrestha/vim-lsp"))
		"  Toggle LSP Diagnostics {{{
		" -------------------------------------------
		" Allows to toggle LSP diagnostics on and off.
		" Useful for disabling intrusive virtual text.
		" Rather naive implementation but gets the work done.
		if !exists("b:my_lsp_diagnostics_enabled") | let b:vtfs_lsp_diagnostics_enabled = 1 | endif

		if !exists("*VtfsLspToggleDiagnostics")
			function VtfsLspToggleDiagnostics()
				if !exists('b:my_lsp_diagnostics_enabled')
					let b:vtfs_lsp_diagnostics_enabled = 1
				endif
				if b:vtfs_lsp_diagnostics_enabled == 1
					call lsp#disable_diagnostics_for_buffer()
					let b:vtfs_lsp_diagnostics_enabled = 0
					if(b:vtfs_lsp_diagnostics_echo_enabled == 1)
						echo "LSP Diagnostics : OFF"
					endif
				else
					call lsp#enable_diagnostics_for_buffer()
					let b:vtfs_lsp_diagnostics_enabled = 1
					if(b:vtfs_lsp_diagnostics_echo_enabled == 1)
						echo "LSP Diagnostics : ON"
					endif
				endif
			endfunction
		endif

		if !exists(":VtfsLspToggleDiagnostics")
			command -buffer VtfsLspToggleDiagnostics call VtfsLspToggleDiagnostics()
		endif
	endif
	" Toggle LSP Disagnostics }}}

	"  FindMatchingParenType  {{{
	" -------------------------------------------
	" Automatically insert ) ] or } when you type ] in vim
	if !exists("*VtfsFindMatchingParenType")
		function VtfsFindMatchingParenType()
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
							\ b:vtfs_paren_search_top, b:vtfs_paren_search_timeout)
				let ofs = line2byte(line) + col
				let s:parenOfs[right] = ofs
			endfor
			eval parens->sort({lhs, rhs -> s:parenOfs[rhs] - s:parenOfs[lhs]})
			return parens[0]
		endfunction
	endif
	" FindMatchingParenType }}}
augroup END " }}}

augroup vtfs_netrw " {{{

	if b:vtfs_enable_netrw_mappings == 1 " {{{
			" Go to file and close Netrw window
			" nmap <buffer> L <CR>:Rex<CR>
			" Go back in history
			au Filetype netrw nmap <buffer> H u
			" Go up a directory
			au Filetype netrw nmap <buffer> h -^
			" Go down a directory / open file
			" Toggle dotfiles
			au Filetype netrw nmap <buffer> . gh
			" Toggle the mark on a file
			au Filetype netrw nmap <buffer> <TAB> mf
			" Unmark all files in the buffer
			" au Filetype netrw nmap <buffer> <S-TAB> mF
			" Unmark all files
			au Filetype netrw nmap <buffer> <LocalLeader><TAB> mu
			" 'Bookmark' a directory
			au Filetype netrw nmap <buffer> bb mb
			" Delete the most recent directory bookmark
			au Filetype netrw nmap <buffer> bd mB
			" Got to a directory on the most recent bookmark
			au Filetype netrw nmap <buffer> bl gb
			" Create a file
			au Filetype netrw nmap <buffer> ff %:w<CR>:buffer #<CR>
			" Rename a file
			au Filetype netrw nmap <buffer> fe R
			" Copy marked files in the directory under cursor
			au Filetype netrw nmap <buffer> fc mtmc
			" Move marked files in the directory under cursor
			au Filetype netrw nmap <buffer> fx mtmm
			" Execute a command on marked files
			au Filetype netrw nmap <buffer> f; mx
			" Show the list of marked files
			au Filetype netrw nmap <buffer> fl :echo join(netrw#Expose("netrwmarkfilelist"), "\n")<CR>
			" Show the current target directory
			au Filetype netrw nmap <buffer> fq :echo 'Target:' . netrw#Expose("netrwmftgt")<CR>
			" Set the directory under the cursor as the current target
			au Filetype netrw nmap <buffer> fd mtfq
			" Delete a file
			au Filetype netrw nmap <buffer> FF :call NetrwRemoveRecursive()<CR>
			" Close the preview window
			au Filetype netrw nmap <buffer> P <C-w>z
			" Open all selected files in a new tab
			au Filetype netrw nmap <silent> <buffer> <C-t> ma:argdo tabnew<CR>
	endif " }}}

		if b:vtfs_enable_netrw_settings == 1 " {{{
			au FileType netrw let g:netrw_list_hide = netrw_gitignore#Hide() . '*\+\.swp,*\+\.un~'
			au FileType netrw let g:netrw_keepdir = 0
			au FileType netrw let g:netrw_fastbrowse = 0
			au FileType netrw let g:netrw_banner = 0
			au FileType netrw let g:netrw_browse_split = 0
			au FileType netrw let g:netrw_hide = 1
			au FileType netrw let g:netrw_liststyle = 0
			au FileType netrw let g:netrw_sizestyle = "H"
			au FileType netrw let g:netrw_winsize = 20
			au FileType netrw let g:netrw_localcopydircmd = 'cp -r'
		endif  " }}}
	
augroup END " }}}

augroup vtrs_default_keybindings " {{{
	if g:vtfs_no_lsp_maps != 1

		inoremap <Plug>VtfsInsertLambdaSymbol; λ
		if !hasmapto('<Plug>VtfsInsertLambdaSymbol;') && s:IsMapped("<C-\\>", "i")
			inoremap <buffer> <unique> <C-\> <Plug>VtfsInsertLambdaSymbol;
		endif

		nnoremap <Plug>VtfsNetrwEx; :Ex<CR>
		if !hasmapto('<Plug>VtfsNetrwEx;') && s:IsMapped("<C-n>", "n")
			nnoremap <buffer> <unique> <C-n> <Plug>VtfsNetrwEx;
		endif

		inoremap <Plug>VtfsFindMatchingParenType; <C-r>=VtfsFindMatchingParenType()<CR>
		if !hasmapto('<Plug>VtfsFindMatchingParenType;') && s:IsMapped("]", "i")
		 	silent inoremap <buffer> <unique> ] <Plug>VtfsFindMatchingParenType;
	 	endif

		" Repl
		if (s:IsPluginFound("dehidehidehi/vim-simpl"))

				nnoremap <Plug>VtfsReplLoad; :VtfsReplLoad<CR>
				if !hasmapto('<Plug>VtfsReplLoad;') && s:IsMapped("<Leader>l", "n")
				 	silent nnoremap <buffer> <unique> <LocalLeader>l <Plug>VtfsReplLoad;
			 	endif

		endif

		if (s:IsPluginFound("prabirshrestha/vim-lsp"))

			nnoremap <Plug>VtfsLspToggleDiagnostics; :VtfsLspToggleDiagnostics()<CR>
			if !hasmapto('<Plug>VtfsLspToggleDiagnostics;') && s:IsMapped("<Leader>W", "n")
			 	nnoremap <buffer> <unique> <LocalLeader>W <Plug>VtfsLspToggleDiagnostics;
		 	endif

			nnoremap <Plug>VtfsLspCodeAction; :LspCodeAction<CR>
			if !hasmapto('<Plug>VtfsLspCodeAction;') && s:IsMapped("<Leader>a", "n")
			 	nnoremap <buffer> <unique> <LocalLeader>a	<Plug>VtfsLspCodeAction;
		 	endif

			nnoremap <Plug>VtfsLspReferences; :LspReferences<CR>
			if !hasmapto('<Plug>VtfsLspReferences;') && s:IsMapped("<Leader>b", "n")
			 	nnoremap <buffer> <unique> <LocalLeader>b	<Plug>VtfsLspReferences;
		 	endif

			nnoremap <Plug>VtfsLspHover; :LspHover<CR>
			if !hasmapto('<Plug>VtfsLspHover;') && s:IsMapped("<Leader>k", "n")
			 	nnoremap <buffer> <unique> <LocalLeader>k	<Plug>VtfsLspHover;
		 	endif

			nnoremap <Plug>VtfsLspNextDiagnostic; :LspNextDiagnostic<CR>
			if !hasmapto('<Plug>VtfsLspNextDiagnostic;') && s:IsMapped("<Leader>n", "n")
			 	nnoremap <buffer> <unique> <LocalLeader>n	<Plug>VtfsLspNextDiagnostic;
		 	endif

			nnoremap <Plug>VtfsLspPreviousDiagnostic; :LspPreviousDiagnostic<CR>
			if !hasmapto('<Plug>VtfsLspPreviousDiagnostic;') && s:IsMapped("<Leader>p", "n")
			 	nnoremap <buffer> <unique> <LocalLeader>p	<Plug>VtfsLspPreviousDiagnostic;
		 	endif

			nnoremap <Plug>VtfsLspDefinition; :LspDefinition<CR>
			if !hasmapto('<Plug>VtfsLspDefinition;') && s:IsMapped("<Leader>D", "n")
			 	nnoremap <buffer> <unique> <LocalLeader>D	<Plug>VtfsLspDefinition;
		 	endif

			nnoremap <Plug>VtfsLspPeekDefinition; :LspPeekDefinition<CR>
			if !hasmapto('<Plug>VtfsLspPeekDefinition;') && s:IsMapped("<Leader>d", "n")
			 	nnoremap <buffer> <unique> <LocalLeader>d	<Plug>VtfsLspPeekDefinition;
		 	endif

			nnoremap <Plug>VtfsLspRename; :LspRename<CR>
			if !hasmapto('<Plug>VtfsLspRename;') && s:IsMapped("<Leader>r", "n")
			 	nnoremap <buffer> <unique> <LocalLeader>r	<Plug>VtfsLspRename;
		 	endif

			nnoremap <Plug>VtfsLspNextError; :LspNextError<CR>
			if !hasmapto('<Plug>VtfsLspNextError;') && !hasmapto(':LspNextError') && s:IsMapped("<Leader>e", "n")
			 	nnoremap <buffer> <unique> <LocalLeader>e	<Plug>VtfsLspNextError;
		 	endif

			nnoremap <Plug>VtfsLspPreviousError; :LspPreviousError<CR>
			if !hasmapto('<Plug>VtfsLspPreviousError;') && !hasmapto(':LspPreviousError') && s:IsMapped("<Leader>E", "n")
			 	nnoremap <buffer> <unique> <LocalLeader>E	<Plug>VtfsLspPreviousError;
		 	endif

		endif
	endif
augroup END " }}}

" vim:fdm=marker:ts=2
