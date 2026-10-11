# p10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# antidote
source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
antidote load


# === fzf-tab + completion settings ===
# Disable default completion menu (important for fzf-tab)
zstyle ':completion:*' menu no
# Show group descriptions
zstyle ':completion:*:descriptions' format '[%d]'
# Enable colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Case-insensitive matching and partial completion (e.g., for filenames)
zstyle ':completion:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
# No prefix in query fiels
zstyle ':fzf-tab:*' query-string ''
# === #

# Hide internal functions
zstyle ':completion:*:-command-:*:commands' ignored-patterns \
  'autocomplete:*' \
  'azhw:*' \
  'compfiles' \
  'functions' \
  'zle-*' \
  '_*'

# Optional nice previews
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always -la $realpath 2>/dev/null || ls -la $realpath'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word 2>/dev/null'

# Ctrl+Backspace bind to delete previous word
bindkey '^H' backward-kill-word

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh