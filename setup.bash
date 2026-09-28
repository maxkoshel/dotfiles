#!/usr/bin/env bash

set -e

dotfiles_dir=`cd "$(dirname "$0")" && pwd`
extra_file="${HOME}/.extra"
install_dir="${dotfiles_dir}/install"

echo "Home directory is ${HOME}"
echo "Dotfiles directory is ${dotfiles_dir}"

rm -f ${extra_file}

if [[ $OSTYPE =~ darwin ]]; then
    source "${install_dir}/homebrew.bash"
fi

source "${install_dir}/symlinks.bash"
source "${install_dir}/git.bash"
source "${install_dir}/zsh.bash"

echo "Done. Please restart your terminal for changes to take effect."

