" Experimental thesaurus lookup
" FIXME: This works, but there's a bug to squash
" SyntaxError - E492: Not an editor command: <selected_word> (see vim-jp/vim-vimlparser)
augroup vim-wordsmith/thesaurus | autocmd!
  " z- thesaurus, mnemonic z= suggests bad words
  nnoremap z- :call Suggest(expand('<cword>'))<CR>
  vnoremap z- y:call Suggest('<C-r>0')<CR>

  let s:thesaurus = {}
  function! Suggest(word)
    if len(s:thesaurus) == 0
      for line in readfile(&thesaurus)
        let parts = split(line, ',')
        let [word, synonyms] = [parts[0], parts[1:]]
        let s:thesaurus[word] = synonyms
      endfor
    endif

    let synonyms = s:thesaurus[a:word][:&lines - 2]
    let synonyms = map(synonyms, { i, synonym -> (i+1) . '. ' . synonym })
    let choice = inputlist(synonyms)
    let replace = s:thesaurus[a:word][choice-1]
    echo "\nYou selected " . replace
    execute 'normal! ciw' . replace
  endfunction
augroup END
