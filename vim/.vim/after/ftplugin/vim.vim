if exists("b:did_vim")
	finish
endif
let b:did_vim = 1

map <silent> <buffer> #9 :call Test()
map <silent> <buffer> #10 :so %

au! Bufleave *.(vim) mapclear <buffer>
au! Bufleave *.(vim) vmapclear <buffer>
