#!/bin/sh
# This script builds and installs a feature full Vim from source.

# sudo apt autoremove vim vim-runtime gvim

sudo apt install -y git \
	python3-dev \
	ruby-dev

sudo apt install -y build-essential

sudo apt install -y libc6 \
	libc6-dev \
	libc-dev-bin \
	libc-bin \
	libatk1.0-dev \
	libcairo2-dev \
	libgtk2.0-dev \
	liblua5.1-0-dev \
	libncurses5-dev \
	libperl-dev \
	libx11-dev \
	libxpm-dev \
	libxt-dev \
	lua5.1 \
	liblua5.1-dev

prevDir=$(pwd)
git clone https://github.com/vim/vim.git /tmp/vim-src


cd /tmp/vim-src
python3-config --configdir


./configure --with-features=huge \
--enable-cscope \
--enable-gui=auto \
--enable-luainterp=yes \
--enable-multibyte \
--enable-perlinterp=yes \
--enable-python3interp=yes \
--enable-rubyinterp=yes \
--with-python3-command=$PYTHON_VER \
--with-python3-config-dir=$(python3-config --configdir) \
--prefix=/usr/local


make && sudo make install && echo "Vim install OK"

cd $prevDir
