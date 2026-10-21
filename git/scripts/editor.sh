#!/bin/sh

if [ "${TERM_PROGRAM:-}" = "vscode" ]; then
  exec code --wait "$@"
fi

exec nano "$@"
