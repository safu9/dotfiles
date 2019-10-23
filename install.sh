#!/bin/sh

echo "Installing dotfiles..."

DOTPATH="$HOME/dotfiles"

cd $DOTPATH
for file in .??*; do
    [ "$file" = ".git" ] && continue
    [ "$file" = ".gitignore" ] && continue
    [ "$file" = ".env" ] && continue

    if [ -L "$HOME/$file" ]; then
        ln -snfv "$DOTPATH/$file" "$HOME/$file"
    else
        # if file already exists, save backup.
        ln -snfbv "$DOTPATH/$file" "$HOME/$file"
    fi
done

echo "Complete!"
