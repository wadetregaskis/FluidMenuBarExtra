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
private struct FluidMenuBarExtra_DemoApp: App {
    @AppStorage("showMenuBarExtra") var showMenuBarExtra = true
    @State var extraButtons = [0, 1]
    @State var animation = NSWindow.AnimationBehavior.none
    @State var alignRight = false
    @State var useContextualMenu = true

    var menu = NSMenu(title: "Moar pop-ups!")
    var liveMenuItem = NSMenuItem()

    init() {
        menu.addItem(withTitle: "Easter egg!", action: nil, keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(liveMenuItem)
    }

    var body: some Scene {
        let _ = liveMenuItem.title = "There \(1 != extraButtons.count ? "are" : "is") \(extraButtons.count) extra button\(1 != extraButtons.count ? "s" : "")"

        Settings() {
            Form {
                DemoView(showMenuBarExtra: $showMenuBarExtra,
                         useContextualMenu: $useContextualMenu,
                         extraButtons: $extraButtons,
                         animation: $animation,
                         alignRight: $alignRight)
            }.fixedSize()
        }.windowResizability(.contentSize)

        FluidMenuBarExtra("Demo",
                          systemImage: "chevron.down.circle",
                          isInserted: $showMenuBarExtra,
                          animation: animation,
                          menu: (useContextualMenu ? menu : nil),
                          alignRight: alignRight) {
            /// IMPORTANT:  If you have dynamic content (as this example does, with bindings to state variables) you must define your view in a separate struct, not inline right here.  Otherwise any updates to your state variables won't be reflected in your views.  This appears to be a SwiftUI bug (or bizarre limitation).
            DemoView(showMenuBarExtra: $showMenuBarExtra,
                     useContextualMenu: $useContextualMenu,
                     extraButtons: $extraButtons,
                     animation: $animation,
                     alignRight: $alignRight)
        }
    }
}

fileprivate struct DemoView: View {
    @Binding var showMenuBarExtra: Bool
    @Binding var useContextualMenu: Bool
    @Binding var extraButtons: [Int]
    @Binding var animation: NSWindow.AnimationBehavior
    @Binding var alignRight: Bool

    var body: some View {
        VStack {
            Text("Hello, world!")

            Divider()

            Toggle("Show menubar extra", isOn: $showMenuBarExtra)
            Toggle("Use contextual menu", isOn: $useContextualMenu)
            Toggle("Align right", isOn: $alignRight)

            Picker("Animation", selection: $animation) {
                Text("None").tag(NSWindow.AnimationBehavior.none)
                Text("Alert panel").tag(NSWindow.AnimationBehavior.alertPanel)
                Text("Document window").tag(NSWindow.AnimationBehavior.documentWindow)
                Text("Utility window").tag(NSWindow.AnimationBehavior.utilityWindow)
            }

            Divider()

            Button("Moar buttons!") {
                extraButtons.append(extraButtons.count)
            }

            ForEach($extraButtons, id: \.self) { $button in
                Button("No more buttons!") {
                    extraButtons.removeLast()
                }
            }
        }.padding(10)
    }
}
