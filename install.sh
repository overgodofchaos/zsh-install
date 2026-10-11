#!/bin/bash

# Ensure the script is running in bash
if [[ -z "$BASH_VERSION" ]]; then
    echo "ERROR: bash required" >&2
    exit 1
fi

set -euo pipefail

# Check the environment
if command -v apt-get &> /dev/null; then
    PM="apt"
else
    echo "Only apt-get is supported"
    exit 1
fi

SUDO="false"
if [[ $EUID -eq 0 ]]; then
    SUDO="root"
elif command -v sudo &> /dev/null; then
    SUDO="true"
fi

# Check previous installation
if [[ -f "$HOME/.zshrc" ]]; then
    echo ".zshrc already exists"
    exit 1
fi

if [[ -f "$HOME/.zsh_plugins.txt" ]]; then
    echo ".zsh_plugins.txt already exists"
    exit 1
fi

# Resolve the script directory path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! [[ -f "$SCRIPT_DIR/install.sh" ]];  then
    echo "The script directory could not be determined correctly."
    exit 1
fi


# Install packages
if [[ "$SUDO" == "true" ]]; then
    sudo apt-get update
    sudo apt-get install -y zsh git curl fzf
elif [[ "$SUDO" == "root" ]]; then
    apt-get update
    apt-get install -y zsh git curl fzf
else
    su - -c 'apt-get update && apt-get install -y zsh git curl fzf'
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