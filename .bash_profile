#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Add directories to the path
export PATH=$PATH:$HOME/bin:$HOME/.cabal/bin

eval `ssh-agent`

