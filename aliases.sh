# shell
alias la='ls -a'
alias cls='clear; ls'
alias cll='clear; ls -al'
alias cla='clear; ls -a'

# git aliases
alias gad='git add'
alias gbr='git branch'
alias gci='git commit'
alias gco='git checkout'
alias gdf='git diff'
alias gfe='git fetch'
alias gll='git log --oneline'
alias gpu='git push'
alias gre='git rebase'
alias grh='git reset HEAD'
alias gst='git status'
alias gsw='git update-index --skip-worktree'
alias gnsw='git update-index --no-skip-worktree'

# docker aliases
alias dcm="docker-compose"
alias dex='docker exec -it'
alias dim="docker images"
alias din='docker inspect'
alias dlg='docker logs'
alias dps='docker ps'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi'
alias dstp='docker stop $(docker ps -aq)'


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
