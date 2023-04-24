//
//  main.swift
//  Demo
//
//  Created by Wade Tregaskis on 23/4/2023.
//  Copyright © 2023 Wade Tregaskis.
//

import SwiftUI
import FluidMenuBarExtra

@main
private struct DemoApp: App {
    @AppStorage("showMenuBarExtra") var showMenuBarExtra = true

    var body: some Scene {
        // Note that if you're running this demo from Xcode, this settings window may not be immediately visible as it may be hidden by Xcode's windows.
        Window("Settings", id: "Settings") {
            Form {
                Toggle("Show menubar extra", isOn: $showMenuBarExtra)
            }.padding(20)
                .fixedSize()
        }.windowResizability(.contentSize)

        FluidMenuBarExtra("Demo", systemImage: "chevron.down.circle", isInserted: $showMenuBarExtra) {
            Text("Hello, world!")
                .padding(20)
        }
    }
}
