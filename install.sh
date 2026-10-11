#!/bin/bash

# Ensure the script is running in bash
if [[ -z "$BASH_VERSION" ]]; then
    echo "Error: bash required" >&2
    exit 1
fi

set -euo pipefail

# Check previous installation
if [[ -f "$HOME/.zshrc" ]]; then
    echo "Error: .zshrc already exists"
    exit 1
fi

if [[ -f "$HOME/.zsh_plugins.txt" ]]; then
    echo "Error: .zsh_plugins.txt already exists"
    exit 1
fi

# Resolve the script directory path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! [[ -f "$SCRIPT_DIR/install.sh" ]];  then
    echo "Error: The script directory could not be determined correctly."
    exit 1
fi

# Check packages
PACKAGES=("zsh" "curl" "git")
REQUIRED_PKG=""

for pkg in "${PACKAGES[@]}"; do
    if ! command -v "$pkg" &> /dev/null; then
        REQUIRED_PKG="${REQUIRED_PKG} $pkg"
    fi
done

REQUIRED_PKG=$(echo "$REQUIRED_PKG" | xargs) # Trim leading/trailing whitespace

if [[ -n "$REQUIRED_PKG" ]]; then
    echo "Error: The following required packages are missing: $REQUIRED_PKG"
    echo "Please install them and try again."
    exit 1
fi


# Check and install fzf if needed
if [[ ! -d "$HOME/.fzf" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    bash $HOME/.fzf/install --bin
fi


# Install antidote
ANTIDOTE_DIR="$HOME/.antidote"
if [[ ! -d "$ANTIDOTE_DIR" ]]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
else
    echo "Antidote is already installed in $ANTIDOTE_DIR"
fi

# Copy base files
cp "$SCRIPT_DIR/.p10k.zsh" "$SCRIPT_DIR/.zshrc" "$SCRIPT_DIR/.zsh_plugins.txt" "$HOME/"

# Success
echo "Success. You can change default shell with:"
echo 'chsh -s "$(command -v zsh)" "$USER"'