" Experimental thesaurus lookup
" FIXME: This works, but there's a bug to squash
" SyntaxError - E492: Not an editor command: <selected_word> (see vim-jp/vim-vimlparser)
augroup vim-wordsmith/thesaurus | autocmd!
  " z- thesaurus, mnemonic z= suggests bad words
  nnoremap z- :call Suggest(expand('<cword>'))<CR>
  vnoremap z- y:call Suggest('<C-r>0')<CR>

  let s:thesaurus_map = {}
  function! Suggest(word)
    if len(s:thesaurus_map) == 0
      for line in readfile(&thesaurus)
        let parts = split(line, ',')
        let [word, synonyms_in] = [parts[0], parts[1:]]
        let s:thesaurus_map[word] = synonyms_in
      endfor
    endif

    let key = tolower(a:word)
    let limit = &lines - 2
    let synonyms_out = s:thesaurus_map[key][0:limit]
    let options = map(synonyms_out, { i, synonym -> (i+1) . '. ' . synonym })
    let choice = inputlist(options)
    let replace = s:thesaurus_map[a:word][choice-1]
    echo "\nYou selected " . replace
    execute 'normal! ciw' . replace
  endfunction
augroup END
