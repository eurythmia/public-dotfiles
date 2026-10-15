if exists("b:did_rtcmix")
	finish
endif
let b:did_rtcmix = 1

setlocal makeprg=CMIX\ %

" Sample errors:
" Type of arg 1 to push must be array (not hash element) at NFrame.pm line 129, near ");"
" Useless use of a constanst at test.pl line 5.
setlocal errorformat=%m\ at\ %f\ line\ %l%.%#,
                    \%-G%.%# " ignore any lines that didn't match one of the patterns above

" Autocommands
" augroup rtcmix
" augroup END
autocmd BufNewFile,BufRead *.sco set syntax=C

" Maps
" map <silent> <buffer> <F3>  :w:%!cmix
" map <silent> <buffer> <F4>  :w:%!pcmix
" map <silent> <buffer> <F9>  :%!perltidy
" vmap <silent> <buffer> <F9> :!perltidy
