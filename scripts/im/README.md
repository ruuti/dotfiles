# Interface Mode aka im

Automatically switch tmux, alacritty and nvim between light and dark mode based on system settings. `launchctl` runs notify.swift in the background and listens for changes in the system appearance. When the appearance changes, it sends a signal to the `im.sh` script which then switches the tmux, alacritty and nvim themes.

## Setup

```bash
sudo cp im.sh /usr/local/bin/im
```

```bash
sudo swiftc notify.swift -o /usr/local/bin/im-notify
```

```bash
cp com.ruuti.im-notify.plist ~/Library/LaunchAgents/com.ruuti.im-notify.plist
```

### Load and start the service

```bash
launchctl load ~/Library/LaunchAgents/com.ruuti.im-notify.plist
```
