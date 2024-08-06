#!/usr/bin/env bash

echo "Installing dot files for current user"
echo $USER

# Getting the full path from where the script is executed from
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Unlink previous links if any before remove files
unlink $HOME/.vimrc
unlink $HOME/.vim
unlink $HOME/.bashrc
unlink $HOME/.dir_colors
unlink $HOME/.tmux.conf
unlink $HOME/.start_tmux.sh
unlink $HOME/.hushlogin

# Remove any old files
rm -rf $HOME/.vimrc
rm -rf $HOME/.vim
mv $HOME/.bashrc $HOME/.bashrc_old
rm -rf $HOME/.dir_colors
rm -rf $HOME/.tmux.conf
rm -rf $HOME/.start_tmux.sh
rm -rf $HOME/.hushlogin

# Setup new links
ln -s $SCRIPT_DIR/vimrc $HOME/.vimrc
ln -s $SCRIPT_DIR/vim $HOME/.vim
ln -s $SCRIPT_DIR/bashrc $HOME/.bashrc
ln -s $SCRIPT_DIR/.dir_colors $HOME/.dir_colors
ln -s $SCRIPT_DIR/tmux.conf $HOME/.tmux.conf
ln -s $SCRIPT_DIR/start_tmux.sh $HOME/.start_tmux.sh
ln -s $SCRIPT_DIR/hushlogin $HOME/.hushlogin


# This will run auto update once each day
unlink /etc/cron.daily/auto_update.sh
sudo ln -s $SCRIPT_DIR/auto_update.sh /etc/cron.daily/auto_update.sh

# Install tmux plugins
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# Installing systemd tmux.service 
rm -rf $HOME/.config/systemd/user/tmux.service
mkdir -p $HOME/.config/systemd/user
ln -s $SCRIPT_DIR/tmux.service $HOME/.config/systemd/user/tmux.service

# Adding tmux.service to global systemd
sudo ln -s $SCRIPT_DIR/tmux.service /etc/systemd/system
sudo systemctl enable tmux --now
