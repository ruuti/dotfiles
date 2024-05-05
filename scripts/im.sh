#!/usr/bin/env bash

# Interface Mode controls alacritty and nvim dark/light mode either by using
# system setting or passed argument.
# 
# Usage:
# im [dark/light]

LIGHT_THEME="gruvbox_light"
DARK_THEME="gruvbox_dark"
ALACRITTY_CONF="$HOME/.config/alacritty/alacritty.toml"
VIMCONF="$HOME/.config/nvim/init.lua"

# if the first arg light/dark use that, otherwise read system setting
MODE=$(defaults read NSGlobalDomain AppleInterfaceStyle || echo Light)

if [[ -n "$1" ]] && ([[ "$1" = "dark" ]] || [[ "$1" = "light" ]])
then
  MODE=$1
fi

# mode to lowercase
MODE=$(echo "$MODE" | awk '{print tolower($0)}')

echo "setting $MODE mode"

# overwrite mode settings in configs
if [[ "$MODE" = "dark" ]]; then
  sed -i.imbak "s/${LIGHT_THEME}/${DARK_THEME}/" $ALACRITTY_CONF
  sed -i.imbak 's/background=light/background=dark/' "$VIMCONF"
else
  sed -i.imbak "s/${DARK_THEME}/${LIGHT_THEME}/" $ALACRITTY_CONF
  sed -i.imbak 's/background=dark/background=light/' "$VIMCONF"
fi

# if (n)vim running in tmux, set background
tmux list-panes -a -F '#{pane_id} #{pane_current_command}' |
  grep vim |
  cut -d ' ' -f 1 |
  xargs -I PANE tmux send-keys -t PANE ESCAPE \
    ":set background=${MODE}" ENTER
