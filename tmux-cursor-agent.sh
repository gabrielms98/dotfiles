#!/usr/bin/env bash

# Split window vertically and create a right pane with fixed width (30% of window)
# The -l flag sets the width in percentage or absolute columns
tmux split-window -h -l 30% -c '#{pane_current_path}' 'cursor-agent'

# Optional: Switch focus back to the left pane (original pane)
# Uncomment the line below if you want to keep focus on the original pane
# tmux select-pane -t 0
