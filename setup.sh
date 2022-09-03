#!/bin/bash

echo "Installing dot files for current user"
echo $USER


# CURRENT_PATH=${pwd}

# echo $HOME


# $PWD/vimrc

rm -rf $HOME/.vimrc
rm -rf $HOME/.vim
mv $HOME/.bashrc $HOME/.bashrc_old
rm -rf $HOME/.dir_colors
rm -rf $HOME/.tmux.conf


unlink $HOME/.vimrc
ln -s $PWD/vimrc $HOME/.vimrc

unlink $HOME/.vim
ln -s $PWD/vim $HOME/.vim

unlink $HOME/.bashrc
ln -s $PWD/bashrc $HOME/.bashrc

unlink $HOME/.dir_colors
ln -s $PWD/.dir_colors $HOME/.dir_colors

unlink $HOME/.tmux.conf
ln -s $PWD/tmux.conf $HOME/.tmux.conf



# Install tmux plugins
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

rm -rf $HOME/.config/systemd/user/tmux.service
mkdir -p $HOME/.config/systemd/user
ln -s $PWD/tmux.service $HOME/.config/systemd/user/tmux.service

sudo ln -s $PWD/tmux.service /etc/systemd/system
sudo systemctl enable tmux --now
