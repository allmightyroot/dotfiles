#!/bin/bash

# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	# shellcheck disable=SC1091
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# Various Settings
export EDITOR='vim'

# User specific aliases and functions
alias ssh='ssh -q'

if [ -z "${NOZSH}" ] && { [ "$TERM" = "xterm" ] || [ "$TERM" = "xterm-256color" ] || [ "$TERM" = "screen" ]; } && type zsh &> /dev/null
then
    SHELL=$(which zsh)
    export SHELL
    if [[ -o login ]]
    then
        exec zsh -l
    else
        exec zsh
    fi
fi
