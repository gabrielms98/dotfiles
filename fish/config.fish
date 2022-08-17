if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias lsa="ls -la"
alias vim="nvim"
alias ff="~/.config/tmux-finder.sh"
alias pip="python3 -m pip"
alias ta="tmux a"
alias tk="~/.config/tmux-killses.sh"

starship init fish | source
