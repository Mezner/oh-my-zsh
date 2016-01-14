function gerrit-review {
    BRANCH="$2"
    if [ -z "$2" ]; then
        BRANCH=$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD) | sed 's/^[a-z]*\///')
    fi  

    gerrit_server=$(git config --get gerrit.server)
    gerrit_port=$(git config --get gerrit.port)

    P_REVIEWERS=("${(@f)$(ssh $gerrit_server -p $gerrit_port gerrit ls-members $1 | awk '{print $2}' | grep -v username)}")
    local reviewers
    for reviewer in $P_REVIEWERS
        do reviewers="--reviewer=$reviewer $reviewers"
    done
    git push --receive-pack="git receive-pack $reviewers" origin HEAD:refs/for/$(echo -n "$BRANCH")
}

_gerrit_review() {
    gerrit_server=$(git config --get gerrit.server)
    gerrit_port=$(git config --get gerrit.port)
    compadd -X '======= Review Groups =======' `ssh $gerrit_server -p $gerrit_port gerrit ls-groups | grep -v '\s'`
}

compdef _gerrit_review gerrit-review
