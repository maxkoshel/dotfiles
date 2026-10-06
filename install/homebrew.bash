#!/usr/bin/env bash
# Installs/updates Homebrew and runs the required + optional Brewfiles.
# Expects: dotfiles_dir

echo "macOS detected"
if [ -z "`which brew`" ]; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed"
fi

echo "Updating Homebrew..."
brew update
brew upgrade
brew doctor || true

echo "Updating brew bundles..."
brew bundle --file="${dotfiles_dir}/Brewfile" || echo "Warning: some packages from Brewfile failed to install, continuing..."

optional_brewfile="${dotfiles_dir}/Brewfile.optional"
if [ -f "${optional_brewfile}" ]; then
    optional_entries=()
    while IFS= read -r line; do
        optional_entries+=("$line")
    done < <(grep -E '^[[:space:]]*(brew|cask|mas)[[:space:]]' "${optional_brewfile}")

    if [ ${#optional_entries[@]} -gt 0 ]; then
        echo ""
        echo "Optional applications available:"
        for i in "${!optional_entries[@]}"; do
            printf "  %d) %s\n" "$((i + 1))" "${optional_entries[$i]}"
        done
        read -p "Enter numbers to install (space-separated), 'all', or press Enter to skip: " optional_choice

        if [ -n "${optional_choice}" ]; then
            optional_tmp="$(mktemp)"
            if [ "${optional_choice}" = "all" ]; then
                printf "%s\n" "${optional_entries[@]}" > "${optional_tmp}"
            else
                for num in ${optional_choice}; do
                    idx=$((num - 1))
                    if [ -n "${optional_entries[$idx]:-}" ]; then
                        echo "${optional_entries[$idx]}" >> "${optional_tmp}"
                    fi
                done
            fi
            echo "Installing selected optional applications..."
            brew bundle --file="${optional_tmp}" || echo "Warning: some optional packages failed to install, continuing..."
            rm -f "${optional_tmp}"
        fi
    fi
fi

brew tap domt4/autoupdate
brew trust --command domt4/autoupdate/autoupdate
brew autoupdate start 12h --upgrade --cleanup

# Install Python tools
if command -v pip3 &> /dev/null; then
    pip3 install --user howdoi --upgrade
else
    echo "pip3 not found, skipping Python tools installation"
fi
