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

# Colors for the prompt (optional, but makes it readable)
autoload -U colors && colors # Keep this early, it's needed for prompt colors

# --- VCS Info Setup (Keep as is) ---
autoload -Uz vcs_info # This needs to be available
zstyle ':vcs_info:*' enable
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{cyan}A%f' # Staged changes
zstyle ':vcs_info:git:*' unstagedstr '%F{yellow}M%f' # Unstaged changes
zstyle ':vcs_info:git:*' branchformat '%b' # Just the branch name
zstyle ':vcs_info:git:*' formats '%F{green}(%b)%f%u%c' # (branch)unstaged_changes_staged_changes
zstyle ':vcs_info:git:*' actionformats '%F{green}(%b|%a)%f%u%c' # (branch|action) for rebase/merge
zstyle ':vcs_info:git:*' post-arg "(%F{red}??%f)" # If untracked files are found

# 2. Add a hook to update vcs_info before each prompt populates the vcs_info_msg_0 variable
precmd_vcs_info() { vcs_info; } # This defines the function
autoload -Uz add-zsh-hook # This loads the add-zsh-hook utility (only needs to be called once)

add-zsh-hook precmd precmd_vcs_info # This correctly registers the function to the hook


# --- Custom Prompt Flag and Conditional Sourcing ---
# Set this flag to 'true' to enable the custom, emoji-switching prompt.
# Set it to 'false' (or comment out) to use the simple prompt defined below.
ENABLE_CUSTOM_PROMPT_EMOJIS=true

if [[ "$ENABLE_CUSTOM_PROMPT_EMOJIS" = true ]]; then
  # Source the external prompt configuration file.
  # We use ZDOTDIR or HOME to ensure it finds the file regardless of how Zsh is configured.
  source "${ZDOTDIR:-$HOME}/.zsh/prompt.zsh"
else
  # Fallback PROMPT if the custom emoji prompt is disabled.
  # This is your current simple prompt.
  PROMPT='%F{#21d1ff}%~%f${vcs_info_msg_0_}
%(?.%F{#e655b5}😺.%F{red}😿) %f'
fi

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
### End of Zinit's installer chunk
#
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Plugin history-search-multi-word loaded with investigating.
zinit load zdharma-continuum/history-search-multi-word

# Two regular plugins loaded without investigating.
#zinit light zdharma-continuum/fast-syntax-highlighting

# --- Fast Syntax Highlighting Configuration ---
# Reset default styles to remove potential underlines
# You'll need to re-add colors explicitly.
# A common pattern is to make 'region' (current typing area) italic.

# This is the key part for input highlighting
# Example: Make command (builtin, command, path) italic,
#           and the current region (what you're typing) italic gray
# You might find 'region' is the one causing the underline
# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets - makes it so ur getting ohmyzsh without the load via url
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Load completions (compinit should be after all plugins that add completions)
autoload -Uz compinit && compinit

# replay all cached completions
zinit cdreplay -q

# Declare the variable
#typeset -A ZSH_HIGHLIGHT_STYLES
#
## To differentiate aliases from other command types
#ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
#
## To have paths colored instead of underlined
##ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
#ZSH_HIGHLIGHT_STYLES[path]='none'
#
## To disable highlighting of globbing expressions
#ZSH_HIGHLIGHT_STYLES[globbing]='none'
#

# Enable vi mode
bindkey -v

# 2) (optional) show a visual cue in your prompt when you’re in NORMAL mode
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    RPS1="🅽 NORMAL"
  else
    RPS1=""
  fi
  zle reset-prompt
}
zle -N zle-keymap-select

# 3) ensure your right-prompt is enabled
setopt prompt_subst

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
alias vim='nvim'
alias vmod='nvim ~/.vimrc'
alias nvmod='nvim ~/.config/nvim/init.lua'
alias zmod='nvim ~/.zshrc'
alias kmod='nvim ~/.config/kitty/kitty.conf'
alias zsrc='source ~/.zshrc'
alias amod='nvim ~/.config/alacritty/alacritty.toml'
alias tmod='nvim ~/.config/tmux/tmux.conf'
alias imod='nvim ~/.config/i3/config'

alias f2c='xclip -sel c <'
alias packvc='apt-cache policy' #check version of package

#My bashrc aliases:

# pacman
alias up='sudo pacman -Syu'
alias upy='yay -Syu'
alias sync='sudo pacman -S'

alias grep='grep --color=auto'

# Modifying configs
alias bmod='nvim ~/.bashrc'
alias bsrc='source ~/.bashrc'
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

export LD_LIBRARY_PATH=~/.local/share/Steam/steamapps/common/SteamVR/bin/linux64:$LD_LIBRARY_PATH
#~/.steam/steam/steamapps/common/SteamVR/bin/linux64
