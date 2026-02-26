#!/usr/bin/env bash

# Single instance per session: focus existing cursor pane if present
cursor_pane=$(tmux list-panes -a -F '#{pane_id} #{pane_title}' 2>/dev/null | awk '$2 == "cursor" { print $1; exit }')
if [[ -n "$cursor_pane" ]]; then
  tmux select-pane -t "$cursor_pane"
  exit 0
fi

# Split window vertically and create a right pane with fixed width (30% of window).
# Set pane title so we can find it for reuse. Keep shell (no exec) so trap runs on pane close
# and kills the whole process group (cursor-agent + cursor-shell children).
tmux split-window -h -l 30% -c '#{pane_current_path}' \
  "tmux select-pane -T cursor; trap 'kill 0' EXIT HUP INT TERM; cursor-agent"
