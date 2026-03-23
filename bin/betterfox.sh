#!/usr/bin/env bash
set -x

trash ~/Documents/projects/default/dotfiles/firefox/book* &>/dev/null
trash "$HOME/Downloads/user.js" &>/dev/null

dir=$(find ~/.mozilla/firefox -maxdepth 1 -type d \( -name '*.default-release' -o -name '*.default-esr' \) | head -n1)
[ -z "$dir" ] && { echo "No Firefox profile found"; exit 1; }

latest=$(find "$dir/bookmarkbackups" -type f -name '*.jsonlz4' -printf '%T@ %p\n' |
  sort -nr |
  awk 'NR==1 {print $2}')

cp -f "$latest" ~/Documents/projects/default/dotfiles/firefox/

if [[ "$dir" == *".default-esr" ]]; then
  out="$HOME/Documents/projects/default/dotfiles/firefox/userESR.js"
else
  out="$HOME/Documents/projects/default/dotfiles/firefox/user.js"
fi

curl -Lo "$HOME/Downloads/user.js" https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js

delta --side-by-side "$out" "$HOME/Downloads/user.js"
