# 列出文件或目录
alias la='ls -a'
alias lla='ll -a'
alias lsd='ls -l | grep ^d'
alias cls='clear; ls'
alias cll='clear; ls -al'
alias cla='clear; ls -a'

# autojump
alias jj='j -s'

# 重新加载aliases.sh
alias rea='source ~/configs/aliases.sh && echo "加载成功"'

# 方便切换目录
alias d='dirs -v'
alias pu='pushd'
alias po='popd'
alias po='popd'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# laravel artisan命令
alias cdump='composer dumpautoload'
php_artisan='php artisan'
alias cmp='composer'
alias art=${php_artisan}
alias artmg="${php_artisan} make:migration"
alias artm="${php_artisan} migrate"
alias artms="${php_artisan} migrate:status"
alias artmr="${php_artisan} migrate:rollback"
alias db:reset="php artisan migrate:reset && php artisan migrate --seed"

# git
alias gad='git add'
alias gbr='git branch'
alias gci='git commit'
alias gciam='git commit -am'
alias gcim='git commit -m'
alias gcii='git -c user.name="liuzhanfei" -c user.email="liuzhanfei166@126.com" commit'
alias gco='git checkout'
alias gcf='git config'
alias gcl='git clean'
alias gdf='git diff'
alias gfe='git fetch'
alias gl='git log --oneline'
alias gll="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gme='git merge'
alias gps='git push'
alias gpl='git pull'
alias grb='git rebase'
alias grh='git reset HEAD'
alias grm='git remove'
alias grs='git reset'
alias grt='git remote'
alias gst='git status'
alias gsw='git update-index --skip-worktree'
alias gnsw='git update-index --no-skip-worktree'

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
    target_user=$1
    from_user=$2
    sudo cat <<EOT >>/etc/pam.d/su
auth       [success=ignore default=1] pam_succeed_if.so user = $target_user
auth       sufficient   pam_succeed_if.so use_uid user = $from_user
EOT
}

# vim +python switch 
# install if not 
[ -z "$(apt list --installed 2>/dev/null | grep vim-nox-py2)" ] && {
    apt-get install vim-nox-py2 -y >/dev/null || {
        echo 'vim的+python切换工具安装失败'
    }
}
# vim-python-version-switch
alias vpvs='sudo update-alternatives --config vim'
