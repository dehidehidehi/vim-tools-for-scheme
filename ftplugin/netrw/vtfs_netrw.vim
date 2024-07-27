augroup vtfs_netrw " {{{

  if g:vtfs_enable_netrw_mappings == 1 " {{{
    " Go to file and close Netrw window
    " nmap <buffer> L <CR>:Rex<CR>
    " Go back in history
    nmap <buffer> H u
    " Go up a directory
    nmap <buffer> h -^
    " Go down a directory / open file
    " Toggle dotfiles
    nmap <buffer> . gh
    " Toggle the mark on a file
    nmap <buffer> <TAB> mf
    " Unmark all files in the buffer
    " nmap <buffer> <S-TAB> mF
    " Unmark all files
    nmap <buffer> <LocalLeader><TAB> mu
    " 'Bookmark' a directory
    nmap <buffer> bb mb
    " Delete the most recent directory bookmark
    nmap <buffer> bd mB
    " Got to a directory on the most recent bookmark
    nmap <buffer> bl gb
    " Create a file
    nmap <buffer> ff %:w<CR>:buffer #<CR>
    " Rename a file
    nmap <buffer> fe R
    " Copy marked files in the directory under cursor
    nmap <buffer> fc mtmc
    " Move marked files in the directory under cursor
    nmap <buffer> fx mtmm
    " Execute a command on marked files
    nmap <buffer> f; mx
    " Show the list of marked files
    nmap <buffer> fl :echo join(netrw#Expose("netrwmarkfilelist"), "\n")<CR>
    " Show the current target directory
    nmap <buffer> fq :echo 'Target:' . netrw#Expose("netrwmftgt")<CR>
    " Set the directory under the cursor as the current target
    nmap <buffer> fd mtfq
    " Delete a file
    nmap <buffer> FF :call NetrwRemoveRecursive()<CR>
    " Close the preview window
    nmap <buffer> P <C-w>z
    " Open all selected files in a new tab
    nmap <silent> <buffer> <C-t> ma:argdo tabnew<CR>
  endif " }}}

augroup END " }}}
