# Enable zsh profiling (run `zprof` in a shell to view results)
zmodload zsh/zprof

# Fast path for automation shells (opt-in via env)
# Relies on ~/.local/bin/node (see install/nvm-default-link.bash) instead of
# globbing $NVM_DIR on every shell start.
if [[ "$COPILOT_FAST_SHELL" == "1" ]] || [[ -n "$CLAUDE_CODE" ]]; then
  export NVM_DIR="${HOME}/.nvm"
  export PATH="${HOME}/.local/bin:$PATH"
  return
fi

ZSH_CACHE=~/.zsh_cache
mkdir -p ${ZSH_CACHE}
chmod 700 ${ZSH_CACHE}

# Optimize completion loading
autoload -Uz compinit

if [[ -n ${ZSH_CACHE}/zcompdump(#qN.mh+24) ]]; then
  compinit -d "${ZSH_CACHE}/zcompdump"
else
  compinit -C -d "${ZSH_CACHE}/zcompdump"
fi

# see man zshoptions

# If a completion is performed with the cursor within a word, and a full
# completion is inserted, the cursor is moved to the end of the word. That is,
# the cursor is moved to the end of the word if either a single match is
# inserted or menu completion is performed.
setopt alwaystoend

# (-J) If a command is issued that can't be executed as a normal command, and
# the command is the name of a directory, perform the cd command to that
# directory.
setopt autocd

# (-N) Make cd push the old directory onto the directory stack.
setopt autopushd

# If unset, the cursor is set to the end of the word if completion is started.
# Otherwise it stays there and completion is done from both ends.
setopt completeinword

# (-0) Try to correct the spelling of commands.
setopt correct

# Save each command's beginning timestamp (in seconds since the epoch) and the
# duration (in seconds) to the history file.
setopt extendedhistory

# If a new command line being added to the history list duplicates an older one,
# the older command is removed from the list (even if it is not the previous
# event).
setopt histignorealldups

# Remove command lines from the history list when the first character on the
# line is a space, or when one of the expanded aliases contains a leading space
setopt histignorespace

# Try to make the completion list smaller (occupying less lines) by printing the
# matches in columns with different widths
setopt listpacked

# When listing files that are possible completions, show the type of each file
# with a trailing identifying mark.
setopt listtypes

# Beep on error in ZLE.
setopt nobeep

# Make globbing (filename generation) sensitive to case.
setopt nocaseglob

# Allows '>' redirection to truncate existing files, and '>>' to create files.
# Otherwise '>!' or '>|' must be used to truncate a file, and '>>!' or '>>|' to
# create a file.
setopt noclobber

# Do not require a leading '.' in a filename to be matched explicitly.
setopt globdots

# If a pattern for filename generation has no matches, delete the pattern from
# the argument list instead of reporting an error.
setopt nullglob

# see http://zsh.sourceforge.net/Doc/Release/Completion-System.html
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*' verbose yes

# Enable approximate completions
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3)) numeric)'

# Group results by category
zstyle ':completion:*' group-name ''

# Show message while waiting for completion
zstyle ':completion:*' show-completer true

# Nicer format for completion messages
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:corrections' format '%U%F{green}%d (errors: %e)%f%u'
zstyle ':completion:*:warnings' format '%F{202}%BSorry, no matches for: %F{214}%d%b'

dotfiles_dir="${HOME}/dotfiles"

extra_path="${HOME}/.extra"
[ -r ${extra_path} ] && [ -f ${extra_path} ] && source ${extra_path}

#if [[ `gpgconf hub` != '' ]]; then
#  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#  export GPG_TTY=$(tty)
#  gpg-connect-agent /bye
#fi

# Optimize PATH
typeset -U path
path=(
  ${HOME}/bin
  ./node_modules/.bin
  $path
)
export ZSH_HIGHLIGHT_MAXLENGTH=300

export EDITOR="code --wait"
export PAGER=less
# i=--ignore-case
# F=--quit-if-one-screen
# R=--RAW-CONTROL-CHARS
# X=--no-init
# x=--tabs=4
export LESS=iFRXx4

# see https://github.com/sharkdp/bat#output-style
export BAT_STYLE="changes,header,numbers"

# NVM configuration with lazy loading
export NVM_DIR="${HOME}/.nvm"
export NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('npm' 'node' 'nvm' 'yarn' 'npx')
# Skip nvm's auto-use-default-version on source (~2s of fs walking).
# ~/.local/bin/node (symlinked below) already covers the default node bin.
export NVM_NO_USE=true
# NOTE: NVM_AUTO_USE=true forces nvm.sh to load eagerly on every shell start
# (it has to read .nvmrc), which defeats lazy loading. Run `nvm use` manually
# in projects that need a specific node version.

# nvm default node is symlinked into ~/.local/bin by install/nvm-default-link.bash
# (already on $PATH below), so no nvm runtime or $NVM_DIR globbing is needed here.
# Run `nvm-relink-default` after `nvm install`/`nvm alias default` to refresh it.

# Initialize zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# Load core plugins with turbo mode (parallel loading)
zinit wait lucid for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

# Load oh-my-zsh plugins and libs
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::colored-man-pages

# Pure theme
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# Essential tools with turbo mode
zinit wait lucid for \
  MichaelAquilina/zsh-you-should-use \
  changyuheng/zsh-interactive-cd

# NVM plugin with lazy loading
zinit ice wait lucid
zinit light lukechilds/zsh-nvm

HYPHEN_INSENSITIVE="true"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

source "${dotfiles_dir}/aliases.zsh"

# Lazy load fzf
fzf_load() {
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_DEFAULT_OPTS='--height 75% --multi'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :200 {}'"
  export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -100'"

  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }

  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }

  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

_fzf_lazy_init() {
  # Remove lazy wrappers first to avoid recursive calls.
  unfunction fzf __fsel _fzf_lazy_init 2>/dev/null
  fzf_load
}

fzf() {
  _fzf_lazy_init
  fzf "$@"
}

__fsel() {
  _fzf_lazy_init
  __fsel "$@"
}

# Defer iTerm2 + YVM until after the first prompt
_dotfiles_defer_late_init() {
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
  export YVM_DIR="${HOME}/.yvm"
  [ -r "$YVM_DIR/yvm.sh" ] && source "$YVM_DIR/yvm.sh"
  add-zsh-hook -d precmd _dotfiles_defer_late_init
  unfunction _dotfiles_defer_late_init
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _dotfiles_defer_late_init

# Lazy load kubectl completion
if [ -f /usr/local/bin/kubectl ]; then
  kubectl() {
    unfunction "$0"
    source <(kubectl completion zsh)
    $0 "$@"
  }
fi
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin/env:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"

# Lazy load pyenv
pyenv() {
  unset -f pyenv
  export PATH="${PYENV_ROOT}/shims:${PATH}"
  eval "$(command pyenv init -)"
  eval "$(command pyenv init --path)"
  pyenv "$@"
}

# Show profiling output automatically when ZSH_PROFILE_RC=1 is set
[[ -n "$ZSH_PROFILE_RC" ]] && zprof

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Initialize zoxide for smarter cd (must be at the end)
eval "$(zoxide init zsh)"
