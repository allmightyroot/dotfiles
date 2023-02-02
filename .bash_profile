# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi

if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
