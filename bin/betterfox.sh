#!/usr/bin/env bash

trash ~/Documents/projects/default/dotfiles/firefox/book* &>/dev/null
trash "$HOME/Downloads/user.js" &>/dev/null
trash "$HOME/Downloads/userMY.js" &>/dev/null

latest=$(find ~/.mozilla/firefox/*.default-release/bookmarkbackups -type f -name '*.jsonlz4' -printf '%T@ %p\n' |
  sort -nr |
  awk 'NR==1 {print substr($0, index($0,$2))}')
cp -f "$latest" ~/Documents/projects/default/dotfiles/firefox/

curl -Lo "$HOME/Downloads/user.js" https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js
delta --side-by-side "$HOME/Documents/projects/default/dotfiles/firefox/user.js" "$HOME/Downloads/user.js"
