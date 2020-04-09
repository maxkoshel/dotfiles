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

### Import

```bash
cp ~/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User
```

### Export

```bash
cp ~/Library/Application\ Support/Code/User/settings.json ~/dotfiles/vscode/settings.json
```

## Syncing editor keybindings

### Import

```bash
cp ~/dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User
```

### Export

```bash
cp ~/Library/Application\ Support/Code/User/keybindings.json ~/dotfiles/vscode/keybindings.json
```
