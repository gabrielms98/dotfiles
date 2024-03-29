#!/usr/bin/env bash

tmux new-window -n 'lazygit' -c '#{pane_current_path}' 'lazygit'
# switch to the new window
tmux select-window -t ':lazygit'
