# ghclone <user/repo>
function ghclone
    if test (count $argv) -eq 1
        set repo $argv[1]
        git clone git@github.com:$repo.git
    else
        echo "Usage: ghclone user/repo"
    end
end
