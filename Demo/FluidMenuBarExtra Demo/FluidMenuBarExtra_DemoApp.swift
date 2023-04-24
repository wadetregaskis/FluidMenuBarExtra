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

    var body: some Scene {
        Settings() {
            Form {
                DemoView(showMenuBarExtra: $showMenuBarExtra,
                         extraButtons: $extraButtons)
            }.fixedSize()
        }.windowResizability(.contentSize)

        FluidMenuBarExtra("Demo", systemImage: "chevron.down.circle", isInserted: $showMenuBarExtra) {
            /// IMPORTANT:  If you have dynamic content (as this example does, with bindings to state variables) you must define your view in a separate struct, not inline right here.  Otherwise any updates to your state variables won't be reflected in your views.  This appears to be a SwiftUI bug (or bizarre limitation).
            DemoView(showMenuBarExtra: $showMenuBarExtra,
                     extraButtons: $extraButtons)
        }
    }
}

fileprivate struct DemoView: View {
    @Binding var showMenuBarExtra: Bool
    @Binding var extraButtons: [Int]

    var body: some View {
        VStack {
            Text("Hello, world!")

            Divider()

            Toggle("Show menubar extra", isOn: $showMenuBarExtra)

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
