#!/usr/bin/env bash

tmux new-window -n 'lazydocker' -c '#{pane_current_path}' 'lazydocker'
# switch to the new window
tmux select-window -t ':lazydocker'
