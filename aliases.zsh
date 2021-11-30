alias gm='git merge --no-ff'
alias gmf='git merge --ff-only'

alias go='git checkout'
alias gob='git checkout -b'
alias god='git checkout dev'

alias gl='git lol'
alias gh='git hist'

alias gf='git fetch'
alias gfu='git fetch upstream'
alias gfp='git fetch --prune'
alias gfpu='git fetch --prune upstream'
alias grh='git reset --hard'

alias gb='git branch'

# Stash
alias gst='git stash --include-untracked'

# Reset current branch to its origin state
alias grho='git reset --hard origin/`gbc`'

# Pull changes without merge
alias gpf='git pull --ff-only'
alias gpfu='git pull --ff-only upstream'

# Pull changes and rebase local commits
alias gpr='git pull --rebase'
alias gpru='git pull --rebase upstream'

# Push current branch and setup upstream
alias gpc='git push -u origin `gbc`'
# Force push current branch
alias gpcf='git push -u origin +`gbc`'

# Cherry-picking
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'

# Go to dev and update it (git update dev)
alias gud='god && gpf'

# Status, add, commit
alias gs='git status -sb'
alias ga='git add'
alias gi='git commit'
alias gam='git commit --amend'

# Reset file
alias grf='git reset HEAD'

# Unstage file
alias gcf='git checkout --'

# Rebase
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias grs='git rebase --skip'
alias grd='git rebase dev'
alias gri='git rebase -i'
alias grid='git rebase -i dev'
alias grim='git rebase -i master'

alias gsh='git show'
alias ghs='git hash'
alias gbc='git rev-parse --abbrev-ref HEAD' # git-branch-current
alias gsd='git show -s --format="%ci"' # git-show-date

# Execute on feature branch.
# Updates dev (or master) and then rebases current branch
alias gudc='gcd && gpf && gco - && grbd'
alias gumc='gcm && gpf && gco - && grbm'

# git-svn aliases
alias gog='go git-svn'
alias gsr='git svn rebase'
alias gsrb='git rebase git-svn'
alias gugc='gog && gsr && go - && gsrb'
alias gsc='git svn dcommit'

# defunkt hub alias
if type hub &> /dev/null; then
    alias git='hub'
    alias ghbr='git browse'
fi

# fasd
alias e='a -e $EDITOR'
alias o='a -e open'
alias m='d -e mc'

# npm
alias nit='npm install && npm test'

# kubernetes
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
# get all namespaced k8s resources
alias kga='kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found'
# get ip address of a pod
kpip() {
  kubectl --namespace $1 get pod $2 -o jsonpath="{.status.podIP}"
}
# get ip address of a service
ksip() {
  kubectl --namespace $1 get service $2 -o jsonpath="{.spec.clusterIP}"
}

# minikube
alias mk='minikube start --extra-config=apiserver.authorization-mode=RBAC --extra-config=apiserver.enable-swagger-ui=true --feature-gates="TTLAfterFinished=true"'
