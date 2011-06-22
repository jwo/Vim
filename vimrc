" Pathogen*********************************************************************
call pathogen#runtime_append_all_bundles() 

" Colors **********************************************************************
"set t_Co=256 " 256 colors
set background=dark 
set number
syntax on " syntax highlighting
colorscheme ir_black
" RVM *************************************************************************
set statusline+=%{rvm#statusline()}

set shiftwidth=2
set tabstop=2


