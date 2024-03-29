#!/bin/bash

# This file is used to bootstrap a github codespaces workspace with my usual standards, etc
# This sort of combines my usual ansible based sysprep stuff with one script
# Sources of inspiration: 
# https://www.huuhka.net/personalizing-your-github-codespaces/
# https://bea.stollnitz.com/blog/codespaces-terminal/
# https://github.com/axonasif/dotsh


export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export INSTALL_ZSH=true
export USERNAME=`whoami`



function is::gitpod () 
{ 
    test -e /usr/bin/gp && test -v GITPOD_REPO_ROOT
};
function is::codespaces () 
{ 
    test -v CODESPACES || test -e /home/codespaces
};


## update and install my usual packages (minus some that aren't needed in codespaces)
sudo apt-get update
# sudo apt-get upgrade
sudo apt-get -y install --no-install-recommends apt-utils 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get install -o Dpkg::Options::="--force-confnew" -fuyq \
  autojump \
  byobu \
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
  tmux \
  wget \
  unzip \
  vim-nox

if is::gitpod; then
    { 
       DOTFILESHOME=/home/gitpod/.dotfiles
       # Install & Configure Zsh
      if [ "$INSTALL_ZSH" = "true" ]
      then

          cp -f $DOTFILESHOME/.bash_profile ~/.bash_profile
          cp -f $DOTFILESHOME/.bashrc ~/.bashrc
          cp -f $DOTFILESHOME/zshrc/zshrc-antigen-ubuntu ~/.zshrc
          cp -f $DOTFILESHOME/zshrc/zshrc-antigen-common ~/.zshrc-common
          mkdir -p ~/.repos/externalgit
          mkdir -p ~/.ssh
          cp -f $DOTFILESHOME/ssh-config ~/.ssh/config
          pushd `pwd`
          cd ~/.repos/externalgit
          git clone https://github.com/zsh-users/antigen.git
          popd
          sudo chsh -s /usr/bin/zsh $USERNAME
      fi 

    };
fi

if is::codespaces; then
    { 
       DOTFILESHOME=/workspaces/.codespaces/.persistedshare/dotfiles
       # Install & Configure Zsh
      if [ "$INSTALL_ZSH" = "true" ]
      then

          cp -f $DOTFILESHOME/.bash_profile ~/.bash_profile
          cp -f $DOTFILESHOME/.bashrc ~/.bashrc
          cp -f $DOTFILESHOME/zshrc/zshrc-antigen-ubuntu ~/.zshrc
          cp -f $DOTFILESHOME/zshrc/zshrc-antigen-common ~/.zshrc-common
          mkdir -p ~/.repos/externalgit
          mkdir -p ~/.ssh
          cp -f $DOTFILESHOME/ssh-config ~/.ssh/config
          pushd `pwd`
          cd ~/.repos/externalgit
          git clone https://github.com/zsh-users/antigen.git
          popd
          sudo chsh -s /usr/bin/zsh $USERNAME
      fi 

    };
fi



# Cleanup
sudo apt-get autoremove -y
sudo apt-get autoremove -y
sudo rm -rf /var/lib/apt/lists/*