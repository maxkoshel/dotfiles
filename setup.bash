#!/usr/bin/env bash

set -e

dotfiles_dir=`cd "$(dirname "$0")" && pwd`
extra_file="${HOME}/.extra"

echo "Home directory is ${HOME}"
echo "Dotfiles directory is ${dotfiles_dir}"

rm -f ${extra_file}

if [[ $OSTYPE =~ darwin ]]; then
    echo "macOS detected"
    if [ -z "`which brew`" ]; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is already installed"
    fi

    echo "Updating brew bundles..."
    brew bundle --file="${dotfiles_dir}/Brewfile"

    # Install Python tools
    if command -v pip3 &> /dev/null; then
        pip3 install --user howdoi --upgrade
    else
        echo "pip3 not found, skipping Python tools installation"
    fi
fi

echo "Symlinking configs..."
for file in profile inputrc; do
    ln -sf "${dotfiles_dir}/${file}" "${HOME}/.${file}"
done
unset file

CURRENT_GIT_USER=`git config --global --get user.name || echo`
CURRENT_GIT_EMAIL=`git config --global --get user.email || echo`
CURRENT_GH_HOST=${GITHUB_HOST:-github.com}

echo "Configuring git..."
read -p "Enter your full name ($CURRENT_GIT_USER): " GIT_USER
read -p "Enter your e-mail ($CURRENT_GIT_EMAIL): " GIT_EMAIL
read -p "Enter your GitHub host ($CURRENT_GH_HOST): " GH_HOST

GIT_USER=${GIT_USER:-$CURRENT_GIT_USER}
GIT_EMAIL=${GIT_EMAIL:-$CURRENT_GIT_EMAIL}
GH_HOST=${GH_HOST:-$CURRENT_GH_HOST}

cp -f "${dotfiles_dir}/gitconfig.template" "${HOME}/.gitconfig"

git config --global user.name "${GIT_USER}"
git config --global user.email "${GIT_EMAIL}"

git config --global core.excludesfile "${dotfiles_dir}/global.gitignore"

cat >>${extra_file} <<EOL
export GITHUB_HOST="${GH_HOST}"
EOL

# Install zinit if not installed
echo "Setting up zinit..."
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Create symbolic links for zsh configuration
echo "Symlinking zsh configs..."
ln -sf "${dotfiles_dir}/zshrc" "${HOME}/.zshrc"

# Change shell to zsh
chsh -s /bin/zsh

echo "Done. Please restart your terminal for changes to take effect."
