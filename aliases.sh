#!/bin/basn
shell_dir=$( cd "$( dirname $0  )" && pwd )

# 列出文件或目录
alias l='ls -al'
alias la='ls -a'
alias lla='ll -a'
alias lsd='ls -l | grep ^d'
alias cls='clear; ls'
alias cll='clear; ls -al'
alias cla='clear; ls -a'
alias vimu='vim -u ~/configs/.vimrc'

# autojump
alias jj='j -s'

# 重新加载aliases.sh
alias rea='source ~/configs/aliases.sh && echo "加载成功" && cp ~/configs/.tmux.conf ~/.tmux.conf'

# 方便切换目录
alias d='dirs -v'
alias pu='pushd'
alias po='popd'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# laravel artisan命令
alias cmp='composer --no-plugins --no-scripts'
alias cmpdp="$cmp dumpautoload"
php_artisan='php artisan'
alias art=${php_artisan}
alias art.mct="${php_artisan} make:controller"
alias art.mm="${php_artisan} make:model"
alias artmg="${php_artisan} make:migration"
alias artm="${php_artisan} migrate"
alias artms="${php_artisan} migrate:status"
alias artmr="${php_artisan} migrate:rollback"
alias db:reset="php artisan migrate:reset && php artisan migrate --seed"

# git
alias gad='git add'
alias gbr='git branch'
alias gceu='gcf user.name "lzf" && gcf user.email "liuzhanfei167@126.com"'
alias gcf='git config'
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
alias grh='git reset HEAD'
alias grmc='git rm --cached'
alias grm='git rm'
alias grs='git reset'
alias grt='git remote'
alias gsa='git stash apply'
alias gsb='git subtree'
alias gsh='git stash'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gst='git status'
alias gsw='git update-index --skip-worktree'
function grtad() {
  url=$2
  url_in_remote=$(git remote get-url $2 2>/dev/null)
  [ -n "${url_in_remote}" ] && url=$url_in_remote
  git remote add $1 $url 2>/dev/null
  git remote set-url all --add $url 2>/dev/null || \
    git remote add all $url
  unset url url_in_remote
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

# docker
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
function get_snippets() {
declare -A snippets_array
if [ -z "${1+x}" ]
then
  # command argv is empty, list all avaiable argvs(aka:snippets key name)
  find ${snippets_dir} ! -path ${snippets_dir} -printf '%y %f\n' | sort -k '1' -k '2'
else
  for i in $shell_dir/snippets/*
  do
    if [ "$( basename $i )" = "$1" ]
    then
      if [ -L "$i" ]
      then
        cat $(readlink $i)
      else
        cat $i
      fi
    fi
  done
  unset i
fi

}

alias edits='edit_snippets'
function edit_snippets() {
  vim "${snippets_dir}/$1" 
}
alias sets='set_snippets'
function set_snippets() {
  echo ${@:2} > "${snippets_dir}/$1"
}
alias setsd='set_snippets_heredoc'
function set_snippets_heredoc() {
  read -d '' heredoc
  echo $heredoc > "${snippets_dir}/$1"
}
alias dels='delete_snippets'
function delete_snippets() {
  rm "${snippets_dir}/$1"
}

source <(gets autoc_for_gets)
source <(gets history_export)

alias gdr='git_dir_worktree'
function git_dir_worktree() {
  if [ -z "${1+x}" ]
  then
    gets current_git_dir 2>/dev/null
  else
    if [ "$1" = "del" ]
    then
      dels current_git_dir 2>/dev/null && echo deleted || echo not set
    else
      if [ "$1" = "." ]
      then
        1=$(pwd)
      fi
      sets current_git_dir $1
      git_dir=$(gets current_git_dir | nocolor)
      alias git="git --git-dir=${git_dir}/.git --work-tree=${git_dir}"
    fi
  fi
}

function nocolor() {
  sed 's/\x1b\[[0-9;]*m//g'
}

function gls() {
  read -d '' USAGE <<EOT
USAGE:
  -r   recurse   recursive
  -d             only directory
  -L   level     Descend only level directories deep.
EOT
  # USAGE="Usage: command -ihv args"
  if [ "$#" = 0 ] ; then
    echo $USAGE
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
  command="git ls-tree --name-only $pre_opts"
  if [ -z "${debug+x}" ] 
  then
    command+=' 2>/dev/null'
  fi
  eval $command |
  if [ -z ${level+x} ] 
  then
    cat
  else
    level=${level:-1}
    cat | awk '$1~/^[^/]*(\/[^/]+){'"${level/-/,}"'}$/{print $1}'
  fi
  # echo $command
  unset pre_opts debug key level
}

# test script; like python's __main__
if [ "$exec_in_vim" = 1 ]
then
  :
    # get_snippets test
fi
