#!/usr/bin/env bash
# Symlinks node/npm/npx/corepack from the nvm default alias into ~/.local/bin
# so shells and GUI apps can find them without loading nvm or globbing $NVM_DIR.
# Re-run after `nvm install` or `nvm alias default <version>`.
set -euo pipefail

NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
target_dir="${HOME}/.local/bin"

alias_name=$(cat "${NVM_DIR}/alias/default" 2>/dev/null) || {
    echo "No nvm default alias set (${NVM_DIR}/alias/default not found)." >&2
    exit 1
}
while [[ -f "${NVM_DIR}/alias/${alias_name}" ]]; do
    alias_name=$(cat "${NVM_DIR}/alias/${alias_name}")
done

bin_dir=$(ls -d "${NVM_DIR}/versions/node/v${alias_name}"*/bin 2>/dev/null | sort -V | tail -1)
if [[ -z "${bin_dir}" ]]; then
    echo "Could not find an installed node matching '${alias_name}' in ${NVM_DIR}/versions/node." >&2
    exit 1
fi

mkdir -p "${target_dir}"
for bin in node npm npx corepack; do
    [[ -x "${bin_dir}/${bin}" ]] && ln -sf "${bin_dir}/${bin}" "${target_dir}/${bin}"
done

echo "Linked nvm default ($("${bin_dir}/node" --version)) from ${bin_dir} into ${target_dir}"
