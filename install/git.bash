#!/usr/bin/env bash
# Optionally configures git user.name/user.email/GitHub host.
# Expects: dotfiles_dir, extra_file

read -p "Configure git (name, e-mail, GitHub host)? [y/N]: " CONFIGURE_GIT
if [[ "${CONFIGURE_GIT}" =~ ^[Yy]$ ]]; then
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
else
    echo "Skipping git configuration."
fi
