# Disable the greeting message
set fish_greeting

# Shell exports
set -x EDITOR (which nvim)
set -x GTK_IM_MODULE fcitx
set -x QT_IM_MODULE fcitx
set -x XMODIFIERS "@im=fcitx"

abbr cat bat
alias ls 'eza --git --icons'
alias ll 'ls -l --binary'
alias la 'ls -a'
alias lla 'ls -la --bytes'
alias llt 'ls --tree'
abbr nv nvim

abbr f fd # f = fd
abbr g rg # g = ripgrep

alias cd z

function mdc
    pandoc $argv \
        -s --pdf-engine=xelatex \
        -V "numbersections:true" \
        -V "geometry:margin=30mm"
end

function mkcd
    mkdir $argv
    cd $argv
end

function cdtemp
    cd (mktemp -d)
end

# Vim keybindings
set -g fish_key_bindings fish_vi_key_bindings

function forward_or_edit
    if commandline -P
        commandline -f forward-char
    else
        edit_command_buffer
    end
end

# Insert mode keys
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
set fish_cursor_external line
set fish_cursor_visual block

starship init fish | source
micromamba shell hook --shell fish | source
zoxide init fish | source
