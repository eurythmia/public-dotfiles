" LilyPond                                                                 {{{
	set runtimepath^=/usr/share/lilypond/2.24.1/vim
	autocmd FileType lilypond compiler lilypond
" }}}

" Options                                                                  {{{
	syn on                            " Enable Syntax highlighting
	set directory=$HOME/.vim_swapfiles//
	set backupdir=$HOME/.vim_backups//
	set viewdir=$HOME/.vim_viewdir//
	set autoindent                    " Copy indent from current line when starting a new line
	set nocompatible                  " Take advantage of vim features not present in vi
	set nowrap                        " Turn off autowrapping
	set bs=2                          " Allow backspacing over everything in insert mode
	set cmdheight=2                   " Set height of command line to 2 lines
	set ignorecase                    " Ignore case for searches
	set showmode                      " Show mode (insert, replace, etc.)
	set ruler                         " Show cursor position
	set showmatch                     " Show matching brace
	set sh=tcsh                       " Set shell to tcsh
	set grepprg=grep\ -i              " Define grep program
	set tabstop=4                     " Set tabs to 4 chars
	set shiftwidth=4                  " Set shiftwidth to 4 chars
	"set hardtabs=4                    " Set hardtabs to 4 chars
	set visualbell                    " Don't beep at me
	set t_Co=256                      " set 256 colors
	behave xterm                      " Don't be like windows
	filetype plugin indent on         " Load filetype plugins from .vim/after/ftplugin
	let loaded_matchparen=0           " Disable the standard matchparen plugin
	let g:netrw_dirhistmax=0          " Don't store directories.
	"set shellredir=\>\&              " Change default redir of shell to include stderr
	"set nofoldenable

	" ScrollColors plugin :SCROLL to jump through various schemes.
	" colorscheme cosmic_latte
	" colorscheme Mustang
	" colorscheme zenburn
	" colorscheme fu        
	" colorscheme golden        
	" colorscheme greyhouse
	" colorscheme herald
	" colorscheme solarized
	" colorscheme jellybeans
	" colorscheme synic
	" colorscheme candy
	" colorscheme candycode
	" colorscheme chella_light
	" colorscheme cleanphp
	" colorscheme dante
	" colorscheme darkz
	" colorscheme tir_black
	" colorscheme wombat256
	" colorscheme vibrantink
	" colorscheme vimhut
	" colorscheme tirblack
	" colorscheme synic
	" colorscheme summerfruit256
	" colorscheme sorcerer
	" colorscheme calmar256-dark
	" colorscheme desert
	" colorscheme blackbeauty
	colorscheme koehler

"                                                                          }}}

" Global Abbreviations                                                     {{{
ca rc e $HOME/.vimrc
ca ni e $HOME/.tcshrc
map K gwap
map <silent><F3> :NEXTCOLOR<cr>  " Scroll through color schemes
map <silent><F2> :PREVCOLOR<cr>
"                                                                          }}}

" AutoCommands                                                             {{{
if !exists("autocommands_loaded")
    let autocommands_loaded = 1
    "set verbose=9 " Uncomment this line to debug autcmnds.

    " Always lcd to the directory of the current file.
    au BufEnter * execute ":lcd " . expand("%:p:h")

    " Always jump to the last known cursor position.
    " autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |  exe "normal g" | endif

    " Automatically Save and Restore Folds
    au BufWinLeave * silent! mkview
    au BufWinEnter * silent! loadview

endif
" }}}

filetype plugin indent on
call pathogen#infect() 
