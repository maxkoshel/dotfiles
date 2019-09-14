# VSCode settings

## Syncing installed extensions

### Import

```bash
cat ~/dotfiles/vscode/extensions.txt | xargs -L 1 code --install-extension
```

### Export

```bash
code --list-extensions >| ~/dotfiles/vscode/extensions.txt
```

## Syncing editor settings

```bash
cp ~/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User
```

## Syncing editor keybindings

```bash
cp ~/dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User
```
