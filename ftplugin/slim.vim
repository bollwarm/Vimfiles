set foldmethod=indent

let b:surround_{char2nr('t')} = "= t '\r' "

let b:switch_definitions =
      \ [
      \   g:switch_builtins.ruby_hash_style,
      \ ]

nmap <buffer> dh <Plug>CoffeeToolsDeleteAndDedent
xmap <buffer> dh <Plug>CoffeeToolsDeleteAndDedent
nmap <buffer> <localleader>O  <Plug>CoffeeToolsOpenLineAndIndent
xmap <buffer> <localleader>O  <Plug>CoffeeToolsOpenLineAndIndent
