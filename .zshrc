. ~/.config/shellrc

HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000

setopt \
  always_to_end \
  auto_list \
  auto_menu \
  auto_param_keys \
  auto_remove_slash \
  list_beep \
  list_types \
  bad_pattern \
  magic_equal_subst \
  extended_glob \
  numeric_glob_sort \
  no_match \
  append_history \
  bang_hist \
  extended_history \
  hist_beep \
  hist_ignore_dups \
  hist_ignore_space \
  hist_reduce_blanks \
  correct_all \
  print_eight_bit \
  print_exit_value \
  short_loops \
  check_jobs \
  notify \
  beep \
  prompt_subst

# vi bindings
bindkey -v

# cmdtime

typeset -gF cmdtime_starttime
typeset -gF1 cmdtime_time >&/dev/null

cmdtime_preexec() {
  typeset -gF SECONDS
  cmdtime_starttime="$SECONDS"
}

cmdtime_precmd() {
  typeset -gF SECONDS
  cmdtime_time="$(($SECONDS-$cmdtime_starttime))"
}

typeset -ga preexec_functions
typeset -ga precmd_functions
preexec_functions+=cmdtime_preexec
precmd_functions+=cmdtime_precmd
cmdtime_preexec

# prompt

color_def="$(tput setaf 0 2>/dev/null; tput sgr0 2>/dev/null)"
color_err="$(tput setaf 1 2>/dev/null; tput bold 2>/dev/null)"
color_inf="$(tput setaf 0 2>/dev/null; tput bold 2>/dev/null)"
color_root="$(tput setaf 1 2>/dev/null; tput bold 2>/dev/null)"
color_user="$(tput setaf 4 2>/dev/null; tput bold 2>/dev/null)"
lf=$'\n'

if tput hs 2>/dev/null; then
  # We have a statusline.
  PS1="%{$(tput tsl 2>/dev/null)%n@%m: %~$(tput fsl 2>/dev/null)%}"
  statusline_preexec () { print -Pn "$(tput tsl 2>/dev/null)%n@%m: %~ %# "; printf "%.100s$(tput fsl 2>/dev/null)" "$1"; }
  typeset -ga preexec_functions
  preexec_functions+=statusline_preexec
else
  PS1=
fi
PS1="$PS1%(?..%{$color_err%}\$? )%{$color_inf%}\${cmdtime_time}s %* \${STY:+screen }%m %~$lf%{%(#.$color_root.$color_user)%}%# %{$color_def%}"

unset color_def color_err color_inf color_dol color_root color_user lf

autoload compinit
compinit

# Completion cache.
zstyle ':completion::complete:*' use-cache 1

#zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' file-sort name
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*' group-name ''

true

# vim:set et sw=2 sts=2:
