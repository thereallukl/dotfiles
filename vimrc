filetype off
execute pathogen#infect()
call pathogen#infect()
call pathogen#helptags() " generate helptags for everything in 'runtimepath'


set autoindent
set cindent
set t_Co=256
set mouse=a
set number
set tabstop=4
set shiftwidth=4
set hlsearch
set incsearch
set paste
" set textwidth=79


colorscheme molokai
filetype plugin indent on
syntax on
let NERDTreeQuitOnOpen = 0
autocmd VimEnter * NERDTree
nnoremap <F5> :buffers<CR>:buffer<Space>
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" close vim if NERDTree is last window
function! s:CloseIfOnlyControlWinLeft()
  if winnr("$") != 1
      return
  endif
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
          \ || &buftype == 'quickfix'
      q
        endif
endfunction
augroup CloseIfOnlyControlWinLeft
  au!
    au BufEnter * call s:CloseIfOnlyControlWinLeft()
augroup END

" set colorscheme
colorscheme darkblue

" code completion
set omnifunc=syntaxcomplete#Complete

" start syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


set rtp+=/data/Projects/dotfiles/powerline/powerline/bindings/vim


let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }


set tags=./tags;/

