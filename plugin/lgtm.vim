function! s:lgtm()
  let res = webapi#http#get("http://www.lgtm.in/g", {}, {"Accept": "application/json"})
  if &ft == 'markdown'
    let content = webapi#json#decode(res.content)['markdown']
  elseif &ft == 'html'
    let content = '<img src="' . webapi#json#decode(res.content)['imageUrl'] . '" alt="LGTM">'
  else
    let content = webapi#json#decode(res.content)['imageUrl']
  endif
  let line = getline('.')
  let indent = matchstr(line, '^\s\+')
  let content = join(map(split(content, "\n"), 'indent . v:val'))
  if line =~ '^\s\+$'
    call setline('.', content)
  else
    put! =content
  endif
  return ''
endfunction

inoremap <plug>(lgtm) <c-r>=<sid>lgtm()<cr>
nnoremap <plug>(lgtm) :<c-u>call <sid>lgtm()<cr>

if !hasmapto('<Plug>(lgtm)')
\  && (!exists('g:lgtm_no_default_key_mappings')
\      || !g:lgtm_no_default_key_mappings)
  silent! map <unique> <leader>lgtm <plug>(lgtm)
endif

command! LGTM call s:lgtm()
