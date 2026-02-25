#!/usr/bin/env bash

# Single instance per session: focus existing opencode pane if present
opencode_pane=$(tmux list-panes -a -F '#{pane_id} #{pane_title}' 2>/dev/null | awk '$2 == "opencode" { print $1; exit }')
if [[ -n "$opencode_pane" ]]; then
  tmux select-pane -t "$opencode_pane"
  exit 0
fi

# Split window vertically and create a right pane with fixed width (30% of window).
# Set pane title so we can find it for reuse; trap ensures closing the pane kills opencode.
tmux split-window -h -l 30% -c '#{pane_current_path}' \
  "tmux select-pane -T opencode; trap 'kill 0' EXIT HUP INT TERM; exec opencode ."
