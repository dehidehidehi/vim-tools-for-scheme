let g:lsp_settings = {
			\  'scheme-langserver': {'allowlist': ['scheme']},
			\  'racket-lsp': {'allowlist': ['racket', 'scheme']},
			\ }

if !exists("*s:IsPluginFound")
	function! s:IsPluginFound(plugin_name) abort
		" The vim runtime only uses the name of the package, not the author
		" namespace
		let plugin_name = split(a:plugin_name, '/')[1]
		return match(&runtimepath, plugin_name) != -1
	endfunction
endif

augroup vtfs_rooter " {{{
	if (s:IsPluginFound("airblade/vim-rooter"))
		let g:rooter_cd_cmd = 'cd'
		let g:rooter_silent_chdir = 0
		let g:rooter_resolve_links = 1
		let g:rooter_patterns = [ '>.git', '.git', '>Akku.manifest', 'Akku.manifest' ]
		if exists('g:rooter_patterns')
			let g:rooter_patterns += g:rooter_patterns
		endif
	endif
augroup END " }}}

augroup vtfs_global_user_settings " {{{
	if !exists('g:vtfs_lsp_chez_scheme_multithread')               | let g:vtfs_lsp_chez_scheme_multithread = 1 | endif
	if !exists('g:vtfs_lsp_chez_scheme_type_inference')            | let g:vtfs_lsp_chez_scheme_type_inference = 1 | endif
	if !exists('g:vtfs_lsp_chez_scheme_lsp_executable_name')       | let g:vtfs_lsp_chez_scheme_lsp_executable_name = "scheme-langserver" | endif
	if !exists('g:vtfs_enable_netrw_mappings')                     | let g:vtfs_enable_netrw_mappings = 1 | endif
	if !exists('g:vtfs_enable_netrw_settings')                     | let g:vtfs_enable_netrw_settings = 1 | endif
augroup END " }}}

augroup vtfs_global_lsp_configuration " {{{

	" Lsp logging configuration
	let g:today = strftime('%Y-%m-%d', localtime())
	let g:lsp_logs_dir = expand('~') . "/.local/share/vim-lsp-settings"
	if !isdirectory(g:lsp_logs_dir) | call mkdir(g:lsp_logs_dir) | endif

	if !exists('g:lsp_log_file') | let g:lsp_log_file = g:lsp_logs_dir . "/vim-lsp-" . g:today . ".log" | endif
	if !exists('g:lsp_show_message_log_level') | let g:lsp_show_message_log_level = 'warning' | endif

	if (s:IsPluginFound("prabirshrestha/vim-lsp"))
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

augroup vtfs_global_lsp_chez_scheme " {{{
	if (s:IsPluginFound("prabirshrestha/vim-lsp"))
		" Register scheme-langserver if it is installed
		if (executable(g:vtfs_lsp_chez_scheme_lsp_executable_name))
			if !exists('g:scheme_langserver_logs_file')
				let g:scheme_langserver_logs_file = g:lsp_logs_dir . '/scheme-langserver-' . g:today . '.log'
			endif
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
	endif
augroup END

augroup vtfs_global_netrw " {{{
	if g:vtfs_enable_netrw_settings == 1 " {{{
		let g:netrw_list_hide = netrw_gitignore#Hide() . '*\+\.swp,*\+\.un~'
		let g:netrw_keepdir = 0
		let g:netrw_fastbrowse = 0
		let g:netrw_banner = 0
		let g:netrw_browse_split = 0
		let g:netrw_hide = 1
		let g:netrw_liststyle = 0
		let g:netrw_sizestyle = "H"
		let g:netrw_winsize = 20
		let g:netrw_localcopydircmd = 'cp -r'
	endif  " }}}
augroup END

