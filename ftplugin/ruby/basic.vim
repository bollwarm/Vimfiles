if exists('b:erb_loaded')
  finish
endif

setlocal softtabstop=2
setlocal shiftwidth=2
setlocal expandtab

setlocal foldmethod=indent

compiler ruby
setlocal makeprg=ruby\ -wc\ %

let b:dh_closing_pattern = '^\s*end\>'
let b:outline_pattern = '\v^\s*(def|class|module|public|protected|private|(attr_\k{-}))(\s|$)'

call RubyFold()
setlocal nofoldenable

" Look up the word under the cursor on apidock:
nnoremap <buffer> gm :Doc ruby<cr>
