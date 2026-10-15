if exists("b:did_perl")
	finish
endif
let b:did_perl = 1

setlocal makeprg=perl\ -Wc\ %

" Sample errors:
" Type of arg 1 to push must be array (not hash element) at NFrame.pm line 129, near ");"
" Useless use of a constanst at test.pl line 5.
setlocal errorformat=%m\ at\ %f\ line\ %l%.%#,
                    \%-G%.%# " ignore any lines that didn't match one of the patterns above

" Autocommands
"augroup perltidy
"	autocmd! VimEnter,BufReadPost,FileReadPost,FilterReadPost	*.pl   '[,']!perltidy
"	autocmd! VimEnter,BufReadPost,FileReadPost,FilterReadPost	*.pm   '[,']!perltidy
"	autocmd! VimEnter,BufReadPost,FileReadPost,FilterReadPost 	*.cgi  '[,']!perltidy
"	autocmd! BufWritePre,FileWritePre	*.pl  '[,']!perltidy --pro=$HOME/.mike_perltidyrc
"	autocmd! BufWritePre,FileWritePre	*.pm  '[,']!perltidy --pro=$HOME/.mike_perltidyrc
"	autocmd! BufWritePre,FileWritePre	*.cgi '[,']!perltidy --pro=$HOME/.mike_perltidyrc
"augroup END

" Maps
map <silent> <buffer> <F3>  :w:make
map <silent> <buffer> <F4>  :w:%!perl -w
map <silent> <buffer> <F5>  :w:%!PCMIX
map <silent> <buffer> <F9>  :%!perltidy
vmap <silent> <buffer> <F9> :!perltidy
