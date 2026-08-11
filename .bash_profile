#!/bin/bash

# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	# shellcheck disable=SC1090
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

if [ -f "$HOME/.profile" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.profile"
fi

if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
