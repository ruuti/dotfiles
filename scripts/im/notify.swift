#!/usr/bin/env swift

// Compile with:
// swiftc notify.swift -o /usr/local/bin/im-notify
// Most credit goes to https://github.com/mnewt/dotemacs/blob/master/bin/dark-mode-notifier.swift

// Usage: ./notify.swift bash -c im
import Cocoa

@discardableResult
func shell(_ args: [String]) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.standardError = FileHandle.standardError
    task.standardOutput = FileHandle.standardOutput
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

let args = Array(CommandLine.arguments.suffix(from: 1))
shell(args)

DistributedNotificationCenter.default.addObserver(
    forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
    object: nil,
    queue: nil) { (notification) in
        shell(args)
}

NSApplication.shared.run()
