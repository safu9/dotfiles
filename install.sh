#!/bin/sh

echo "Installing dotfiles..."

SRC="$HOME/dotfiles/src"

cd $SRC
for file in .??*; do
    if [ -L "$HOME/$file" ]; then
        ln -s -n -f -v "$SRC/$file" "$HOME/$file"
    else
        # if file already exists, save backup.
        ln -s -n -f -i -v "$SRC/$file" "$HOME/$file"
    fi
done

echo "Complete!"
