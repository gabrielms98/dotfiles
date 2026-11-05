#!/bin/sh
# Animates @spin_frame (5 fps) while any tmux window has @claude_state=running,
# then exits. Started by claude-state.sh; a lock keeps it to one instance.
lock="${TMPDIR:-/tmp}/tmux-claude-spinner.pid"
if [ -f "$lock" ] && kill -0 "$(cat "$lock")" 2>/dev/null; then exit 0; fi
echo $$ >"$lock"
trap 'rm -f "$lock"' EXIT
set -- · • ● •
tick=0
while :; do
  for f in "$@"; do
    tmux set -g @spin_frame "$f" 2>/dev/null || exit 0   # set-option redraws the status lines
    sleep 0.2
  done
  tmux list-windows -a -F '#{@claude_state}' 2>/dev/null | grep -qx running || exit 0
done

