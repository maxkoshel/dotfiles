#!/usr/bin/env bash
# Symlinks shell config files into $HOME.
# Expects: dotfiles_dir

echo "Symlinking configs..."
for file in profile inputrc; do
    ln -sf "${dotfiles_dir}/${file}" "${HOME}/.${file}"
done
unset file
