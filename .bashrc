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

# Command aliases
alias diff='colordiff'
