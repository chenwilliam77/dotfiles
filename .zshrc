# .zshrc

# User specific aliases and functions
export TERM="xterm-256color"

# Set default editor for command-line programs
export EDITOR="emacs"

# Bash-like navigation in zsh
autoload -U select-word-style
select-word-style bash

# Enable substitution in the prompt.
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    ' %F{6}(%F{6}%b%F{6}|%F{6}%a%F{6})%f'
zstyle ':vcs_info:*' formats       \
    ' %F{6}(%F{6}%b%F{6})%f'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
PROMPT='%F{magenta}%/%f$(vcs_info_wrapper) %# '
PROMPT=$(echo $PROMPT | sed 's/(base) //') # get rid of (base) from conda

# Command aliases
alias cp="cp -i"
alias e="emacs -nw"
alias la="ls -a"
alias ld="ls -d */"
alias ll="ls -l -h"
alias mv="mv -i"

export LS_COLORS=$LS_COLORS'di=1;34:'

# Disable globbing on the remote path. Needed to make scp work
alias scp='noglob scp_wrap'
function scp_wrap {
  local -a args
  local i
  for i in "$@"; do case $i in
    (*:*) args+=($i) ;;
    (*) args+=(${~i}) ;;
  esac; done
  command scp "${(@)args}"
}

# Stop graphical display popup for password when git pushing
unset SSH_ASKPASS

# Set default file-creation mode to u=rwx, g=rwx, o=rx
# Check your (human-readable) permissions using "umask -S"
umask 0002

# When evince and other graphical displays don't work, it's often because the
# DISPLAY environment variable inside tmux isn't the same as the one outside
# tmux.
#
# 1. Detach from tmux session and use cache_display.
# 2. Reattach to tmux session and use parse_display. (You'll have to do this in
#    each pane in which you want to open a graphical display.)
cache_display() {
    echo "$DISPLAY" > ~/.DISPLAY
    echo "DISPLAY cached as $DISPLAY"
}

parse_display() {
    DISPLAY_OLD="$DISPLAY"
    export DISPLAY="$(cat ~/.DISPLAY)"
    echo "DISPLAY updated from $DISPLAY_OLD to $DISPLAY"
}

alias tmux='/usr/local/bin/tmux'
