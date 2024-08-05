#!/bin/bash

tmux new-session -d -s main
tmux split-window -v -p 70           


# Calculate sizes based on current window size
W=$(tmux display -p '#{window_width}')
L=$(expr $W \* 7 / 10) # 70% for the left pane
R=$(expr $W \* 3 / 10) # 30% for the right pane

# Resize panes
tmux resize-pane -t main:0.0 -x $L
tmux resize-pane -t main:0.1 -x $R

tmux send-keys -t main:0.0 'btop' C-m
tmux send-keys -t main:0.1 'tmux clock' C-m

tmux a -t 'main'
