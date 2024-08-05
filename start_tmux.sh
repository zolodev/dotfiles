#!/bin/bash

tmux new-session -d -s main
tmux split-window -v -p 70  # 70% does not seem to work

tmux send-keys -t main:0.0 'btop' C-m
tmux send-keys -t main:0.1 'tmux clock' C-m

tmux a -t 'main'
