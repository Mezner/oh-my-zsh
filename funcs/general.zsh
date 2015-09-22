# opens a browser window
function browse {
    if [[ $platform == 'cygwin' ]]; then
        /cygdrive/c/Windows/explorer.exe /e,`cygpath -w "$1"`
    elif [[ $platform == 'linux' ]]; then
        nautilus "$1"
    fi
}

function v () {
    gvim --remote "$1" .
}

function auth () {
    ssh-add ~/.ssh/id_rsa
}

function untar ()
{
    ar xvfj "$1"
}

function gcr ()
{
    echo "grep -rin ${@:1} ."
    grep -rin ${@:1} .
}

function ifind()
{
    # echo "find . -iname ${@:1}"
    find . -iname ${@:1}
}

function drop-caches()
{
    sudo bash -c "echo 3 > /proc/sys/vm/drop_caches"
}

function resource()
{
    source ~/.zshrc
}
