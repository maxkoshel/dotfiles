echo "==> Loading .zshrc"

ZSH_CACHE=~/.zsh_cache
mkdir -p ${ZSH_CACHE}
chmod 700 ${ZSH_CACHE}

# see man zshbuiltins
autoload -U compinit && compinit -d "$ZSH_CACHE/zcompdump"

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

export NODE_PATH=`which node`
export PATH="${HOME}/bin:./node_modules/.bin:$PATH"
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

[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh
export NVM_DIR="${HOME}/.nvm"
export NVM_LAZY_LOAD=true
# export NVM_DIR="${XDG_CONFIG_HOME/:-$HOME/.}nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export ANTIGEN_COMPDUMP="${ZSH_CACHE}/antigen_compdump"

source $(brew --prefix)/share/antigen/antigen.zsh
antigen init "${dotfiles_dir}/antigenrc"

HYPHEN_INSENSITIVE="true"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

source "${dotfiles_dir}/aliases.zsh"

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

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


export YVM_DIR=/Users/$(whoami)/.yvm
[ -r $YVM_DIR/yvm.sh ] && source $YVM_DIR/yvm.sh
if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi
export PATH="/usr/local/opt/helm@3/bin:$PATH"
