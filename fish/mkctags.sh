function mkc() {
  mkcr 1>/dev/null 2>&1
  mkcw 1>/dev/null 2>&1
  find -maxdepth 1 -type f -name '*.tags' -exec ls -lh {} \; >&2
}

function mkcw() {
  local _x _cfp _f
  if [[ $- =~ x ]]; then
    _x='-x'
  fi
  [[ "$f" ]] && [[ $f =~ .*tags ]] && [[ -e $f ]] && { rm "$f"; }
  _cfp='.read.ctags .write.ctags' _f='.write.tags' bash ${_x-} ${snippets_dir}/ctags/generate_ctags
  find -maxdepth 1 -type f -name '*.tags' -exec ls -lh {} \; >&2
}

function mkcr() {
  local _x _cfp _f
  if [[ $- =~ x ]]; then
    _x='-x'
  fi
  [[ "$f" ]] && [[ $f =~ .*tags ]] && [[ -e $f ]] && { rm "$f"; }
  _cfp='.read.ctags' _f='.read.tags' bash ${_x-} ${snippets_dir}/ctags/generate_ctags
  find -maxdepth 1 -type f -name '*.tags' -exec ls -lh {} \; >&2
}
