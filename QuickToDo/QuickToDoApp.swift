//
//  QuickToDoApp.swift
//  QuickToDo
//
//  Created by mery Rahou on 27/4/2025.
//

import SwiftUI

@main
struct QuickToDoApp: App {
    var body: some Scene {
        MenuBarExtra("QuickToDo", systemImage: "checklist") {
            ContentView()
                .frame(width: 400, height: 600)
        }
        .menuBarExtraStyle(.window)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ notification: Notification) {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 600)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView())

        
        // Customize the popover appearance further
        if let contentView = popover.contentViewController?.view {
            contentView.wantsLayer = true
            contentView.layer?.cornerRadius = 12  // Rounded corners for the popover content
        }
        
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "checklist", accessibilityDescription: "QuickToDo")
            button.action = #selector(togglePopover(_:))
        }
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
