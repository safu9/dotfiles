#!/bin/zsh

if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update

brew install git
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
