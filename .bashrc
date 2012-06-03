#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# The history file size, lines
export HISTSIZE=1000
# Avoid storing duplicates and whitespaces in the history file
export HISTCONTROL=ignoreboth # same as ignoredups:ignorespace

# Save all lines of a multi-line command in the same history entry
shopt -s cmdhist
# Append the history list to the history file when the shell exits,
# rather than overwriting the history file
shopt -s histappend

# Command aliases
alias diff='colordiff'
alias ll='ls -l --human-readable --kibibytes'
alias la='ll --all'
