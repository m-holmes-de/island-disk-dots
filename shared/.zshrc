##########################
# SOURCE HOMEBREW ON MAC #
##########################
if [[ -f "/opt/homebrew/bin/brew" ]] then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

###########################
# USE UWSM TO LAUNCH HYPR #
###########################
if [[ $(tty) == /dev/tty1 && -z $TMUX ]]; then
  if uwsm check may-start && uwsm select; then
    exec uwsm start default
  fi
fi

###########################
# GET YAZI TO CHANGE CWD  #
###########################

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}


###########################
# ZINIT STUFF #
###########################
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"


# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
# zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
# zinit snippet OMZP::docker

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

###########################
# SHELL GRAVY #
###########################

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# Keybindings
bindkey -e # ENABLE EMACS MDE
# bindkey -v # ENABLE VIM MODE
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey -s ^f "tmux-sessionizer\n"


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

# If fzf is installed
# Search command history with Ctrl+R
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
bindkey '^R' fzf-history-widget

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa --color=always --icons $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'exa --color=always --icons $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Set Starship Promt
eval "$(starship init zsh)"

###########################
# EXPORT AND SOURCE #
###########################

# bun completions
[ -s "/home/holmes/.bun/_bun" ] && source "/home/holmes/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# go
export "PATH=$PATH:$HOME/.local/opt/go/bin"
# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Source Cargo
export PATH="$PATH:$HOME/.cargo"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

# flow9
export PATH="$PATH:$HOME/Projects/flow9/bin"

###########################
# SOURCE SOME SAUCY STUFF #
###########################
source $HOME/.api/avante_anthropic_api

###########################
# ALIASES #
###########################
# Aliases
alias vim='nvim'
alias c='clear'
alias ls='eza --color=always --icons --long'
alias ll='eza --color=always --icons --long --all'
alias tree='eza --color=always --icons --long --all --tree --level=3'
# alias cat='bat'
alias os='fastfetch -c $HOME/.config/fastfetch/fastfetch.jsonc'
alias nvex='NVIM_APPNAME=nvex nvim'
alias nver='NVIM_APPNAME=nver nvim'
alias vscode-nvim='NVIM_APPNAME=vscode-nvim nvim'
alias dropped-config='nvex $HOME/.config/distros/arch-install.sh'
alias dropped-update='$HOME/.config/distros/arch/arch-install.sh'
alias zd='ZED_DEVICE_ID=0xa7a0 /home/holmes/.local/zed.app/bin/zed'
alias hyp='Hyprland'
