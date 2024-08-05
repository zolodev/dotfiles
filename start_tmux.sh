#!/bin/bash

# Start a new session named 'main'
tmux new-session -d -s main

# Split the window
tmux split-window -v -p 70  # 70% does not seem to work

# Load the first pane with btop
tmux send-keys -t main:0.0 'btop' C-m

# Load the secon pane with tmux clock
tmux send-keys -t main:0.1 'tmux clock' C-m

# Attach to the session
tmux a -t 'main'
