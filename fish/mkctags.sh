function mkcr() {
  local _x _cfp _f
  if [[ $- =~ x ]]; then
    _x='-x'
  fi
  _cfp="${_cfp:-.ctagsignore}" _f="${_f-.tags}" bash ${_x-} ${snippets_dir}/ctags/generate_ctags
}
