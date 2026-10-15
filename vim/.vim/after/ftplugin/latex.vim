"" abort if b:did_html_maps is true: already loaded or user pref
if exists("b:did_latex")
	finish
endif
let b:did_latex = 1

" Convert straight quotes to LaTeX style
map!  <silent> <buffer> #2 /"vn
vmap <silent> <buffer> #2 r'a'Nr`a`
" Add LaTeX emphasis to higlighted region
vmap <silent> <buffer> #3 di\emph{}P
vmap <silent> <buffer> #4 di\footnote{}P
vmap <silent> <buffer> #5 di\chapter{}P
vmap <silent> <buffer> #6 di\section{}P
vmap <silent> <buffer> #7 di\subsection{}P
"vmap <silent> <buffer> #5 di\direct{}P
" map  <silent> <buffer> #4 s\={"}
map  <silent> <buffer> <F8>  :!latex  -file-line-error -jobname=fiction screen
map  <silent> <buffer> <F9>  :!latex -file-line-error -jobname=fiction screen
map  <silent> <buffer> <F10> :!latex -file-line-error -jobname=fiction print_landscape
map  <silent> <buffer> <F11> :!latex -file-line-error -jobname=fiction print
set formatoptions=n
"set scrolloff=999 " keep cursor in middle of screen.

" Hilight                                                                  {{{
hi! link Folded Error
hi! Comment term=bold ctermfg=yellow
hi! link directory Comment
hi! link Statement Question
hi! link Constant ModeMsg
hi! link Search Fold
" }}}

"map  <silent> <buffer> <F11> I%{{{
"map  <silent> <buffer> <F11> 0"ld$i% {{{\section{l}
"map  <silent> <buffer> <F12> I% }}}

"set foldtext=MyFoldText()
set foldmethod=marker

"function! ToggleFold()
"  if foldlevel('.') == 0
"	 " No fold exists at the current line,
"	:!fold.pl
"  else
"	 :!fold.pl -u 
"  endif
"endfunction

"nmap <space> :call ToggleFold()<CR>
"vmap <space> :!fold.pl 

"function! MyFoldText()
"  let line = getline(v:foldstart+1)
"  return v:folddashes . line
"endfunction

" Smart quotes.                                                            {{{
" Thanks to Ron Aaron <ron@mossbayeng.com>.
function! s:TexQuotes()
    let insert = "''"
    let left = getline('.')[col('.')-2]
    if left =~ '^\(\|\s\)$'
	let insert = '``'
    elseif left == '\'
	let insert = '"'
    endif
    return insert
endfunction
inoremap <buffer> " <C-R>=<SID>TexQuotes()<CR>
" }}}

au! Bufleave *.(tex) mapclear <buffer>
au! Bufleave *.(tex) vmapclear <buffer>
"au! Bufleave *.(tex) set foldtext=foldtext()

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Special Stuff for LaTeX files
""""""""""""""""""""""""""""""""""""""""""""""""""""""
"au BufEnter *.tex set autowrite "Save the file before each call of make"
"au BufEnter *.tex set updatetime=1000 "save 1000 milliseconds after not moving"
"au BufEnter *.tex set makeprg=latex\ -silent\ -ps\ screen\ >/dev/null "make the ps file, suppress output"
"au BufEnter *.tex set efm=%A%f:%l:\ %m,%-Z%p^,%-C%.%#  "describes error format so that you do not get meta-errors"

"make the file after *updatetime* ms of not moving and after every save"
"au CursorHold *.tex call UpdateFile()
"au BufWritePost *.tex call UpdateFile()

" update function
"function! UpdateFile()
"    silent make
"    redraw!       "redraw is necessary to remove artifacts during saves
"endfunction
