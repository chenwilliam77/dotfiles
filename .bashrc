# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
export TERM="xterm-256color"

# Set default editor for command-line programs
export EDITOR="emacs"

# Custom PS1:
#   user@hostname current-directory (git branch) $
# See:
# 1. https://www.linux.com/learn/how-make-fancy-and-useful-bash-prompt-linux
# 2. https://coderwall.com/p/fasnya/add-git-branch-name-to-bash-prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[\e[1;35m\]\u@\h \[\e[0;35m\]\w\[\e[0;36m\]\$(parse_git_branch)\[\e[0;35m\] $ \[\e[m\]"

# Command aliases
alias cp="cp -i"
alias e="emacs -nw"
alias la="ls -a"
alias ld="ls -d */"
alias ll="ls -l -h"
alias mv="mv -i"
alias mytop="top -u $USER"

export LS_COLORS=$LS_COLORS'di=1;34:'

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

# Julia alias
alias julia="/Applications/Julia-1.3.app/Contents/Resources/julia/bin/julia"
alias julia105="/Applications/Julia-1.0.app/Contents/Resources/julia/bin/julia"
alias julia111="/Applications/Julia-1.1.app/Contents/Resources/julia/bin/julia"
alias julia120="/Applications/Julia-1.2.app/Contents/Resources/julia/bin/julia"
alias julia131="/Applications/Julia-1.3.app/Contents/Resources/julia/bin/julia"
alias julia142="/Applications/Julia-1.4.app/Contents/Resources/julia/bin/julia"
alias julia150="/Applications/Julia-1.5.app/Contents/Resources/julia/bin/julia"
alias julia161="/Applications/Julia-1.6.app/Contents/Resources/julia/bin/julia --startup-file=yes"
