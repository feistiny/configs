#!/bin/bash
[[ $- =~ i ]] && stty -ixon
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
alias sudo='sudo ' #https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo#22043
export XDG_CONFIG_HOME="${shell_dir}"
alias nv="nvim -u ${shell_dir}/nvim/init.vim"
function vu() {
  local _vu="vim -u ${shell_dir}/.vimrc"
  local files_to_open
  if [[ "$1" ]]; then
    if [[ -e $1 ]]; then
      $_vu "$1"
    elif [[ $# -gt 1 ]]; then
      $_vu $*
    else
      files_to_open="$(multi_select "$(git ls-files 2>/dev/null | grep $1)" 2>/dev/null)"
      if [[ $files_to_open ]]; then
        $_vu -p $files_to_open
      else
        $_vu $*
      fi
    fi
  else
    $_vu
  fi
}
__vt()
{
  local cur prev opts

  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  # prev="${COMP_WORDS[COMP_CWORD-1]}"
  if [[ -e .tags ]]; then
    opts="$(cat .tags | grep -v '^!' | awk '{print $1}' | sort | uniq | xargs)"
  else
    return
  fi

  _get_comp_words_by_ref -n : cur
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  __ltrim_colon_completions "$cur"
}
complete -F __vt -o default vt
function vt() {
  vu -t $1
}
alias his="history | tail -100"
alias ext="unset HISTFILE && logout"

alias ag="ansible-galaxy"
alias ap="ANSIBLE_NOCOWS=1 ansible-playbook -i ${ansible_dir}/hosts"
alias ansible="ansible -i ${ansible_dir}/hosts"

alias mysqldump_with_options="mysqldump --add-drop-table --complete-insert --single-transaction --set-gtid-purged=OFF --skip-comments"

function getSnippetsDirs() {
  local _dirs
  _dirs=(
  $HOME/.vim/plugged/vim-snippets \
  $HOME/.vim/plugged/wxapp.vim/UltiSnips \
  ${shell_dir}/UltiSnips \
  $(pwd)/UltiSnips \
  )
  echo ${_dirs[@]} | xargs ls -d 2>/dev/null
}
function lesp() {
  local _files
  _files=$(find $(getSnippetsDirs) -type f -name "${1-php}.snippets");
  if [[ -n "$_files" ]]; then
    tail -n +1 -- $_files | less ${_pattern---pattern='==>.*<=='}
  else
    find $(getSnippetsDirs) -type f -name "*${1-php}*.snippets"
  fi
}
alias cpec="cp -i ${shell_dir}/.editorconfig ."
alias mdv='mdv -t 729.8953'
alias watch='watch --color'
source "${fish_dir}/mkctags.sh"
function pcf() {
  local _dir
  _dir="${*:-.}"
  php-cs-fixer fix --config ${shell_dir}/.php_cs --allow-risky yes $_dir
}
alias aiy='apt install -y'
alias adi='gets .gitignore.example >> .gitignore'

umask 002
# set -o emacs
set -o vi
if [[ -z "$exec_in_vim" ]]; then
  # vi and emacs editing mode configs
  bind "set show-mode-in-prompt on"
  bind 'set emacs-mode-string " e "'
  bind 'set vi-ins-mode-string " i "'
  bind 'set vi-cmd-mode-string " c "'
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
  export VISUAL="vim -u ${shell_dir}/.vimrc"
fi

# templaet snippets
alias tpl='sempl -o -f'
function stpl() {
  tpl "${@:2}" <(gets "$1")
}
function srt() {
  . <(tpl "${@:2}" <(gets "$1"))
}
function srs() {
  . ${snippets_dir}/$1 ${@:2}
}
function srd() {
  read -s -p 'password:' password
  . <(crypttool -p "$password" cat "${snippets_dir}/$1")
}

# reaload aliases.sh #
alias rea="source ${shell_dir}/aliases.sh && echo 'reloaded'"
function tml() {
  local _tmux=\tmux" -f ${shell_dir}/.tmux.conf -S ${snippets_dir}/.ignore_files/tmux.sock"
  if [[ -e ${snippets_dir}/.ignore_files/tmux.sock ]]; then
    $_tmux ls &>/dev/null
    if ! [[ $? -eq 0 ]]; then
      rm ${snippets_dir}/.ignore_files/tmux.sock
    elif [[ "$1" ]]; then
      $_tmux attach -t $1
    else
      big=$($_tmux ls 2>/dev/null | tail -1 | cut -d' ' -f1)
      $_tmux attach -t $big
    fi
  elif [[ "$1" ]] && [[ -n $(tmls) ]]; then
    $_tmux attach -t $1
  fi
}
function tmll() {
  local _tmux=\tmux" -f ${shell_dir}/.tmux.conf -S ${snippets_dir}/.ignore_files/tmux.sock"
  if [[ -e ${snippets_dir}/.ignore_files/tmux.sock ]]; then
    $_tmux ls 2>/dev/null
    if ! [[ $? -eq 0 ]]; then
      rm ${snippets_dir}/.ignore_files/tmux.sock
    fi
    if [[ $# -gt 0 ]]; then
      $_tmux $*
    else
      $_tmux
    fi
  else
    $_tmux
  fi
}
function tmls() {
  local _tmux=\tmux" -f ${shell_dir}/.tmux.conf -S ${snippets_dir}/.ignore_files/tmux.sock"
  if [[ -e ${snippets_dir}/.ignore_files/tmux.sock ]]; then
    $_tmux ls 2>/dev/null
    if ! [[ $? -eq 0 ]]; then
      rm ${snippets_dir}/.ignore_files/tmux.sock
    fi
  fi
}
function tmks() {
  local _tmux=\tmux" -S ${snippets_dir}/.ignore_files/tmux.sock"
  local i
  for i in "$@"
  do
    $_tmux kill-session -t $i
  done
}

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# laravel artisan #
alias cmp='composer'
alias cmc='composer config'
alias cmpdp="cmp dumpautoload"
alias art="php artisan"
__art()
{
  local cur prev opts _opts_base="list migrate"

  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  # prev="${COMP_WORDS[COMP_CWORD-1]}"
  if [[ -e artisan ]]; then
    opts="$_opts_base $(php artisan | grep -P ':\w' | awk '{print $1}' | xargs)"
  else
    opts="$_opts_base
    api:generate api:update app:name
    auth:clear-resets cache:clear cache:forget cache:table config:cache config:clear
    make:auth make:command make:controller make:event make:exception make:factory make:job make:listener make:mail make:middleware
    make:migration make:model make:notification make:policy make:provider make:request make:resource make:rule make:seeder make:test
    migrate:fresh migrate:install migrate:refresh migrate:reset migrate:rollback migrate:status
    notifications:table package:discover
    queue:failed queue:failed-table queue:flush queue:forget queue:listen queue:restart queue:retry queue:table queue:work
    route:cache route:clear route:list
    db:seed event:generate key:generate
    schedule:run session:table storage:link vendor:publish view:clear"
  fi

  _get_comp_words_by_ref -n : cur
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  __ltrim_colon_completions "$cur"
}
complete -F __art art
alias artm="php artisan migrate"
alias artms="php artisan migrate:status"
alias artmr="php artisan migrate:rollback"
alias artml="php artisan make:migration --path database/migrations/local_recreate"

function aam() {
  art admin:make --model "App\\Admin\\Models\\$1" "${2-$1}Controller"
}
__aam()
{
  local cur prev opts _git_root

  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  _git_root=$(git rev-parse --show-toplevel)
  if ! [[ "$_git_root" ]]; then
    return
  fi
  # prev="${COMP_WORDS[COMP_CWORD-1]}"
  if [[ -d "$_git_root/app/Admin/Models" ]]; then
    opts="$(ls $_git_root/app/Admin/Models/*.php | xargs -i basename {} | sed 's/\.php//g')"
  else
    return
  fi

  _get_comp_words_by_ref -n : cur
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  __ltrim_colon_completions "$cur"
}
complete -F __aam aam
function artds() {
  php artisan db:seed --class=$1
}
__artds()
{
  local cur prev opts _git_root _dir

  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  _git_root=$(git rev-parse --show-toplevel)
  if ! [[ "$_git_root" ]]; then
    return
  fi
  # prev="${COMP_WORDS[COMP_CWORD-1]}"
  _dir="$_git_root/database/seeds/"
  if [[ -d "$_dir" ]]; then
    opts="$(ls $_dir/*.php | xargs -i basename {} | sed 's/\.php//g')"
  else
    return
  fi

  _get_comp_words_by_ref -n : cur
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  __ltrim_colon_completions "$cur"
}
complete -F __artds artds
alias db:reset="php artisan migrate:reset && php artisan migrate --seed"

# git #
alias gbr='git branch'
alias gceu='gcf user.name "lzf" && gcf user.email "liuzhanfei166@126.com"'
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
      for i in "${!options[@]}"; do
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}" >&2
      done
      if [[ -n $msg ]]; then
        echo "$msg" >&2
      fi
    }
    prompt="check an option (again to uncheck, ENTER when done): "
    while __show_menu && read -rp "$prompt" num && [[ "$num" ]]; do
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
function single_select() {
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
      for i in "${!options[@]}"; do
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}" >&2
      done
      if [[ -n $msg ]]; then
        echo "$msg" >&2
      fi
    }
    prompt="check an option (again to uncheck, ENTER when done): "
    while __show_menu && read -rp "$prompt" num; do
      [[ -z $num ]] && { continue; }
      [[ "$num" != *[![:digit:]]* ]] &&
      (( num > 0 && num <= ${#options[@]} )) &&
      { printf "%s" "${options[$num-1]}"; break; } ||
      { msg="Invalid option: $num"; continue; }
    done
    IFS=${OLD_IFS}
  else
    echo 'optoins is none' >&2
    return 1
  fi
}
function gcif() {
  local _commit
  if [[ "$1" ]]; then
    if [[ $(git cat-file -t $1) = 'commit' ]]; then
      _commit=$1
    else
      _commit=$(get_commitid_by_msg "$(git log --oneline --grep "$1" | grep -v 'fixup!')")
    fi
  fi
  git commit --fixup ${_commit-HEAD}
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
function gclef() {
  local _files
  _files="$(glso)"
  if [[ "$_files" ]]; then
    rm $(multi_select "$(echo "$_files" | grep $1)")
  fi
  gst
}
alias gco='git checkout'
function gcom() {
  local _files _grep _prompt _patch
  if [[ $* =~ $(echo '(\s+-p|-p\b)') ]]; then
    _patch='-p'
    set -- $(echo $* | sed -r 's/(^|\s)-p\b//')
  fi
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
    if [[ "$_files" ]]; then
      gco ${_patch-} $_files
    fi
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
function gfet() {
  git fetch --no-tags $1 +refs/tags/$2:refs/tags/$2
}
alias gl='git log --oneline'
alias glgs='git log -S'
alias glsp='git log -p -S'
function glp() {
  local _stat
  [[ $* =~ '--stat' ]] && { _stat='--stat'; }
  git_last $@
  git log --oneline ${_stat:--p} ${_rest:=-1} $_last
  git_last_unset
}
function glr() {
  local all
  all="$*"
  all="${all/\ ...\ /...}"
  all="${all/\ ..\ /..}"
  git log --oneline --left-right $*
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
  if [[ -n $current_branch ]] && [[ -n $remote ]] && [[ -z $* ]]; then
    git pull "$remote" "$current_branch"
  else
    git pull $*
  fi
}
alias gplr='gpl --rebase'
function gps() {
  upstream=$(git rev-parse --abbrev-ref ${current_branch}@{upstream} 2>/dev/null);
  if [[ $upstream ]]; then
    git push $*
  else
    git ls-remote --exit-code all &>/dev/null
    if [[ $? -eq 0 ]] && [[ -z "$*" ]]; then
      git push all --all $*
    else
      git push $*
    fi
  fi
}
alias grmc='git rm --cached'
alias grm='git rm'
alias grs='git reset --soft'
complete -W 'HEAD~' grs
alias grt='git remote'
alias grp='git rev-parse'
function gsa() {
  local _stash=${1-0}
  git stash apply stash@{$_stash}
}
function gsp() {
  local _stash=${1-0}
  git stash pop stash@{$_stash}
}
function gsd() {
  local _stash=${1-0}
  git stash drop stash@{$_stash}
}
alias gsb='git subtree'
alias gsh='git stash'
function gshu() {
  git stash && git stash save -u "$1" && git stash pop stash@{1}
}
alias gsl='git stash list'
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
  local _stat_p= _grep _path _commitid _option
  if [[ $# -ge 2 ]]; then
    _grep="$1"
    if [[ $2 =~ --stat|-p ]]; then
      _stat_p="$2"
    else
      _path="$2"
    fi
    shift 2
  elif [[ $# -eq 1 ]]; then
    _grep="$1"
    shift
  elif [[ $# -eq 0 ]]; then
    _commitid='HEAD'
    _stat_p='--stat'
  fi
  if [[ -z $_commitid ]]; then
    if [[ $(git cat-file -t $_grep) = 'commit' ]]; then
      _commitid=$_grep
    else
      _commitid=$(get_commitid_by_msg "$(git log --oneline | grep "$_grep")")
    fi
  fi
  if [[ -n $_path ]]; then
    git show ${_commitid}:${_path} $*
  elif [[ -n $_stat_p ]]; then
    git show ${_commitid} ${_stat_p} $*
  else
    _option=$(get_select_option "$(git diff-tree --no-commit-id --name-only -r $_commitid)")
    git show ${_commitid}:${_option} $*
  fi
}
alias gst='git status'
alias gsti='git status --ignored'
function gsw() {
  # exists in current dir
  local file
  if [[ $# -eq 0 ]]; then
    git ls-files -v | grep ^S
    return
  fi
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
  if [[ $# -eq 0 ]]; then
    git ls-files -v | grep ^S
    return
  fi
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
  _files="$(echo "$(git ls-files -m && git diff --cached --name-only --diff-filter=AM)" | sort | uniq)"
  if [[ -n $_files ]]; then
    if [[ $# -gt 1 ]]; then
      _regex="$(echo $* | sed 's/ /|/g')"
      _ofiles="$(echo "$_files" | grep -P "$_regex")"
    elif [[ $# -gt 0 ]]; then
      _ofiles="$(echo "$_files" | grep "$1")"
    else
      _ofiles="$(git ls-files -m && git diff --cached --name-only --diff-filter=AM)"
    fi
    if [[ -n $_ofiles ]]; then
      vu -p $_ofiles
    fi
  fi
}
alias gsm='git submodule'
function gsmu() {
  gsm update ${*---init --recursive}
}
function git_last() {
  unset _last _rest
  local _last_is_commit
  if [[ $# -gt 1 ]] && ! [[ ${@: -1} =~ ^- ]]; then
    _last_is_commit="${@: -1}"
    _rest="${@: 1:$(($#-1))}"
  elif [[ $# -gt 0 ]] && ! [[ ${@: -1} =~ ^- ]]; then
    _last_is_commit="${@: -1}"
  elif [[ ${@: -1} =~ ^- ]]; then
    _last="."
    _rest="$@"
  else
    _last="."
  fi
  [[ "$_last_is_commit" ]] && _last="$([[ $(git cat-file -t $_last_is_commit 2>/dev/null) = 'commit' ]] && echo "$_last_is_commit" || echo "*$_last_is_commit*")"
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
function gadc() {
  gad $*
  local _files="$(git diff --cached --name-only)"
  if [[ "$_files" ]]; then
    pcf $_files &>/dev/null
    gad $_files &>/dev/null
  fi
}
function pcfm() {
  pcf `glsm`
}
function grtad() {
  local url url_in_remote
  url=$2
  url_in_remote=$(git remote get-url $2 2>/dev/null)
  [[ ${url_in_remote} ]] && url=$url_in_remote
  git remote add $1 $url 2>/dev/null \
    || git remote set-url $1 $url
  git remote set-url all --add $url 2>/dev/null \
    || git remote add all $url
}
function grtrm() {
  local _remote _url
  git remote remove all &&
  git remote remove $1 && {
    for _remote in $(git remote) ; do
      _url="$(git remote get-url $_remote)"
      if [[ $_url ]]; then
        grtad $_remote $_url
      fi
    done
  }
}
function grh() {
  git_last $@
  git reset HEAD $_rest $_last
  git_last_unset
  gst
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
glr:_git_checkout
gco:_git_checkout
gcp:_git_checkout
grs:_git_checkout
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
  read -p '确定杀死这些进程？'
  ps -ef | grep -iP "$(echo $* | sed '{s/\s+/\s/;s/^\s*//;s/\s*$//;}' | sed 's/\s/\|/g')" | grep -v grep | \
    awk '{print $2}' | xargs -i kill -9 {}
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
  complete -W "$(cd ${snippets_dir}; find . -type f | sed 's@^./@@' | xargs)" gets sets dels edits tpl stpl sst srd srt srs
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
      _matched_file="$(realpath $(find ${snippets_dir} \( -type f -o -type l \) -a -name *$1*) 2>/dev/null | xargs -n1 | uniq)"
      _is_only_one_matched="$(echo "$_matched_file" | sed '/^$/d' | wc -l)"
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
  if [[ -e $1 ]]; then
    tail -n +1 -- $1 | less
  elif [[ -n $1 ]]; then
    _files=$(glso | grep $1)
    tail -n +1 -- $_files | less ${_pattern---pattern='==>.*<=='}
  else
    tail -n +1 -- $(glso) | less ${_pattern---pattern='==>.*<=='}
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
    curl -s https://ip.cn
  else
    curl -s https://ip.cn/index.php?ip=$1
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
  ln -sf "${plugins_dir}/git-quick-stats/git-quick-stats" "${plugins_dir}/.bin/git-quick-stats"
  [[ -e "${plugins_dir}/.bin/jj" ]] || {
    if ! [[ -e "${plugins_dir}/jj/jj" ]]; then
      pushd ${plugins_dir}/jj && make install && popd
    fi
    mv "${plugins_dir}/jj/jj" "${plugins_dir}/.bin/jj"
  }
  cp -a "${plugins_dir}/nginx-modsite/nginx-modsite" "${plugins_dir}/.bin/nginx-modsite" 2>/dev/null && chmod +x "${plugins_dir}/.bin/nginx-modsite"
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
__dfa()
{
  local cur prev opts funs aliases

  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  # prev="${COMP_WORDS[COMP_CWORD-1]}"
  funs="$(declare -F | awk '{print $3}' | xargs)"
  aliases="$(alias | awk '/^alias/{print $2}' | cut -d'=' -f1)"
  opts="${aliases-} ${funs-}"

  _get_comp_words_by_ref -n : cur
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  __ltrim_colon_completions "$cur"
}
complete -F __dfa dfa
function dfa() {
  local info _alias
  info=$(declare -f "$1")
  _alias=$(alias "$1" 2>/dev/null)
  if [[ -n "$_alias" ]]; then
    echo "$_alias"
  elif [[ -n "$info" ]]; then
    echo "$info"
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
  ssh "${user-root}@$(cat ${snippets_dir}/$1)" -p ${port-22}
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
      pushd $_d &>/dev/null
    done
    popd -0 &>/dev/null
  fi
  unset _dirstack _d
}
init_dirstack
function convert_root_realpath() {
  echo "$*" | sed -r "s@(^\s*|\s+)~@\1$(realpath ~)@g"
}
function pp() {
  local _num
  if [[ "$OLDPWD" ]]; then
    _num="$(dirs -v | awk -v oldpwd=$OLDPWD '{ cmd="realpath "$2; cmd | getline path; if(path==oldpwd){print $1}; close(cmd);}')"
    if [[ "$_num" ]]; then
      pu $_num
    fi
  fi
}
function pu() {
  local _num _dir
  if [ $1 -eq $1 ] 2>/dev/null; then
    _num=$1
  else
    if ! [[ -e $1 ]]; then
      _dir="$(single_select "$(dirs -v | awk '{print $2}' | grep -i "$1" | grep -v "^$(pwd)$")")"
      _num="$(dirs -v | awk -v dir=$_dir '{ if($2==dir){print $1}; close(cmd);}')"
    else
      _num=$1
    fi
  fi
  if [[ $_num ]]; then
    _num="$(echo $_num | sed -r 's/^[0-9]+$/+&/g')"
    pushd ${_num-$1} &>/dev/null
  elif [[ $# -eq 0 ]]; then
    pushd &>/dev/null
  fi
  sets .ignore_files/dirstack "$(convert_root_realpath ${DIRSTACK[@]})"
  unset _whoami
}
function pd() {
  _whoami=$(whoami)
  cd "$*"
  sets .ignore_files/dirstack $(convert_root_realpath ${DIRSTACK[@]})
  d
  unset _whoami
}
function po() {
  _whoami=$(whoami)
  popd $(echo $* | sed -r 's/\b[0-9]+\b/+&/g') &>/dev/null
  sets .ignore_files/dirstack $(convert_root_realpath ${DIRSTACK[@]})
  d
  unset _whoami
}
function mp() {
  local __strip_components _path HELP OPTS
  local USAGE=$(cat <<USAGE
copy multi files striping the leading path
USAGE
)
  OPTS="$(getopt -o s:p: --long help,strip-components:path: -n 'mp' -- "$@")" ||
    { echo "Failed parsing options." >&2 ; return 1; }
  eval set -- "$OPTS"
  while true; do
    case "$1" in
      -s | --strip-components )
        if ! [[ $2 =~ [0-9] ]]; then
          echo '--strip-components must be a number.' >&2
          return 2
        else
          __strip_components=$2; shift 2
        fi
        ;;
      -p | --path )
        if [ ! -e $2 ]; then
          echo "path $2 is not found." >&2
          return 3
        fi
        _path="$2"
        shift 2
        ;;
      -h | --help ) HELP=true; shift ;;
      -- ) shift; break ;;
      * ) break ;;
    esac
  done
  [[ -e "$_path" ]] || { echo 'path not set.' >&2; return 4; }
  [[ "$HELP" ]] &&
    { echo $USAGE; return 0; }
  if [[ "$1" ]]; then
    _files="$(multi_select "$(find ${_path+"$_path"} -iname "*$1*" -printf '%p\n')")"
    if [[ "$_files" ]]; then
      tar -cpf - $_files 2>/dev/null | tar -xpf - ${__strip_components+--strip-components=$__strip_components} -C . 2>/dev/null
    fi
  fi
}
# genereate password
function getpwd() {
  head -c 100 /dev/urandom | tr -dc a-z0-9A-Z | head -c ${1-8}
  echo
}
function retry() {
  sleep ${n-0} && eval "$@" && { echo 'success'; retry "$@"; } || { echo 'fail'; retry "$@"; }
}
function man(){
	for arg in "$@"; do
		vim -c 'execute "normal! :let no_man_maps = 1\<cr>:runtime ftplugin/man.vim\<cr>:Man '"${arg}"'\<cr>:wincmd o\<cr>"'
	done
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
