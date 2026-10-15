if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
	autocmd! BufNewFile,BufRead *.pl      setfiletype perl
	autocmd! BufNewFile,BufRead *.md      setfiletype markdown
	autocmd! BufNewFile,BufRead *.sco     setfiletype c
	autocmd! BufNewFile,BufRead *.pm      setfiletype perl
	autocmd! BufNewFile,BufRead *.cgi     setfiletype perl
	autocmd! BufNewFile,BufRead *.conf    setfiletype html
	autocmd! BufNewFile,BufRead *.tmpl    setfiletype html
	autocmd! BufNewFile,BufRead *.html?   setfiletype html
	autocmd! BufNewFile,BufRead *.tex     setfiletype latex
	autocmd! BufNewFile,BufRead *.twiki   setfiletype twiki
augroup END
runtime! ftdetect/*.vim
