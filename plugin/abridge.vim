" File: abridge.vim
" Author: justin domingue <domingue.justin@gmail.com>
" Last Change: Fri 28 Feb 12:53:05 2014
" Version: 0.02
" Credits: batman990 (iabassist.vim), Vim Wiki
" Usage:
" 
" call Abridge("from", "to", "filetype")
"         from : abbreviation
"           to : expanded expression
"     filetype : file type on which to apply the abbreviation ('*' for all
"     file types)
" 
" ,, select next placeholder
"

" Do not load more than once, but allow the user to force reloading
if exists('loaded_abridge') && loaded_abridge == 1
  finish
endif
let loaded_abridge = 1

" _abridge_ holds the abbreviations
augroup abridge
  autocmd!    
 augroup END

" ============================
"         FUNCTIONS
" ============================

" Help delete character if it is 'empty space'
" stolen from Vim manual
function! Eatchar()
  let c = nr2char(getchar())
  return (c =~ '\s') ? '' : c
endfunction

" Replace abbreviation if we're not in comment or other unwanted places
" stolen from Luc Hermitte's excellent http://hermitte.free.fr/vim/
function! ExpandIfSafe(key, seq)
  let syn = synIDattr(synID(line('.'),col('.')-1,1),'name')
  if syn =~? 'comment\|string\|character\|doxygen'
    return a:key
  else
    exe 'return "' .
    \ substitute( a:seq, '\\<\(.\{-}\)\\>', '"."\\<\1>"."', 'g' ) . '"'
  endif
endfunction

" Helper function to add abbreviations according to a Filetype
function! Abridge(from, to, filetype)
  exec "autocmd abridge Filetype " . a:filetype . 
        \ " inoreab <silent> <buffer> " . a:from . " <C-R>=ExpandIfSafe('" .
        \ a:from . "', '" .  escape(a:to . '<C-R>=Eatchar()<CR><ESC>?<1><CR>:noh<CR>vf>c<C-R>=Eatchar()<CR>', '<>\"') .
        \ "')<CR>"
endfunction


" ============================
"           MAPPINGS
" ============================

if !exists('g:abridge_map_keys')
    let g:abridge_map_keys = ",,"
endif

execute "noremap " . g:abridge_map_keys . " /<\d><CR>:noh<CR>vf>c"
execute "inoremap " . g:abridge_map_keys . "  <ESC>/<\d><CR>:noh<CR>vf>c"

" ============================
"   ABBREVIATION DEFINITIONS
" ============================

" Do not define the abbreviations if the user doesn't want to
" User has to put `let abridge_abbreviations = 1` in it's vimrc
if exists('abridge_default_abb')
  finish
endif

" C abbreviations {{{

" flow control
call Abridge("if", "if(<1>) {<cr><2><CR>}", "c,cpp")
call Abridge("ife", "if(<1>) {<CR><2><CR>} else {<CR><3><CR>}", "c,cpp")
call Abridge("switch", "switch(<1>) {<CR>case <2>:<CR>}", "c,cpp")

" loops
call Abridge("for", "for(<1>; <2>; <3>) {<CR><4><CR>}", "c,cpp")
call Abridge("while", "while(<1>) {<CR><2><CR>}", "c,cpp")
call Abridge("dowhile", "do {<CR><CR>} while(<1>);", "c,cpp")

" variables
call Abridge("inti", "int i = 0;<cr><1>", "c,cpp")

" functions
call Abridge("funi", "int <1>(<2>) {<CR><3><CR>}", "c,cpp")
call Abridge("funip", "int <1>(<2>);", "c,cpp")
call Abridge("fun", "<1> <2>(<3>) {<CR><3><CR>}", "c,cpp")
call Abridge("funp", "<1> <2>(<3>);", "c,cpp")

" operators
call Abridge("tern", "<1> ? <2> : <3>;", "c,cpp")

" structs
call Abridge("stru", "struct <1> {<CR><2><CR>};", "c,cpp")
call Abridge("strut", "typedef struct <1> {<CR><2><CR>};", "c,cpp")

" C preprocessor directives
call Abridge("#i", "#include <<1>>", "c,cpp")
call Abridge("#I", '#include "<1>"', "c,cpp")
call Abridge("#d", "#define <1>", "c,cpp")

" Templates
call Abridge("main", "int main(int argc, char *argv[]) {<CR><1><CR>}", "c,cpp")"

" }}}
