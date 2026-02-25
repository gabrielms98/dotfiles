#!/usr/bin/env bash

# Single instance per session: focus existing cursor pane if present
cursor_pane=$(tmux list-panes -a -F '#{pane_id} #{pane_title}' 2>/dev/null | awk '$2 == "cursor" { print $1; exit }')
if [[ -n "$cursor_pane" ]]; then
  tmux select-pane -t "$cursor_pane"
  exit 0
fi

# Split window vertically and create a right pane with fixed width (30% of window).
# Set pane title so we can find it for reuse; trap ensures closing the pane kills cursor-agent.
tmux split-window -h -l 30% -c '#{pane_current_path}' \
  "tmux select-pane -T cursor; trap 'kill 0' EXIT HUP INT TERM; exec cursor-agent"
