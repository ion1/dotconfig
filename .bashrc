# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

. ~/.config/shellrc

# Vi mode.
set -o vi

# don't put duplicate lines in the history. See bash(1) for more options
HISTCONTROL=erasedups:ignorespace

HISTTIMEFORMAT="%d-%H%M%S  "

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# ...
shopt -s huponexit no_empty_cmd_completion

color_def="$(tput setaf 0 2>/dev/null; tput sgr0 2>/dev/null)"
color_err="$(tput setaf 1 2>/dev/null; tput bold 2>/dev/null)"
color_inf="$(tput setaf 0 2>/dev/null; tput bold 2>/dev/null)"
if test "$EUID" = "0"; then
  color_dol="$(tput setaf 1 2>/dev/null; tput bold 2>/dev/null)"
else
  color_dol="$(tput setaf 4 2>/dev/null; tput bold 2>/dev/null)"
fi
PROMPT_COMMAND='MYERR="$?"; test "$MYERR" != "0" && printf "'"$color_err"'%d " "$MYERR";'
PS1="\[${color_inf}\]"'\t ${STY:+screen }\h \w\n'"\[${color_dol}\]"'\$ '"\[${color_def}\]"
unset color_def color_err color_inf color_dol

if tput hs 2>/dev/null; then
  # Set the title to user@host: dir
  PROMPT_COMMAND="$PROMPT_COMMAND"' tput tsl 2>/dev/null; printf "%s@%s: %s" "$USER" "$HOSTNAME" "${PWD/$HOME/~}"; tput fsl 2>/dev/null;'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# vim:set et sw=2 sts=2:
