function gerrit-review {
    BRANCH="$2"
    if [ -z "$2" ]; then
        BRANCH=$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD) | sed 's/^[a-z]*\///')
    fi  

    P_REVIEWERS=("${(@f)$(ssh $GERRIT_SERVER -p $GERRIT_PORT gerrit ls-members $1 | awk '{print $2}' | grep -v username)}")
    local reviewers
    for reviewer in $P_REVIEWERS
        do reviewers="--reviewer=$reviewer $reviewers"
    done
    git push --receive-pack="git receive-pack $reviewers" origin HEAD:refs/for/$(echo -n "$BRANCH")
}

echo "$(ssh $SERVER_GERRIT -p $PORT_GERRIT gerrit ls-groups | grep -v '\s')" > ~/.reviewgroups
_gerrit_review() {
    compadd -X '======= Review Groups =======' `cat ~/.reviewgroups`
}

compdef _gerrit_review gerrit-review
