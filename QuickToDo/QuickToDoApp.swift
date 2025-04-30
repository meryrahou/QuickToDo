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


struct VisualEffectBackground: NSViewRepresentable {
    var material: NSVisualEffectView.Material = .popover
    var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow
    var state: NSVisualEffectView.State = .active

    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.material = material
        effectView.blendingMode = blendingMode
        effectView.state = state
        return effectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.state = state
    }
}
