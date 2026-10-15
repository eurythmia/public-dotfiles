"" abort if b:did_html_maps is true: already loaded or user pref
if exists("b:did_html")
	finish
endif
let b:did_html = 1

function! Addtag()
let $tag = input ("Enter Tag: ")
let @x = "<" . $tag . ">" . @@ . "</" . $tag . ">"
let @t = '"xP'
@t
endf

function! Redotag()
let @x = "<" . $tag . ">" . @@ .  "</" . $tag . ">"
@t
endf

map!  <silent> <buffer> <F7> 0d$:call Addtag()
map!  <silent> <buffer> <F6> 0d$:call Redotag()
vmap  <silent> <buffer> <F7> d:call Addtag()
vmap  <silent> <buffer> <F6> d:call Redotag()
map!  <silent> <buffer> <F9> dt<
map!  <silent> <buffer>  <p>
map!  <silent> <buffer>  <br>
ca <silent> <buffer> hr i<a href=></a>F> " Insert a hyperlink
