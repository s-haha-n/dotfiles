#!/usr/bin/zsh

export PATH="$PATH:/home/haha/.local/bin"
# cuda nvidia-utils still not working?
export PATH=/opt/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/opt/cuda/lib64
export LD_LIBRARY_PATH=~/.local/share/Steam/steamapps/common/SteamVR/bin/linux64:$LD_LIBRARY_PATH
#~/.steam/steam/steamapps/common/SteamVR/bin/linux64

alias unreal='HOME="$HOME/Documents/unreal_sandbox" "$HOME/Documents/Linux_Unreal_Engine_5.5.4/Engine/Binaries/Linux/UnrealEditor"'


export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export KEYTIMEOUT=1

# Shell integrations
eval "$(zoxide init bash)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(dircolors -b ~/.dircolors)"

#aliases vars
alias ls='ls --color=auto'
alias ll='ls -al --color'
alias l='ls -1 --color'
alias lr='ls -1t --color'
alias c='clear'
alias v='nvim'
alias vim='nvim'

alias zmod='nvim ~/.zshrc'
alias zsrc='source ~/.zshrc'
alias vmod='nvim ~/.config/nvim/init.lua'
alias kmod='nvim ~/.config/kitty/kitty.conf'
alias amod='nvim ~/.config/alacritty/alacritty.toml'
alias tmod='nvim ~/.config/tmux/tmux.conf'
alias imod='nvim ~/.config/i3/config'
alias omod='nvim ~/.config/openbox/rc.xml'
alias osrc='openbox --restart'
alias rmod='nvim ~/.config/rofi/config.rasi'
alias bmod='nvim ~/.bashrc'
alias bsrc='source ~/.bashrc'

alias up='sudo pacman -Syu'
alias upy='yay -Syu'

#switch audio
alias s1='pactl set-card-profile alsa_card.pci-0000_07_00.1 output:hdmi-stereo'
alias s2='pactl set-card-profile alsa_card.pci-0000_07_00.1 output:hdmi-stereo-extra1'

# load modules
zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors # Keep this early, it's needed for prompt colors

# cmp opts
zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=3\;59 # colorize cmp menu
#zstyle ':completion:*' special-dirs true # force . and .. to show in cmp menu
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu
#zstyle ':completion:*:matches' list-colors 'ma=none'
#zstyle ':completion:*' list-colors 'di=34' 'fi=0' 'hl=1;36'
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} 'hl=1;36'
#zstyle ':completion:*' file-list true # more detailed list
zstyle ':completion:*' squeeze-slashes false # explicit disable to allow /*/ expansion
#zle_highlight=('suffix:fg=blue,bold' 'isearch:fg=green,italics')

#~~original ones: 
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  #makes it not case sensitive autocompl
#zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
## disable the default zshell completion menu use fzf
#zstyle ':completion:*' menu no
## gives nice preview of dir with cd autocompl
##zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
#zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# main opts
setopt append_history inc_append_history share_history # better history
# on exit, history appends rather than overwrites; history is appended as soon as cmds executed; history shared across sessions
setopt auto_menu menu_complete # autocmp first menu match
setopt autocd # type a dir to cd
setopt auto_param_slash # when a dir is completed, add a / instead of a trailing space
setopt no_case_glob no_case_match # make cmp case insensitive
setopt globdots # include dotfiles
setopt extended_glob # match ~ # ^
setopt interactive_comments # allow comments in shell
unsetopt prompt_sp # don't autoclean blanklines
setopt prompt_subst # right-prompt is enabled
stty stop undef # disable accidental ctrl s

# history opts
HISTSIZE=1000000
SAVEHIST=1000000

#HISTFILE="$XDG_CACHE_HOME/zsh_history" # move histfile to cache
HISTFILE=~/.zsh_history

HISTCONTROL=ignoreboth # consecutive duplicates & commands starting with space are not saved
#~~original ones: 
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# fzf setup
source <(fzf --zsh) # allow for fzf history widget

# replay all cached completions
#zinit cdreplay -q

# binds
bindkey -v   # Enable vi mode
bindkey -M menuselect '^M' .accept-line # Enter compl exec immediately
bindkey '^r' fzf-history-widget

#bindkey "^h" backward-kill-word
#bindkey '^w' kill-region
bindkey "^w" backward-kill-word
bindkey "^j" backward-word
bindkey "^k" kill-line
bindkey "^l" forward-word

bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^k" forward-word
# ctrl J & K for going up and down in prev commands
bindkey "^J" history-search-forward
bindkey "^K" history-search-backward
bindkey "^[[Z" reverse-menu-complete

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

# Source your Vim mode indicator script
source "${ZDOTDIR:-$HOME}/.zsh/mode.zsh"

# 2. Add a hook to update vcs_info before each prompt populates the vcs_info_msg_0 variable
precmd_vcs_info() { vcs_info; } # This defines the function
autoload -Uz add-zsh-hook # This loads the add-zsh-hook utility (only needs to be called once)

add-zsh-hook precmd precmd_vcs_info # This correctly registers the function to the hook

ENABLE_CUSTOM_PROMPT_EMOJIS=true

if [[ "$ENABLE_CUSTOM_PROMPT_EMOJIS" = true ]]; then
  # Source the external prompt configuration file.
  # We use ZDOTDIR or HOME to ensure it finds the file regardless of how Zsh is configured.
  source "${ZDOTDIR:-$HOME}/.zsh/prompt.zsh"
else
  # Fallback PROMPT if the custom emoji prompt is disabled.
  # This is your current simple prompt.
  PROMPT='%F{#7DFFFF}%~%f${vcs_info_msg_0_}
%(?.%F{#e655b5}😺.%F{red}😿) %f'
fi

# Installed plugins
source /home/haha/.local/share/zinit/plugins/zsh-users---zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Ensure ZSH_HIGHLIGHT_STYLES is an associative array
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='fg=#d1ff87'

set +o list_types  	# remove '/' dirnames in autocmp
