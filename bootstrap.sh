#!/bin/bash

# This file is used to bootstrap a github codespaces workspace with my usual standards, etc
# This sort of combines my usual ansible based sysprep stuff with one script
# Sources of inspiration: 
# https://www.huuhka.net/personalizing-your-github-codespaces/
# https://bea.stollnitz.com/blog/codespaces-terminal/


export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export INSTALL_ZSH=true
export USERNAME=`whoami`
export DOTFILESHOME=/workspaces/.codespaces/.persistedshare/dotfiles
## update and install my usual packages (minus some that aren't needed in codespaces)
sudo apt-get update
sudo apt-get -y install --no-install-recommends apt-utils 2>&1
sudo apt-get install -y \
  autojump \
  curl \
  dstat \
  git \
  glances \
  gnupg2 \
  htop \
  jq \
  less \
  lsb-release \
  multitail \
  ncdu \
  openssh-client \
  p7zip \
  powerline \
  python3-pip \
  python3-virtualenv \
  sudo \
  wget \
  unzip \
  vim-nox

# Install & Configure Zsh
if [ "$INSTALL_ZSH" = "true" ]
then


    cp -f $DOTFILESHOME/zshrc/zshrc-antigen-ubuntu ~/.zshrc
    cp -f $DOTFILESHOME/zshrc/zshrc-antigen-common ~/.zshrc-common
    mkdir -p ~/.repos/externalgit
    pushd `pwd`
    cd ~/.repos/externalgit
    git clone https://github.com/zsh-users/antigen.git
    popd
#    chsh -s /usr/bin/zsh $USERNAME
fi

# Cleanup
sudo apt-get autoremove -y
sudo apt-get autoremove -y
sudo rm -rf /var/lib/apt/lists/*