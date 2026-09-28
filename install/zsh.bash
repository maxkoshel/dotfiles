#!/usr/bin/env bash
# Installs zinit, symlinks zshrc, and switches the default shell to zsh.
# Works standalone or sourced from setup.bash (which sets dotfiles_dir).
dotfiles_dir="${dotfiles_dir:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

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

# Symlink the nvm default node into ~/.local/bin (no-op if nvm has no default yet)
"${dotfiles_dir}/install/nvm-default-link.bash" || echo "Skipping nvm default symlink (no nvm default alias yet)."
