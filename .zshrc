
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Plugin history-search-multi-word loaded with investigating.
zinit load zdharma-continuum/history-search-multi-word

# Two regular plugins loaded without investigating.
zinit light zdharma-continuum/fast-syntax-highlighting

# Add in zsh plugins
#zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets - makes it so ur getting ohmyzsh without the load via url
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

# replay all cached completions
zinit cdreplay -q

# custom prompt:
#eval "$(oh-my-posh init zsh)"
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

# Key beindings
# Enable vi mode
bindkey -v
# Usefeul emacs key bindings retained with vi mode
bindkey '^k' kill-line
bindkey '^w' backward-kill-word
bindkey '^f' forward-word
bindkey '^o' backward-word

#bindkey '^P' up-history
#bindkey '^N' down-history
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

bindkey '^[w' kill-region

bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^r' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

eval "$(zoxide init bash)"

# Created by `pipx` on 2024-11-27 18:36:52
export PATH="$PATH:/home/haha/.local/bin"

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  #makes it not case sensitive autocompl
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# disable the default zshell completion menu use fzf
zstyle ':completion:*' menu no

# gives nice preview of dir with cd autocompl
#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias ll='ls -al --color'
alias l='ls -1 --color'
alias lr='ls -1t --color'
alias c='clear'
alias vmod='vim ~/.vimrc'
alias nvmod='nvim ~/.config/nvim/init.lua'
alias zmod='vim ~/.zshrc'
alias zsrc='source ~/.zshrc'
alias amod='vim ~/.config/alacritty/alacritty.toml'
alias tmod='vim ~/.config/tmux/tmux.conf'

alias f2c='xclip -sel c <'
alias packvc='apt-cache policy' #check version of package

#My bashrc aliases:

# pacman 
alias up='sudo pacman -Syu'
alias upy='yay -Syu'
alias sync='sudo pacman -S'

alias grep='grep --color=auto'

# Modifying configs
alias bmod='vim ~/.bashrc'
alias bsrc='source ~/.bashrc'
alias zmod='vim ~/.zshrc'
alias zsrc='source ~/.zshrc'
alias vmod='vim ~/.vimrc'
alias kmod='vim ~/.config/kitty/kitty.conf'
alias amod='vim ~/.config/alacritty/alacritty.toml'
alias rmod='vim ~/.config/rofi/config.rasi'

alias omod='vim ~/.config/openbox/rc.xml'
alias osrc='openbox --restart'


alias notes='cd ~/sat; l'

# Clear sessions and logout force no prompt
alias logoutx='xfce4-session-logout --logout'
#alias logoutx='rm -rf ~/.cache/sessions/* && xfce4-session-logout --fast --logout'

#switch audio
alias s1='pactl set-card-profile alsa_card.pci-0000_07_00.1 output:hdmi-stereo'
alias s2='pactl set-card-profile alsa_card.pci-0000_07_00.1 output:hdmi-stereo-extra1'

#monitor brightness
alias bri1='xrandr --output DP-2 --brightness 1;xrandr --output DP-4 --brightness 1'
alias bril='xrandr --output DP-2 --brightness 0.4;xrandr --output DP-4 --brightness 0.4'
alias bric='xrandr --verbose | grep -i brightness'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

eval "$(dircolors -b ~/.dircolors)"
alias ls='ls --color=auto'

# cuda nvidia-utils still not working?
export PATH=/opt/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/opt/cuda/lib64
