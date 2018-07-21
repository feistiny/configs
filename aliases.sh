#!/bin/basn
shell_dir='~/configs'

# git clone in the root(~) dir #

# ls aliases #
alias l='ls -al'
alias la='ls -a'
alias lla='ll -a'
alias lsd='ls -l | grep ^d'
alias cls='clear; ls'
alias cll='clear; ls -al'
alias cla='clear; ls -a'
alias vimu='vim -u ~/configs/.vimrc'

# autojump #
alias jj='j -s'

# reaload aliases.sh #
alias rea='source ~/configs/aliases.sh && echo "reloaded" && cp ~/configs/.tmux.conf ~/.tmux.conf'

# easy to change directory #
alias d='dirs -v'
alias pu='pushd'
alias po='popd'
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
alias gcia='git commit --amend -C HEAD'
alias gciam='git commit -am'
alias gci='git commit'
alias gcii='git -c user.name="lzf" -c user.email="liuzhanfei166@126.com" commit'
alias gcim='git commit -m'
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
alias grt='git remote'
alias grp='git rev-parse'
alias gsa='git stash apply'
alias gsb='git subtree'
alias gsh='git stash'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gst='git status'
alias gsw='git update-index --skip-worktree'
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
function gciamp() {
  msg=${1:-+++}
  git commit -am "$msg" && git push
}
function grh() {
 git reset HEAD "'"$1"'"
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
  read -p '确定杀死这些进程？'
  ps -ef | grep -iP "$(echo $* | sed '{s/\s+/\s/;s/^\s*//;s/\s*$//;}' | sed 's/\s/\|/g')" | grep -v grep | \
    awk '{print $2}' | xargs -i kill -9 {}
}

function composer_china() {
  composer config -g repo.packagist composer https://packagist.phpcomposer.com
}

function su_without_password() {
if [ -z "${1+x}" ]
then
  echo '$1 target_user $2 from_user'
fi
  target_user=$1
  from_user=$2
  sudo cat <<EOT >>/etc/pam.d/su
auth       [success=ignore default=1] pam_succeed_if.so user = $target_user
auth       sufficient   pam_succeed_if.so use_uid user = $from_user
EOT
unset target_user from_user
}

snippets_dir="${shell_dir}/snippets"
alias gets='get_snippets'
function update_complete_for_snippets() {
  complete -W "$(eval "ls ${snippets_dir} | xargs")" gets sets dels edits
}
update_complete_for_snippets
function get_snippets() {
declare -A snippets_array
if [ -z "${1+x}" ]
then
  eval "find ${snippets_dir} ! -path ${snippets_dir} -printf '%y %f\n' | sort -k '1' -k '2'"
else
  for i in $(eval "ls ${snippets_dir}")
  do
    if [ "$( basename $i )" = "$1" ]
    then
      if [ -L $i ]
      then
        eval "cat ${snippets_dir}/$(readlink $i)"
      else
        eval "cat ${snippets_dir}/$i"
      fi
    fi
  done
  unset i
fi

}

alias edits='edit_snippets'
function edit_snippets() {
  eval "vimu ${snippets_dir}/$1" 
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
    level=${level:-1}
    ((level=level>0?level-1:level+1))
    cat | awk '$1~/^[^/]*(\/[^/]+){'"${level/-/,}"'}$/{print $1}'
  fi
  # echo $command
  unset pre_opts debug key level
}

# test script; like python's __main__
# add the key map in .vimrc
# map gb :!export exec_in_vim=1;clear;echo ;bash %;unset exec_in_vim<CR>
if [ "$exec_in_vim" = 1 ]
then
  :
    # get_snippets test
fi
