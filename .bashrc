# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

#PS1='[\u@\h \W]\$ ' # Set a fancy prompt
PS1='\[\e[96m\][\[\e[38;5;148;1m\]\u\[\e[0;38;5;197m\]@\[\e[38;5;207;1m\]\H\[\e[0m\] \[\e[38;5;79m\]\w\[\e[96m\]]\[\e[38;5;207;1m\]>\[\e[0m\] '

# Alias definitions
alias ll='ls -lah'
alias l='ls -a1'
alias grep='grep --color=auto'
alias ..='cd ..'

# Modifying configs
alias bmod='vim ~/.bashrc'
alias bsrc='source ~/.bashrc'
alias vmod='vim ~/.vimrc'
alias omod='vim ~/.config/openbox/rc.xml'
alias osrc='openbox --restart'

alias notes='cd ~/sat; l'

# Clear sessions and logout force no prompt
alias logoutx='xfce4-session-logout --logout'
#alias logoutx='rm -rf ~/.cache/sessions/* && xfce4-session-logout --fast --logout'

#switch audio
alias s1='pactl set-card-profile alsa_card.pci-0000_07_00.1 output:hdmi-stereo'
alias s2='pactl set-card-profile alsa_card.pci-0000_07_00.1 output:hdmi-stereo-extra1'

# pacman 
alias up='sudo pacman -Syu'
alias upy='yay -Syu'
alias sync='sudo pacman -S'
alias off='sudo shutdown now'

# Path settings
export PATH=$HOME/bin:$PATH

# Enable bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# History settings
HISTFILE=~/.bash_history
HISTSIZE=10000
HISTFILESIZE=20000

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTCONTROL=ignoredups

# Append to the history file, don't overwrite it
shopt -s histappend

# Make some commands not show up in history
#export HISTIGNORE="&:ls:[bf]g:exit"

eval "$(dircolors -b ~/.dircolors)"
alias ls='ls --color=auto'


# rust stuff: 

#. "$HOME/.cargo/env"

#eval "$(zoxide init bash)"

# Created by `pipx` on 2024-11-27 18:36:52
#export PATH="$PATH:/home/haha/.local/bin"

# cuda nvidia-utils still not working?
export PATH=/opt/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/opt/cuda/lib64
