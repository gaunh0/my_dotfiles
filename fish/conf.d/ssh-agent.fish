# ~/.config/fish/conf.d/ssh-agent.fish
if not set -q SSH_AUTH_SOCK
    # Khởi động ssh-agent nếu chưa có
    eval (ssh-agent -c -s | string collect)
    # Thêm key (tự unlock 1 lần mỗi session)
    ssh-add ~/.ssh/id_ed25519 >/dev/null 2>&1
end
