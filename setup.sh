#!/bin/bash

echo "Installing dot files for current user"
echo $USER


# CURRENT_PATH=${pwd}

# echo $HOME


# $PWD/vimrc

rm -rf $HOME/.vimrc
rm -rf $HOME/.vim
rm -rf $HOME/.bashrc


ln -s $PWD/vimrc $HOME/.vimrc
ln -s $PWD/vim $HOME/.vim
ln -s $PWD/bashrc $HOME/.bashrc
