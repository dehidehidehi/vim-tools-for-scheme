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
	if !exists('b:vtfs_lsp_diagnostics_echo_enabled')              | let b:vtfs_lsp_diagnostics_echo_enabled = 1 | endif
	if !exists('b:vtfs_no_lsp_maps')                               | let b:vtfs_no_lsp_maps = 0 | endif
	if !exists('b:vtfs_paren_search_timeout')                      | let b:vtfs_paren_search_timeout = 50 | endif
	if !exists('b:vtfs_paren_search_top')                          | let b:vtfs_paren_search_top = 1 | endif
	if !exists('b:vtfs_repl_cols')                                 | let b:vtfs_repl_cols = 50 | endif
	if !exists('b:vtfs_repl_rows')                                 | let b:vtfs_repl_rows = 12 | endif
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
		setlocal omnifunc& omnifunc=lsp#complete
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

augroup vtrs_default_keybindings " {{{
	if b:vtfs_no_lsp_maps != 1

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

			nnoremap <Plug>VtfsLspToggleDiagnostics; :VtfsLspToggleDiagnostics<CR>
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
