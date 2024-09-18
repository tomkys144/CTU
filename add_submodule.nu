ls **/* -a | where type == dir | where name ends-with '.git' | where name != '.git' | each {|repo|
    let $directory = $repo.name | str replace '/.git' ''
    cd $directory
    let $url = git config --get remote.origin.url
    cd ~/Documents/CTU
    echo $directory
    git rm -rf --cached $directory

    git submodule add $url $directory
}
