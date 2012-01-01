" Annoying, remove:
nnoremap s <Nop>
nnoremap Q <Nop>

" Easily mark a single line in character-wise visual mode
nnoremap vv _vg_

" <space>x -> :X
" For easier typing of custom commands
nnoremap <space>      :call <SID>SpaceMapping(0)<cr>
xnoremap <space> :<c-u>call <SID>SpaceMapping(1)<cr>
function! s:SpaceMapping(visual)
  echo
  let c = nr2char(getchar())
  if a:visual
    normal! gv
  endif
  call feedkeys(':'.toupper(c))
endfunction

" Motion for "next/last object". For example, "din(" would go to the next "()" pair
" and delete its contents.
onoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
onoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
xnoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
onoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
xnoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
function! s:NextTextObject(motion, dir)
  let c = nr2char(getchar())

  if c ==# "b"
    let c = "("
  elseif c ==# "B"
    let c = "{"
  elseif c ==# "d"
    let c = "["
  endif

  exe "normal! ".a:dir.c."v".a:motion.c
endfunction

" Always move through visual lines:
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk

" Moving through tabs:
nnoremap <C-l> gt
nnoremap <C-h> gT

" Moving through splits:
nnoremap gh <C-w>h
nnoremap gj <C-w>j
nnoremap gk <C-w>k
nnoremap gl <C-w>l

" Faster scrolling:
nmap J 5j
nmap K 5k
xmap J 5j
xmap K 5k

" Upcase current word
nnoremap <C-u> mzgUiw`z

" Completion remappings:
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>
inoremap <C-o> <C-x><C-o>
inoremap <C-u> <C-x><C-u>
inoremap <C-f> <C-x><C-f>
inoremap <C-]> <C-x><C-]>
inoremap <C-l> <C-x><C-l>
set completefunc=syntaxcomplete#Complete

" For digraphs:
inoremap <C-n> <C-k>

" Splitting and joining code blocks
nnoremap sj :SplitjoinSplit<CR>
nnoremap sk :SplitjoinJoin<CR>
" Execute normal vim join if in visual mode
xnoremap sk J

" Inline edit
nnoremap ,e    :InlineEdit<cr>
xnoremap ,e    :InlineEdit<cr>
inoremap <c-e> <esc>:InlineEdit<cr>a

" Split and execute any command:
nnoremap __ :split \|<Space>

" Zoom current window in and out:
nnoremap ,, :ZoomWin<cr>

" Open new tab more easily:
nnoremap ,t :tabnew<cr>
nnoremap ,T :tabedit %<cr>gT:quit<cr>

" Standard 'go to manual' command
nnoremap gm :call lib#OpenUrl('http://google.com/search?q=' . expand("<cword>"))<cr>

" Paste in insert and command modes
inoremap <C-p> <Esc>pa
cnoremap <C-p> <C-r>"

" Returns the cursor where it was before the start of the editing
nmap . .`[

" Delete surrounding function call
" TODO doesn't work for method calls
" TODO relies on braces
nmap dsf F(bdt(ds(

" See startup/commands.vim
nnoremap QQ :Q<cr>

" https://github.com/bjeanes/dot-files/blob/master/vim/vimrc
" For when you forget to sudo.. Really Write the file.
command! W call s:SudoWrite()
function! s:SudoWrite()
  write !sudo tee % >/dev/null
  e!
endfunction

" Run current file -- filetype-specific
nnoremap ! :Run<cr>
xnoremap ! :Run<cr>

" Yank current file's filename
nnoremap gy :call <SID>YankFilename(0)<cr>
nnoremap gY :call <SID>YankFilename(1)<cr>
function! s:YankFilename(linewise)
  let @@ = expand('%:p')

  if (a:linewise) " then add a newline at end
    let @@ .= "\<nl>"
  endif

  let @* = @@
  let @+ = @@

  echo "Yanked filename in clipboard"
endfunction

" Tabularize mappings
" For custom Tabularize definitions see after/plugin/tabularize.vim
nnoremap sa      :call <SID>TabularizeMapping(0)<cr>
xnoremap sa :<c-u>call <SID>TabularizeMapping(1)<cr>
function! s:TabularizeMapping(visual)
  echohl ModeMsg | echo "-- ALIGN -- "  | echohl None
  let align_type = nr2char(getchar())
  if align_type     == '='
    call s:Tabularize('equals', a:visual)
  elseif align_type == '>'
    call s:Tabularize('ruby_hash', a:visual)
  elseif align_type == ','
    call s:Tabularize('commas', a:visual)
  elseif align_type == ':'
    call s:Tabularize('colons', a:visual)
  elseif align_type == ' '
    call s:Tabularize('space', a:visual)
  else " just try aligning by the character
    call s:Tabularize('/'.align_type, a:visual)
  end
endfunction
function! s:Tabularize(command, visual)
  normal! mz

  let cmd = "Tabularize ".a:command
  if a:visual
    let cmd = "'<,'>" . cmd
  endif
  exec cmd
  echo

  normal! `z
endfunction

" Tabularize "reset" -- removes all duplicate whitespace
nnoremap s= :call <SID>TabularizeReset()<cr>
xnoremap s= :call <SID>TabularizeReset()<cr>
function! s:TabularizeReset()
  let original_cursor = getpos('.')

  s/\S\zs \+/ /g
  call histdel('search', -1)
  let @/ = histget('search', -1)

  call setpos('.', original_cursor)
endfunction

" Get rid of annoying register rewriting when pasting on visually selected
" text.
"
" Note: magic
function! RestoreRegister()
  let @" = s:restore_reg
  let @* = s:restore_reg_star
  let @+ = s:restore_reg_plus
  return ''
endfunction
function! s:Repl()
  let s:restore_reg      = @"
  let s:restore_reg_star = @*
  let s:restore_reg_plus = @+
  return "p@=RestoreRegister()\<cr>"
endfunction
xnoremap <silent> <expr> p <SID>Repl()

" NERD tree:
nnoremap gn :NERDTreeToggle<cr>
nnoremap gN :NERDTree<cr>

nnoremap <Leader>f :NERDTreeFind<cr>

" Open path with external application
nnoremap gu :Open<cr>
xnoremap gu :Open<cr>
