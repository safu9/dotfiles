#!/bin/sh

echo "Installing dotfiles..."

SRC="$HOME/dotfiles/src"

cd $SRC
for file in .??*; do
    if [ -L "$HOME/$file" ]; then
        ln -snfv "$SRC/$file" "$HOME/$file"
    else
        # if file already exists, save backup.
        ln -snfbv "$SRC/$file" "$HOME/$file"
    fi
done

echo "Complete!"
