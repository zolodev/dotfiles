#!/bin/bash

SESSION="main"

# If session already exists, just attach
if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
  exit 0
fi

# Build the default layout
tmux new-session -d -s "$SESSION"

# Split the window
tmux split-window -v -p 70
tmux split-window -h

# Apply exact layout
tmux select-layout -t "$SESSION:0" '129a,252x69,0,0[252x30,0,0,0,252x38,0,31{214x38,0,31,1,37x38,215,31,2}]'

# Load panes
tmux send-keys -t "$SESSION:0.0" 'btop' C-m
tmux send-keys -t "$SESSION:0.1" 'tmux clock' C-m

# Attach
tmux attach -t "$SESSION"
