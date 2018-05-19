# shell
alias la='ls -a'
alias cls='clear; ls'
alias cll='clear; ls -al'
alias cla='clear; ls -a'

# git aliases
alias gst='git status'
alias gco='git checkout'
alias gdf='git diff'
alias gfe='git fetch'
alias gpu='git push'
alias gre='git rebase'
alias gad='git add'
alias gbr='git branch'
alias gll='git log --oneline'
alias grh='git reset HEAD'
alias gci='git commit'

# docker aliases
alias dcm="docker-compose"
alias dex='docker exec -it'
alias dim="docker images"
alias din='docker inspect'
alias dps='docker ps'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi'
alias dstop='docker stop $(docker ps -aq)'
alias dlg='docker logs'


function dlog() {
    docker logs laradock_${1}_1
}

function dexec() {
    docker exec -it $1 bash
}

function dexla() {
    docker exec -it laradock_${1}_1 bash
}
