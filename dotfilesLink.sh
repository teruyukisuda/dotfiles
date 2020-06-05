#!/bin/sh
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.ideavimrc ~/.ideavimrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.vrapperrc ~/.vrapperrc
ln -sf ~/dotfiles/.bash_profile ~/.bash_profile
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.tigrc ~/.tigrc
unlink ~/.vim/colors
ln -sf ~/dotfiles/colors ~/.vim/colors
unlink ~/.vim/indent
ln -sf ~/dotfiles/indent ~/.vim/indent
