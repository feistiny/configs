stty -ixon
#!/bin/basn
export shell_dir="$HOME/configs"

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

# vi and emacs editing mode configs
bind "set show-mode-in-prompt on" 
bind 'set emacs-mode-string "‚ôã "' 
bind 'set vi-ins-mode-string "‚ò∫ "' 
bind 'set vi-cmd-mode-string "Ì†ΩÌ±â "' 
bind -m vi-insert  '"\C-\M-J": emacs-editing-mode' 
bind -m vi-command '"\C-\M-J": emacs-editing-mode' 
bind -m emacs      '"\C-\M-J": vi-editing-mode' 
# bind -m vi-insert  '"\e_": emacs-editing-mode' 
# bind -m vi-command '"\e_": emacs-editing-mode' 
# bind -m emacs      '"\e_": vi-editing-mode' 
bind -m vi-insert '"\e.": yank-last-arg' 
bind -m vi-insert '"\e\C-y": yank-nth-arg' 
bind -m vi-command '"\e.": yank-last-arg' 
bind -m vi-command '"\e\C-y": yank-nth-arg' 
bind -m vi-insert '"\C-p": previous-history'
bind -m vi-insert '"\C-n": next-history'
export VISUAL=vu

# templaet snippets
alias tpl='sempl -o -f'
function stpl() {
  tpl "${@:1:$(($#-1))}" <(gets "${@: -1}")
}

# reaload aliases.sh #
alias rea="source ${shell_dir}/aliases.sh && echo 'reloaded'"
alias tml="tmux -f ${shell_dir}/.tmux.conf a -t"
alias tmll="tmux -f ${shell_dir}/.tmux.conf"

# easy to change directory #
alias d='dirs -v'
alias pu='pushd'
alias po='popd'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias tmls='tmux ls'
function tmks() {
    for i in "$@"
    do
        tmux kill-session -t $i
    done
    unset i
}
alias tmkr='tmux kill-server'

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
alias gciap='git commit --amend -C HEAD && git push -f'
alias gciaap='git commit -a --amend -C HEAD && git push -f'
alias gciam='git commit -am'
alias gci='git commit'
alias gcii='git -c user.name="lzf" -c user.email="liuzhanfei166@126.com" commit'
function gcim() {
  git commit -m "${1-+++}"
}
alias gcl='git clean'
alias gco='git checkout'
alias gdfc='git diff --cached'
alias gdf='git diff'
alias gfe='git fetch'
alias gl='git log --oneline'
alias gll="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gme='git merge'
alias gnsw='git update-index --no-skip-worktree'
alias gpl='git pull'
alias gplr='git pull --rebase'
alias gps='git push'
alias grb='git rebase'
alias grmc='git rm --cached'
alias grm='git rm'
alias grs='git reset'
complete -W 'HEAD~' grs
alias grt='git remote'
alias grp='git rev-parse'
alias gsa='git stash apply'
alias gsb='git subtree'
alias gsh='git stash'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gst='git status'
alias gsti='git status --ignored'
alias gsw='git update-index --skip-worktree'
alias gsm='git submodule'
function gad() {
  to_add='.'
  if [ -n "${1}" ]; then to_add=$1; fi
  git add $to_add ${@:2}
  unset to_add
}
function grtad() {
  url=$2
  url_in_remote=$(git remote get-url $2 2>/dev/null)
  [ -n "${url_in_remote}" ] && url=$url_in_remote
  git remote add $1 $url 2>/dev/null
  git remote set-url all --add $url 2>/dev/null || \
    git remote add all $url
  unset url url_in_remote
}
function gcimp() {
  msg=${1:-+++}
  git commit -am "$msg" && git push ${@:2}
}
function grh() {
 git reset HEAD "$1"
}
function gsbcf() {
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
  unset prefix remote branch
}
function gsbps() {
  pull_push='push'
  gsbpl $1
}
function gsbpl() {
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
  unset prefix remote branch pull_push gdr squash_and_msg
}
alias gdfd='gdfl diff'
function gdfl() {
  command='log'
  args='--stat'
  [ "$1" = 'diff' ] && { command='diff'; shift; }
  [ -n "$(echo ${@:1}|sed 's/ //g')" ] && { args=${@:1}; }
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  upstream=$(git rev-parse --abbrev-ref ${current_branch}@{upstream})
  git ${command} ${args} $upstream..$current_branch
  unset command args
}

#git alias autocomplete
[ -f /usr/share/bash-completion/completions/git ] && . /usr/share/bash-completion/completions/git
while read line
do
  __git_complete ${line%%:*} ${line##*:}
done < <(cat <<EOF
gbr:_git_branch
gco:_git_checkout
gll:_git_checkout
gl:_git_checkout
gdf:_git_diff
gdfc:_git_diff
gsm:_git_submodule
EOF
)


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
unset target_user from_user
}

snippets_dir="${shell_dir}/snippets"
alias gets='get_snippets'
function update_complete_for_snippets() {
  complete -W "$(eval "ls ${snippets_dir} | xargs")" gets sets dels edits tpl stpl
}
update_complete_for_snippets
function get_snippets() {
if [ -z "${1+x}" ]
then
  eval "find ${snippets_dir} ! -path ${snippets_dir} -printf '%y %f\n' | sort -k '1' -k '2'"
  update_complete_for_snippets
else
  cat ${snippets_dir}/$1 
fi

}

alias edits='edit_snippets'
function edit_snippets() {
  eval "vim -u ${shell_dir}/.vimrc ${snippets_dir}/$1" 
  update_complete_for_snippets
}
alias sets='set_snippets'
function set_snippets() {
  eval "echo ${@:2} > ${snippets_dir}/$1"
  update_complete_for_snippets
}
alias setsd='set_snippets_heredoc'
function set_snippets_heredoc() {
  read -d '' heredoc
  eval "echo $heredoc > ${snippets_dir}/$1"
  update_complete_for_snippets
}
alias dels='delete_snippets'
function delete_snippets() {
  eval "rm ${snippets_dir}/$1"
  update_complete_for_snippets
}

function nocolor() {
  sed 's/\x1b\[[0-9;]*m//g'
}

alias guls='git ls-files --others --ignore --exclude-standard'
function gls() {
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
  unset pre_opts debug key level
}
function mktouch() {
  if [ $# -lt 1 ]; then
    echo "Missing argument";
    return 1;
  fi

  for f in "$@"; do
    mkdir -p -- "$(dirname -- "$f")"
    touch -- "$( echo $f | tr -s / | sed 's/\/$//' )"
  done
  unset f
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
function rebin() {
  cat ${snippets_dir}/ln_in_plugin | /bin/bash -s -- "$@"
}
function mktf() {
  if [[ -e "$1" && $# = 2 ]]; then
    touch "$1/$(date +%Y-%m-%d-%H-%M-%S)-$2"
  elif [[ $# = 1 ]]; then
    touch "$(date +%Y-%m-%d-%H-%M-%S)-$1"
  fi
  # mktemp --tmpdir=$(pwd) -t "${name}.XXXXXX${subfix}"
  # unset name subfix
}
function mktmp() {
  name=${1-tmp}
  subfix=$(echo ${2-.txt} | sed -r 's/^[^\.]/.&/')
  mktemp --tmpdir=$(pwd) -t "${name}.XXXXXX${subfix}"
  unset name subfix
}

eval "source ${snippets_dir}/exports"
eval "bind -f ${snippets_dir}/inputrc"

if [[ -z $(which sempl 2>/dev/null) ]]; then
  export PATH="${shell_dir}/plugins/.bin:${PATH}"
fi

# test script; like python's __main__
# add the key map in .vimrc
# map gb :!export exec_in_vim=1;clear;echo ;bash %;unset exec_in_vim<CR>
if [ "$exec_in_vim" = 1 ]
then
  :
    # get_snippets test
fi
