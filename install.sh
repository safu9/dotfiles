#!/bin/sh

echo "Installing dotfiles..."

DOTPATH="$HOME/dotfiles"

cd $DOTPATH
for file in .??*; do
    [ "$file" = ".editorconfig" ] && continue
    [ "$file" = ".env" ] && continue
    [ "$file" = ".env.sample" ] && continue
    [ "$file" = ".git" ] && continue
    [ "$file" = ".gitignore" ] && continue

    if [ -L "$HOME/$file" ]; then
        ln -snfv "$DOTPATH/$file" "$HOME/$file"
    else
        # if file already exists, save backup.
        ln -snfbv "$DOTPATH/$file" "$HOME/$file"
    fi
done

echo "Complete!"
