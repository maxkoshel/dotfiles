#!/usr/bin/env bash
# Installs zinit, symlinks zshrc, and switches the default shell to zsh.
# Expects: dotfiles_dir

echo "Setting up zinit..."
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

echo "Symlinking zsh configs..."
ln -sf "${dotfiles_dir}/zshrc" "${HOME}/.zshrc"

# Change shell to zsh
chsh -s /bin/zsh
