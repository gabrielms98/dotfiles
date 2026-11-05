#!/bin/sh
# Claude Code hook: mark the tmux window Claude runs in with @claude_state,
# which window-status-format turns into a spinner (running) or ? (waiting).
# Usage: claude-state.sh running|waiting|done|clear
cat >/dev/null                      # drain the hook JSON on stdin
[ -n "$TMUX_PANE" ] || exit 0
case "$1" in
  clear) tmux set -w -u -t "$TMUX_PANE" @claude_state 2>/dev/null ;;
  running)
    tmux set -w -t "$TMUX_PANE" @claude_state running 2>/dev/null
    tmux run-shell -b ~/.config/tmux/claude-spinner.sh ;;
  *) tmux set -w -t "$TMUX_PANE" @claude_state "$1" 2>/dev/null ;;
esac
exit 0

