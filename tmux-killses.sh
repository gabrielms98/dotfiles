#!/bin/bash


current_session=$(tmux display-message -p '#S')

tmux switch-client -n;
tmux kill-session -t "$current_session";
