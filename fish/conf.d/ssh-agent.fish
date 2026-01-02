# ~/.config/fish/conf.d/ssh-agent.fish

# ~/.config/fish/conf.d/ssh-agent.fish
status is-interactive; or exit

# Start agent nếu chưa có socket hợp lệ
if not set -q SSH_AUTH_SOCK; or not test -S "$SSH_AUTH_SOCK"
    set -l out (ssh-agent -s)

    for line in $out
        if string match -qr '^SSH_AUTH_SOCK=' -- $line
            set -gx SSH_AUTH_SOCK (string replace -r '^SSH_AUTH_SOCK=([^;]+);.*$' '$1' -- $line)
        else if string match -qr '^SSH_AGENT_PID=' -- $line
            set -gx SSH_AGENT_PID (string replace -r '^SSH_AGENT_PID=([^;]+);.*$' '$1' -- $line)
        end
    end
end

# Add key nếu agent chưa có key nào
if test -f ~/.ssh/id_ed25519
    ssh-add -l >/dev/null 2>&1; or ssh-add ~/.ssh/id_ed25519 >/dev/null 2>&1
end
