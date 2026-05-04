#!/bin/bash

SESSION="main"
RESURRECT_FILE="$HOME/dotfiles/tmux_resurrect_save_files/last"

# If session already exists, just attach
if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
  exit 0
fi

# ---------------------------------------------------------------------------
# Read pane working directories from resurrect file
# ---------------------------------------------------------------------------
PANE0_DIR="$HOME"
PANE1_DIR="$HOME"
PANE2_DIR="$HOME"

if [ -f "$RESURRECT_FILE" ]; then
  PANE0_DIR=$(grep "^pane" "$RESURRECT_FILE" | awk 'NR==1{print $8}' | sed 's/^://')
  PANE1_DIR=$(grep "^pane" "$RESURRECT_FILE" | awk 'NR==2{print $8}' | sed 's/^://')
  PANE2_DIR=$(grep "^pane" "$RESURRECT_FILE" | awk 'NR==3{print $8}' | sed 's/^://')

  [ -d "$PANE0_DIR" ] || PANE0_DIR="$HOME"
  [ -d "$PANE1_DIR" ] || PANE1_DIR="$HOME"
  [ -d "$PANE2_DIR" ] || PANE2_DIR="$HOME"
fi

# ---------------------------------------------------------------------------
# Build layout and capture pane IDs directly from split-window
# ---------------------------------------------------------------------------
tmux new-session -d -s "$SESSION" -c "$PANE0_DIR"
PANE0=$(tmux display-message -t "$SESSION:0.0" -p "#{pane_id}")
PANE1=$(tmux split-window -v -p 70 -c "$PANE1_DIR" -P -F "#{pane_id}")
PANE2=$(tmux split-window -h -c "$PANE2_DIR" -P -F "#{pane_id}")

# Apply exact layout
tmux select-layout -t "$SESSION:0" '129a,252x69,0,0[252x30,0,0,0,252x38,0,31{214x38,0,31,1,37x38,215,31,2}]'

sleep 0.5

# Load panes using stable pane IDs
tmux send-keys -t "$PANE0" 'btop' C-m
tmux send-keys -t "$PANE2" 'tmux clock' C-m

# Focus on PANE1 (bottom left — main working pane)
tmux select-pane -t "$PANE1"

# Attach
tmux attach -t "$SESSION"
