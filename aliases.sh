#!/bin/bash
stty -ixon
export shell_dir="$HOME/configs"
export plugins_dir="$HOME/configs/plugins"
export ansible_dir="$HOME/configs/ansible"
export snippets_dir="${shell_dir}/snippets"
export fish_dir="${shell_dir}/fish"

# git clone in the root(~) dir #

# ls aliases #
alias l='ls -al'
alias lh='ls -alh'
alias la='ls -a'
alias lla='ll -a'
alias lsd='ls -l | grep ^d'
alias clr='clear'
alias cls='clear; ls'
alias cll='clear; ls -al'
alias cla='clear; ls -a'
alias vu="vim -u ${shell_dir}/.vimrc"
alias his="history | tail -100"
alias ext="unset HISTFILE && exit"

alias ag="ansible-galaxy -i ${ansible_dir}/hosts"
alias ap="ansible-playbook -i ${ansible_dir}/hosts"
alias ansible="ansible -i ${ansible_dir}/hosts"
function getSnippetsDirs() {
  local _dirs
  _dirs=(
  $HOME/.vim/plugged/vim-snippets \
  ${shell_dir}/UltiSnips \
  $(pwd)/UltiSnips \
  )
  echo ${_dirs[@]}
}
function lesp() {
  local _files
  _files=$(find $(getSnippetsDirs) -type f -name "${1-php}.snippets");
  if [[ -n "$_files" ]]; then
    glsot "$_files"
  else
    find $(getSnippetsDirs) -type f -name "*${1-php}*.snippets"
  fi
}
alias cpec="cp -i ${shell_dir}/.editorconfig ."
alias mdv='mdv -t 729.8953'
alias watch='watch --color'
source "${fish_dir}/mkctags.sh"
function pcsd() {
  local _dir
  _dir="${*:-.}"
  php-cs-fixer fix --config ${shell_dir}/.php_cs --allow-risky yes "$_dir"
}
alias aiy='apt install -y'
alias adi='gets .gitignore.example >> .gitignore'

set -o emacs
if [[ -z "$exec_in_vim" ]]; then
  # vi and emacs editing mode configs
  bind "set show-mode-in-prompt on"
  bind 'set emacs-mode-string "‚ôã "'
  bind 'set vi-ins-mode-string "‚ò∫ "'
  bind 'set vi-cmd-mode-string "Ì†ΩÌ±â "'
  bind -m vi-insert  '"\C-\M-J": emacs-editing-mode'
  bind -m vi-command '"\C-\M-J": emacs-editing-mode'
  bind -m emacs      '"\C-\M-J": vi-editing-mode'
  bind -m vi-insert '"\e.": yank-last-arg'
  bind -m vi-insert '"\e\C-y": yank-nth-arg'
  bind -m vi-command '"\e.": yank-last-arg'
  bind -m vi-command '"\e\C-y": yank-nth-arg'
  bind -m vi-insert '"\C-p": history-search-backward'
  bind -m vi-insert '"\C-n": history-search-forward'
  bind -m emacs '"\C-p": history-search-backward'
  bind -m emacs '"\C-n": history-search-forward'
  export VISUAL=vu
fi

# templaet snippets
alias tpl='sempl -o -f'
function stpl() {
  tpl "${@:1:$(($#-1))}" <(gets "${@: -1}")
}

# reaload aliases.sh #
alias rea="source ${shell_dir}/aliases.sh && echo 'reloaded'"
function tml() {
  big=$(tmls | grep -v 'attached' | tail -1 | cut -d' ' -f1)
  if [[ -n $big ]]; then
    \tmux -f ${shell_dir}/.tmux.conf attach -t ${1-${big}}
  else
    tmls
  fi
}
alias tmll='\tmux'" -f ${shell_dir}/.tmux.conf"
alias tmls='\tmux ls'
function tmks() {
  local i
  for i in "$@"
  do
    \tmux kill-session -t $i
  done
}
alias tmkr='\tmux kill-server'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# laravel artisan #
alias cmp='composer'
alias cmpdp="cmp dumpautoload"
php_artisan='php artisan'
alias art=${php_artisan}
alias art.cont="${php_artisan} make:controller"
alias art.model="${php_artisan} make:model"
alias art.mig="${php_artisan} make:migration"
alias art.mid="${php_artisan} make:middleware"
alias artm="${php_artisan} migrate"
alias artms="${php_artisan} migrate:status"
alias artmr="${php_artisan} migrate:rollback"
alias db:reset="php artisan migrate:reset && php artisan migrate --seed"

# git #
alias gbr='git branch'
alias gceu='gcf user.name "lzf" && gcf user.email "liuzhanfei167@126.com"'
alias gcf='git config'
alias gcfg='git config --global'
alias gcp='git cherry-pick'
alias gci='git commit'
function get_commitid_by_msg() {
  local _commitid _line OLD_IFS commit
  _line=$(echo "$*" | sed '/^$/d' | wc -l)
  if [[ $_line -eq 1 ]]; then
    echo "$*" | cut -d' ' -f1
  elif [[ $_line -gt 1 ]]; then
    OLD_IFS=${IFS}
    OLD_PS3=${PS3}
    IFS=$'\n'
    PS3="choose a commit: "
    select commit in $(echo "$*"); do
      if [[ -n $commit ]]; then
        echo $commit | cut -d' ' -f1
        break
      else
        echo 'out of range'
      fi
    done
    IFS=${OLD_IFS}
    PS3=${OLD_PS3}
  else
    echo 'commit message grep-results is none'
    return 1
  fi
}
function get_select_option() {
  local _line OLD_IFS _opt
  _line=$(echo "$*" | sed '/^$/d' | wc -l)
  if [[ $_line -eq 1 ]]; then
    echo "$*"
  elif [[ $_line -gt 1 ]]; then
    OLD_IFS=${IFS}
    OLD_PS3=${PS3}
    IFS=$'\n'
    PS3="choose an option: "
    select _opt in $(echo "$*"); do
      if [[ -n $_opt ]]; then
        echo $_opt
        break
      else
        echo 'out of range'
      fi
    done
    IFS=${OLD_IFS}
    PS3=${OLD_PS3}
  else
    echo 'optoins is none'
    return 1
  fi
}
function multi_select() {
  local _line OLD_IFS options num choices prompt msg
  options=($*)
  _line=$(echo "$*" | sed '/^$/d' | wc -l)
  if [[ $_line -eq 1 ]]; then
    echo "$*"
  elif [[ $_line -gt 1 ]]; then
    OLD_IFS=${IFS}
    IFS=$'\n'
		echo "Avaliable options:" >&2
		function __show_menu() {
      printf "%3d%s) %s\n" 0 " " '!!!CHOOSE THIS WHEN DONE!!!' >&2
      for i in "${!options[@]}"; do
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}" >&2
      done
      if [[ -n $msg ]]; then
        echo "$msg" >&2
      fi
		}
    prompt="check an option (again to uncheck, choose DONE when done): "
		while __show_menu && read -rp "$prompt" num ; do
      [[ $num == 0 ]] && { break; }
      [[ -z $num ]] && { continue; }
			[[ "$num" != *[![:digit:]]* ]] &&
			(( num > 0 && num <= ${#options[@]} )) ||
			{ msg="Invalid option: $num"; continue; }
			((num--)); msg="${options[num]} was ${choices[num]:+un}checked"
			[[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
		done
		for i in ${!options[@]}; do
			[[ "${choices[i]}" ]] && { printf "%s\n" "${options[i]}"; }
		done
    IFS=${OLD_IFS}
  else
    echo 'optoins is none' >&2
    return 1
  fi
}
function gcif() {
  local _commit
  if [[ -z $1 ]]; then
    echo 'just type to grep msg'
    return 2
  fi
  if [[ $(git cat-file -t $1) = 'commit' ]]; then
    _commit=$1
  else
    _commit=$(get_commitid_by_msg "$(git log --oneline --grep "$1" | grep -v 'fixup!')")
  fi
  git commit --fixup $_commit
}
alias grb='git rebase'
alias grbc='git rebase --continue'
function grbs() {
  local _commitid _previd
  # git rebase --autosquash after greped commit
  if [[ -z $1 ]]; then
    echo 'grep a commit message to autosquash'
    return 1
  fi
  _commitid=$(get_commitid_by_msg "$(git log --oneline --grep "$1" | grep -v 'fixup!')")
  if [[ -n $_commitid ]]; then
    _previd=$(git rev-parse $_commitid^ | cut -c -7)
    if [[ -n $_previd ]]; then
      git rebase -i --autosquash "$_previd"
    fi
  fi
}
alias gcii='git -c user.name="lzf" -c user.email="liuzhanfei166@126.com" commit'
alias gcia='git commit --amend -C HEAD'
function gcim() {
  local msg
  msg="${@: -1}"
  git commit "${@: 1:$(($#-1))}" -m "${msg:-+++}"
}
alias gciac='git commit --amend -c HEAD'
alias gciap='git commit --amend -C HEAD && git push -f'
function gcimp() {
  local msg
  msg=${1:-+++}
  git commit -m "$msg" && git push ${@:2}
}
alias gclo='git clone'
function gcls() {
  git clone --single-branch -b "$2" "$1"
}
alias gcle='git clean'
alias gco='git checkout'
function gcom() {
  local _files _grep _prompt
  _grep="$1"
  [[ $_grep ]] || {
    _prompt='grep a file name: '
    echo 'checkout multi files from HEAD'
    echo -n "$_prompt"
    while read -p '' _grep
    do
      [[ $_grep ]] && break || { echo -n "$_prompt"; continue; }
    done
  }
  if [[ $_grep ]]; then
    # grep file of the HEAD to checkout
    _files=$(multi_select "$(git diff HEAD --name-only | grep "$_grep")")
    gco "$_files"
  fi
}
alias gdf="git diff --color $(git diff --ws-error-highlight=new,old &>/dev/null && echo --ws-error-highlight=new,old)"
alias gdfc='gdff --cached'
function gdff() {
  git_last $@
  gdf $_rest $_last
  git_last_unset
}
function gdfcf() {
  gdf --cached "*${1}*"
}
alias gfe='git fetch'
alias gl='git log --oneline'
alias glgs='git log -S'
alias glsp='git log -p -S'
function glp() {
  git_last $@
  git log --oneline -p ${_rest:=-1} $_last
  git_last_unset
}
function gld() {
  local diff_branch current_branch upstream
  diff_branch="$1"
  if [[ ! -n "$1" ]]; then
    current_branch=$(git rev-parse --abbrev-ref HEAD);
    upstream=$(git rev-parse --abbrev-ref ${current_branch}@{upstream});
    diff_branch="${current_branch}...${upstream}"
  fi
  git log --left-right --graph --oneline "$diff_branch"
}
alias gll="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gme='git merge'
alias gmt='git mergetool'
function gpl() {
  current_branch=$(git rev-parse --abbrev-ref HEAD);
  remote=$(git config --get-regexp "branch\.$current_branch\.remote" | sed -e "s/^.* //")
  if [[ -n $current_branch ]] && [[ -n $remote ]]; then
    git pull "$remote" "$current_branch"
  else
    git pull $*
  fi
}
alias gplr='gpl --rebase'
alias gps='git push'
alias grmc='git rm --cached'
alias grm='git rm'
alias grs='git reset --soft'
complete -W 'HEAD~' grs
alias grt='git remote'
alias grp='git rev-parse'
alias gsa='git stash apply'
alias gsb='git subtree'
alias gsh='git stash'
alias gsl='git stash list'
alias gsp='git stash pop'
function gss() {
  if [[ $# -gt 1 ]] && [[ ${@: -1} =~ ^- ]]; then
    _p="${2:+-p}"
    _stash="$1"
  elif [[ $# -eq 1 ]]; then
    if [[ $1 =~ ^- ]]; then
      _p="${1:+-p}"
      _stash=0
    elif [[ $1 =~ [0-9]+ ]]; then
      _stash="$1"
    fi
  else
    _stash="0"
  fi
  git stash show stash@{$_stash} ${_p}
}
function gsf() {
  local _stat= _grep _path _commitid _option
  if [[ $# -eq 2 ]]; then
    _grep="$1"
    if [[ $2 = '--stat' ]]; then
      _stat="$2"
    else
      _path="$2"
    fi
  elif [[ $# -eq 1 ]]; then
    _grep="$1"
  elif [[ $# -eq 0 ]]; then
    _commitid='HEAD'
    _stat='--stat'
  else
    echo 'error'
    return 2
  fi
  if [[ -z $_commitid ]]; then
    if [[ $(git cat-file -t $_grep) = 'commit' ]]; then
      _commitid=$_grep
    else
      _commitid=$(get_commitid_by_msg "$(git log --oneline --grep "$_grep")")
    fi
  fi
  if [[ -n $_path ]]; then
    git show ${_commitid}:${_path}
  elif [[ -n $_stat ]]; then
    git show ${_commitid} ${_stat}
  else
    _option=$(get_select_option "$(git diff-tree --no-commit-id --name-only -r $_commitid)")
    git show ${_commitid}:${_option}
  fi
}
alias gst='git status'
alias gsti='git status --ignored'
function gsw() {
  # exists in current dir
  local file
  if [[ -e ${@: -1} ]]; then
    file=${@: -1}
  else
    file="*${@: -1}*"
  fi
  git update-index --skip-worktree "${@: 1:$(($#-1))}" $file
  glsw
}
function gnsw() {
  # exists in current dir
  local file
  if [[ -e ${@: -1} ]]; then
    file=${@: -1}
  else
    file="*${@: -1}*"
  fi
  git update-index --no-skip-worktree "${@: 1:$(($#-1))}" $file
  glsw
}
function glsw() {
  git ls-files -v | grep -iP '^S' | grep -iP "${1-}"
}
function gvm() {
  local _files _regex _ofiles
  _files="$(git ls-files -m)"
  if [[ -n $_files ]]; then
    if [[ $# -gt 1 ]]; then
      _regex="$(echo $* | sed 's/ /|/g')"
      _ofiles=$(echo "$_files" | grep -P "$_regex")
    elif [[ $# -gt 0 ]]; then
      _ofiles=$(echo "$_files" | grep "$1")
    else
      _ofiles=$(git ls-files -m)
    fi
    if [[ -n $_ofiles ]]; then
      vu -p $_ofiles
    fi
  fi
}
alias gsm='git submodule'
alias gsmu='gsm update --init --recursive'
function git_last() {
  if [[ $# -gt 1 ]] && ! [[ ${@: -1} =~ ^- ]]; then
    _last="*${@: -1}*"
    _rest="${@: 1:$(($#-1))}"
  elif [[ $# -gt 0 ]] && ! [[ ${@: -1} =~ ^- ]]; then
    _last="*${@: -1}*"
  elif [[ ${@: -1} =~ ^- ]]; then
    _last="."
    _rest="$@"
  else
    _last="."
  fi
  _rest=${_rest-}
}
function git_last_unset() {
  unset _last _rest
}
function gad() {
  git_last $@
  git add $_rest "${_last}"
  gst
  git_last_unset
}
function grtad() {
  local url url_in_remote
  url=$2
  url_in_remote=$(git remote get-url $2 2>/dev/null)
  [ -n "${url_in_remote}" ] && url=$url_in_remote
  git remote add $1 $url 2>/dev/null
  git remote set-url all --add $url 2>/dev/null || \
    git remote add all $url
}
function grh() {
  git_last $@
  git reset HEAD $_rest $_last
  git_last_unset
}
function gsbcf() {
  local prefix remote branch
  prefix=$1
  remote=$2
  branch=$3
  git ls-remote --exit-code ${remote} &>/dev/null
  if test $? != 0
  then
    echo 'remote not exists'
  fi
  git config remote.${remote}.prefix ${prefix}
  git config remote.${remote}.branch ${branch}
  git config --get-regexp remote.${remote}
}
function gsbps() {
  pull_push='push'
  gsbpl $1
}
function gsbpl() {
  local prefix remote branch pull_push gdr squash_and_msg
  pull_push=${pull_push:-pull}
  remote=$1

  # check if remote exists
  git ls-remote --exit-code ${remote} &>/dev/null
  if test $? = 0
  then
    cd $(git rev-parse --show-toplevel)
  fi
  prefix=$(git config --get "remote.${remote}.prefix")
  if [ -z "${prefix}" ] ; then echo 'subtree prefix not found';return; fi
  branch=$(git config --get "remote.${remote}.branch")
  if [ -z "${branch}" ] ; then echo 'subtree branch not found';return; fi
  if test "${pull_push}" = "pull"; then
    squash_and_msg="--squash -m "
    if test -z "${@:2}"; then
      squash_and_msg="${squash_and_msg} merge"
    fi
  fi
  git subtree "${pull_push}" --prefix="${prefix}" "${remote}" "${branch}" ${squash_and_msg:-} "${@:2}"
  if test "$?" = 0 ; then cd -; &>/dev/null; fi
}
alias gdfd='gdfl diff'
function gdfl() {
  local command args
  command='log'
  args='--stat'
  [ "$1" = 'diff' ] && { command='diff'; shift; }
  [ -n "$(echo ${@:1}|sed 's/ //g')" ] && { args=${@:1}; }
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  upstream=$(git rev-parse --abbrev-ref ${current_branch}@{upstream})
  git ${command} ${args} $upstream..$current_branch
}

#git alias autocomplete
if [[ -f /usr/share/bash-completion/completions/git ]]; then
  . /usr/share/bash-completion/completions/git
  while read line
  do
    __git_complete ${line%%:*} ${line##*:}
  done < <(cat <<EOF
gbr:_git_branch
gco:_git_checkout
gme:_git_checkout
grb:_git_checkout
gll:_git_checkout
gl:_git_checkout
gdf:_git_diff
gsh:_git_stash
gdfc:_git_diff
gsm:_git_submodule
EOF
)
fi


# docker #
alias dcm="docker-compose"
alias dex='docker exec -it'
alias dim="docker images"
alias din='docker inspect'
alias dlg='docker logs'
alias dps='docker ps'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi'
alias dstp='docker stop $(docker ps -aq)'
alias dtp='docker top'


function dlog() {
  docker logs laradock_${1}_1
}

function dfstp() {
  docker stop $(docker ps | grep $1 | awk '{print $1}') 2>/dev/null
}

function dfrm() {
  docker rm $(docker ps | grep $1 | awk '{print $1}') 2>/dev/null
}

function dexec() {
  docker exec -it $1 bash
}

function dexla() {
  docker exec -it laradock_${1}_1 bash
}

function grepkill() {
  # TODO reuse the grep results
  ps -ef | grep -iP "$(echo $* | sed '{s/\s+/\s/;s/^\s*//;s/\s*$//;}' | sed 's/\s/\|/g')" | grep -v grep
  read -p 'Á°ÆÂÆöÊùÄÊ≠ªËøô‰∫õËøõÁ®ãÔºü'
  ps -ef | grep -iP "$(echo $* | sed '{s/\s+/\s/;s/^\s*//;s/\s*$//;}' | sed 's/\s/\|/g')" | grep -v grep | \
    awk '{print $2}' | xargs -i kill -9 {}
}

function composer_china() {
  composer config -g repo.packagist composer https://packagist.phpcomposer.com
}

function su_without_password() {
  local target_user from_user
  if [ -z "${1+x}" ]
  then
    echo '/etc/pam.d/su'
    echo '$1 target_user $2 from_user'
  fi
  target_user=$1
  from_user=$2
  read -d '' OUT <<EOT
auth       [success=ignore default=1] pam_succeed_if.so user = $target_user
auth       sufficient   pam_succeed_if.so use_uid user = $from_user
EOT
  echo "$OUT"
}

alias gets='get_snippets'
function update_complete_for_snippets() {
  complete -W "$(cd ${snippets_dir}; find . -type f | sed 's@^./@@' | xargs)" gets sets dels edits tpl stpl sst
}
update_complete_for_snippets
function get_snippets() {
  local _list _matched_file _is_only_one_matched
  if [ -z "${1+x}" ]
  then
    _list=$(find ${snippets_dir} ! -path ${snippets_dir} -printf '%y %P\n' | sort -k '2')
    echo "$_list"
    update_complete_for_snippets
  else
    if [[ ! -f ${snippets_dir}/$1 ]]; then
      _matched_file="$(realpath $(find ${snippets_dir} \( -type f -o -type l \) -a -name *$1*) | xargs -n1 | uniq)"
      _is_only_one_matched="$(echo "$_matched_file" | wc -l)"
      if [[ $_is_only_one_matched -eq 1 ]]; then
        cat $_matched_file
      else
        _list=$(find ${snippets_dir} ! -path ${snippets_dir} -printf '%y %P\n' | sort -k '2')
        echo "$_list" | less --pattern="$1"
        return 2
      fi
    else
      cat ${snippets_dir}/$1
    fi
  fi
}

alias edits='edit_snippets'
function edit_snippets() {
  mktouch "${snippets_dir}/$1"
  eval "vim -u ${shell_dir}/.vimrc ${snippets_dir}/$1"
  update_complete_for_snippets
}
alias sets='set_snippets'
function set_snippets() {
  mktouch "${snippets_dir}/$1"
  echo "${@:2}" > ${snippets_dir}/$1
  update_complete_for_snippets
}
alias setsd='set_snippets_heredoc'
function set_snippets_heredoc() {
  mktouch "${snippets_dir}/$1"
  read -d '' heredoc
  eval "echo $heredoc > ${snippets_dir}/$1"
  update_complete_for_snippets
}
alias dels='delete_snippets'
function delete_snippets() {
  if [[ $# -eq 0 ]]; then
    find ${shell_dir} -type l ! -exec test -e {} \; -ok rm {} \;
  else
    rm ${snippets_dir}/$1
  fi
  update_complete_for_snippets
}

function nocolor() {
  sed 's/\x1b\[[0-9;]*m//g'
}

function glsl() {
  lh `glsa | grep -v /$`
}
function glsa() {
  git ls-files -o
}
function glso() {
  local _opts
  _opts=${*---exclude-standard}
  git ls-files -o ${_opts}
}
function glsm() {
  git ls-files -m
}
function glsot() {
  local _files
  _files=${*-$(glso)}
  if [[ -n $_files ]]; then
    tail -n +1 -- $_files | less ${_pattern---pattern='==>.*<=='}
  fi
}
function gls() {
  local USAGE pre_opts debug key level
  USAGE=$(cat << EOT
USAGE:
  -r   recurse   recursive
  -d             only directory
  -t             both files and directory
  -L   level     Descend only level directories deep.
                 e.g.
                 2 show repository equal 2 dir depth
                 -2 show repository less than 2 dir depth
EOT
)
  # USAGE="Usage: command -ihv args"
  if test "$#" = 1 && [[ "$1" =~ (-h|--help) ]] ; then
    echo "$USAGE"
    return
  fi
  pre_opts=''
  while [ $# -gt 0 ]
  do
  key="$1"
  case $key in
    -L)
      # $2 not a number
      if [ "$2" -eq "$2" ] 2>/dev/null
      then
        level=$2
      else
        echo 'level is not a valid number'
        return
      fi
      shift
      shift
    ;;
    -vv)
      debug=1
      shift
    ;;
    *)
      pre_opts+="$key "
      shift
    ;;
  esac
  done
  command="git ls-tree --name-only $pre_opts HEAD"
  if [ -z "${debug+x}" ]
  then
    command+=' 2>/dev/null'
  fi
  eval "$command" |
  if [ -z ${level+x} ]
  then
    cat
  else
    cat | cut -d'/' -f "${level}" | sort | uniq
  fi
  # echo $command
}
function mktouch() {
  local f
  if [ $# -lt 1 ]; then
    echo "Missing argument";
    return 1;
  fi

  for f in "$@"; do
    mkdir -p -- "$(dirname -- "$f")"
    touch -- "$( echo $f | tr -s / | sed 's/\/$//' )"
  done
}
function whereip() {
  if test $# -eq 0; then
    curl -s ip.cn
  else
    curl -s ip.cn/index.php?ip=$1
  fi
}
function getip() {
  whereip "$@" | grep -oP '\d{1,3}(\.\d{1,3}){3}' | nocolor
}

function straceall() {
  strace "${@:2}" $(pgrep "${1}" | xargs | sed 's/[0-9]\+/-p &/g')
}

alias rebinall="rebin $( ls ${shell_dir}/plugins )"
function rebins() {
  gsmu
  if [[ ! -e "${plugins_dir}/.bin" ]]; then
    mkdir -p "${plugins_dir}/.bin"
  fi
  ln -sf "${plugins_dir}/sempl/sempl" "${plugins_dir}/.bin/sempl"
  ln -sf "${plugins_dir}/sempl/crypttool" "${plugins_dir}/.bin/crypttool"
  cp -a "${plugins_dir}/jj/jj" "${plugins_dir}/.bin/jj" 2>/dev/null
}
function rebin() {
  cat ${snippets_dir}/ln_in_plugin | /bin/bash -s -- "$@"
}
function mkver() {
  local _filename _extension _tmp_filename _add _real_tmp
  if [[ -e $1 ]]; then
    if [[ $1 =~ \. ]]; then
      _filename=${1%.*}
      _extension=${1##*.}
    else
      _filename=$1
    fi
  else
    echo 'no found'
    return
  fi
  if [[ -n $_filename ]]; then
    _add="-$(date +%Y%m%d)-XXX"
  else
    _add="$(date +%Y%m%d)-XXX"
  fi
  _extension=${_extension:=}
  _tmp_filename="$_filename${_add}${_extension:+.$_extension}"
  _real_tmp=$(mktemp --tmpdir=$(pwd) -t "$_tmp_filename")
  cp $1 $_real_tmp
}
function mktmp() {
  local name subfix
  name=${1-tmp}
  subfix=$(echo ${2-.txt} | sed -r 's/^[^\.]/.&/')
  mktemp --tmpdir=$(pwd) -t "${name}.XXXXXX${subfix}"
}
function dfa() {
  local info _alias
  info=$(declare -f "$1")
  _alias=$(alias "$1" 2>/dev/null)
  if [[ -n "$info" ]]; then
    echo "$info"
  elif [[ -n "$_alias" ]]; then
    echo "$_alias"
  else
    echo 'definition not found'
  fi
}
function ssp() {
  cd "${snippets_dir}/ssh_keys"
  read -p "old_password:" -s old_pass
  # veirfy old_pass
  for i in *.enc ; do
    crypttool -p ${old_pass} decrypt $i &>/dev/null || { echo;tput setaf 1;echo 'old_pass error';tput sgr0;return; }
    break
  done
  echo
  read -s -p 'password:' pass
  echo
  read -s -p 'password(again):' pass2
  while [[ $pass != $pass2 ]]; do
    echo
    echo 'Please try again'
    read -s -p 'password:' pass
    echo
    read -s -p 'password(again):' pass2
  done
  backdir='../ssh_keys_backup'
  mkdir -p $backdir
  cp -a * $backdir
  for i in *.enc ; do
    crypttool -p ${old_pass} decrypt $i &>/dev/null || { echo 'decrypt error';rm *;cp -a "$backdi/*" .;return; }
    chmod 600 ${i%%.enc}
    rm $i
  done
  for i in * ; do
    crypttool -p ${pass} encrypt $i  &>/dev/null || { echo 'encrypt error';rm *;cp -a "$backdi/*" .;return; }
  done
  rm $backdir/*
  tput setaf 2; echo 'password changed successful'; tput sgr0;
  cd - &>/dev/null
  tput sgr0
  # for more tput usage; see https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux#answer-20983251
  unset back_dir
}
function sss() {
  eval `ssh-agent` #`` usage detail see https://serverfault.com/questions/547923/running-ssh-agent-from-a-shell-script?answertab=votes#answer-705635
  cd "${snippets_dir}/ssh_keys"
  read -p "password:" -s pass
  echo
  for i in *.enc ; do
    crypttool -p ${pass} decrypt $i
    chmod 600 ${i%%.enc}
    ssh-add ${i%%.enc}
  done
  cd -
}
function sst() {
  ssh "$(cat ${snippets_dir}/$1)"
}
function join_by() {
  local IFS="$1"
  shift
  echo "$*"
}
function gref() {
  _pre='-rinH'
  _kw="${@: -1}"
  _opts="${@: 1:$(($#-1))}"
  if [[ $_kw =~ [A-Z] ]]; then
    _pre=${_pre//i}
  fi
  if ! [[ $_kw =~ ^[A-Za-z0-9]+$ ]]; then
    _pre="${_pre}P"
  fi
  _pre="$_pre --color=always -R"
  grep $_pre ${_opts} "$_kw" | less
  unset _pre _kw _opts
}
# easy to change directory #
alias d='dirs -v'
function init_dirstack() {
  dirs -c
  _dirstack="$(cat ${snippets_dir}/.ignore_files/dirstack 2>/dev/null)"
  if [[ -n $_dirstack ]]; then
    for _d in $(echo "$_dirstack" | xargs -n1 | tac); do
      pushd $_d 1>/dev/null
    done
    popd -0 1>/dev/null
  fi
  unset _dirstack _d
}
init_dirstack
function pu() {
  _whoami=$(whoami)
  pushd $(echo $* | sed -r 's/\b[0-9]+\b/+&/g') 1>/dev/null
  sets .ignore_files/dirstack $(echo ${DIRSTACK[@]} | sed "s/~/\/$_whoami/g")
  d
  unset _whoami
}
function po() {
  _whoami=$(whoami)
  popd $(echo $* | sed -r 's/\b[0-9]+\b/+&/g') 1>/dev/null
  sets .ignore_files/dirstack $(echo ${DIRSTACK[@]} | sed "s/~/\/$_whoami/g")
  d
  unset _whoami
}

eval "source ${snippets_dir}/exports"
if [[ "$-" =~ i ]]; then
  eval "bind -f ${snippets_dir}/inputrc"
fi

if [[ -x "${shell_dir}/plugins/.bin/sempl" ]]; then
  if [[ -z $(which sempl) ]]; then
    export PATH="${shell_dir}/plugins/.bin:${PATH}"
  fi
fi
if [[ -x "/usr/local/go/bin/go" ]]; then
  if [[ -z $(which go) ]]; then
    export PATH="${shell_dir}/plugins/.bin:${PATH}"
  fi
fi

alias addswap='stpl swapfile_mk'
alias delswap='stpl swapfile_rm'
# complete for custom commands
complete -W "$(eval "ls /var/_swap_ 2>/dev/null | xargs")" addswap delswap
# test script; like python's __main__
# add the key map in .vimrc
# map gb :!export exec_in_vim=1;clear;echo ;bash %;unset exec_in_vim<CR>
if [ "$exec_in_vim" = 1 ]
then
  :
    # get_snippets test
fi
