//
//  FluidMenuBarExtra.swift
//  FluidMenuBarExtra
//
//  Created by Lukas Romsicki on 2022-12-17.
//  Copyright © 2022 Lukas Romsicki.
//

import SwiftUI

/// A class you use to create a SwiftUI menu bar extra in both SwiftUI and non-SwiftUI
/// applications.
///
/// A fluid menu bar extra is configured by initializing it once during the lifecycle of your
/// app, most commonly in your application delegate. In SwiftUI apps, use
/// `NSApplicationDelegateAdaptor` to create an application delegate in which
/// a ``FluidMenuBarExtra`` can be created:
///
/// ```swift
/// class AppDelegate: NSObject, NSApplicationDelegate {
///     private var menuBarExtra: FluidMenuBarExtra?
///
///     func applicationDidFinishLaunching(_ notification: Notification) {
///         menuBarExtra = FluidMenuBarExtra(title: "My Menu", systemImage: "cloud.fill") {
///             Text("My SwiftUI View")
///         }
///     }
/// }
/// ```
///
/// Because an application delegate is a plain object, not a `View` or `Scene`, you
/// can't pass state properties to views in the closure of `FluidMenuBarExtra` directly.
/// Instead, define state properties inside child views, or pass published properties from
/// your application delegate to the child views using the `environmentObject`
/// modifier.
public struct FluidMenuBarExtra<Content: View>: Scene {
    @StateObject private var state = FluidMenuBarExtraStatusItemWrapper<Content>()
    @Binding private var isInserted: Bool

    private let title: String
    private let image: FluidMenuBarExtraStatusItem.Image
    private let animation: NSWindow.AnimationBehavior
    private let menu: NSMenu?
    private let alignRight: Bool
    private let content: () -> Content

    private init(_ title: String,
                image: FluidMenuBarExtraStatusItem.Image,
                isInserted foo: Binding<Bool> = .constant(true),
                animation: NSWindow.AnimationBehavior = .none,
                menu: NSMenu? = nil,
                alignRight: Bool = false,
                @ViewBuilder content: @escaping () -> Content) {
        self._isInserted = foo

        self.title = title
        self.image = image
        self.animation = animation
        self.menu = menu
        self.alignRight = alignRight
        self.content = content
    }

    public init(_ title: String,
                isInserted: Binding<Bool> = .constant(true),
                animation: NSWindow.AnimationBehavior = .none,
                menu: NSMenu? = nil,
                alignRight: Bool = false,
                @ViewBuilder content: @escaping () -> Content) {
        self.init(title,
                  image: .none,
                  isInserted: isInserted,
                  animation: animation,
                  menu: menu,
                  alignRight: alignRight,
                  content: content)
    }

    public init(_ title: String,
                image: String,
                isInserted: Binding<Bool> = .constant(true),
                animation: NSWindow.AnimationBehavior = .none,
                menu: NSMenu? = nil,
                alignRight: Bool = false,
                @ViewBuilder content: @escaping () -> Content) {
        self.init(title,
                  image: .named(image),
                  isInserted: isInserted,
                  animation: animation,
                  menu: menu,
                  alignRight: alignRight,
                  content: content)
    }
    
    public init(_ title: String,
                image: NSImage,
                isInserted: Binding<Bool> = .constant(true),
                animation: NSWindow.AnimationBehavior = .none,
                menu: NSMenu? = nil,
                alignRight: Bool = false,
                @ViewBuilder content: @escaping () -> Content) {
        self.init(title,
                  image: .direct(image),
                  isInserted: isInserted,
                  animation: animation,
                  menu: menu,
                  alignRight: alignRight,
                  content: content)
    }

    public init(_ title: String,
                systemImage: String,
                isInserted: Binding<Bool> = .constant(true),
                animation: NSWindow.AnimationBehavior = .none,
                menu: NSMenu? = nil,
                alignRight: Bool = false,
                @ViewBuilder content: @escaping () -> Content) {
        self.init(title,
                  image: .systemNamed(systemImage),
                  isInserted: isInserted,
                  animation: animation,
                  menu: menu,
                  alignRight: alignRight,
                  content: content)
    }
    
    public func showWindow() {
        state.statusItem?.showWindow()
    }
    
    public func closeWindow() {
        state.statusItem?.dismissWindow()
    }

    public var body: some Scene {
        print("Re-evaluating FluidMenuBarExtra body.")

        if let statusItem = state.statusItem {
            print("Trying to force an update…")

            statusItem.window.tryToPerform("doUpdate", with: nil)
            //statusItem.window.setFrame(NSRect(x: 1000, y: 1300, width: 300, height: 400), display: true)// frame.size = CGSize(width: 300, height: 300)
            //statusItem.window.makeKeyAndOrderFront(self)
            //statusItem.window.contentView?.needsLayout = true
            //statusItem.window.contentView?.needsUpdateConstraints = true
            //statusItem.window.contentView?.needsDisplay = true
            //statusItem.setWindowPosition()
        } else {
            state.statusItem = FluidMenuBarExtraStatusItem(title: title,
                                                           image: image,
                                                           isInserted: $isInserted,
                                                           window: FluidMenuBarExtraWindow(title: title,
                                                                                           animation: animation,
                                                                                           content: content),
                                                           menu: menu,
                                                           alignRight: alignRight)
        }

        return Settings {}.onChange(of: isInserted) { state.statusItem?.isVisible = $0 }
    }
}


fileprivate class FluidMenuBarExtraStatusItemWrapper<Content: View>: ObservableObject {
    var statusItem: FluidMenuBarExtraStatusItem? = nil
}
