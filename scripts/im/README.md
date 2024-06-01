# Interface Mode aka im

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
