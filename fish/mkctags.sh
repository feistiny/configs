function mkc() {
  local _x _cfp _f
  if [[ $- =~ x ]]; then
    _x='-x'
  fi
  cp ${shell_dir}/.ctags ~
  _cfp="${_cfp:-.ctagsignore}" _f="${_f-.tags}" bash ${_x-} ${snippets_dir}/ctags/generate_ctags
}
