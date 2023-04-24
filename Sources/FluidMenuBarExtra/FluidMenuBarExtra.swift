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

    private let title: String
    private let image: FluidMenuBarExtraStatusItem.Image
    private let animation: NSWindow.AnimationBehavior
    private let menu: NSMenu?
    private let alignRight: Bool
    private let content: () -> Content

    private init(_ title: String,
                image: FluidMenuBarExtraStatusItem.Image,
                animation: NSWindow.AnimationBehavior = .none,
                menu: NSMenu? = nil,
                alignRight: Bool = false,
                @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.image = image
        self.animation = animation
        self.menu = menu
        self.alignRight = alignRight
        self.content = content
    }

    public init(_ title: String,
                animation: NSWindow.AnimationBehavior = .none,
                menu: NSMenu? = nil,
                alignRight: Bool = false,
                @ViewBuilder content: @escaping () -> Content) {
        self.init(title,
                  image: .none,
                  animation: animation,
                  menu: menu,
                  alignRight: alignRight,
                  content: content)
    }

    public init(_ title: String,
                image: String,
                animation: NSWindow.AnimationBehavior = .none,
                menu: NSMenu? = nil,
                alignRight: Bool = false,
                @ViewBuilder content: @escaping () -> Content) {
        self.init(title,
                  image: .named(image),
                  animation: animation,
                  menu: menu,
                  alignRight: alignRight,
                  content: content)
    }
    
    public init(_ title: String,
                image: NSImage,
                animation: NSWindow.AnimationBehavior = .none,
                menu: NSMenu? = nil,
                alignRight: Bool = false,
                @ViewBuilder content: @escaping () -> Content) {
        self.init(title,
                  image: .direct(image),
                  animation: animation,
                  menu: menu,
                  alignRight: alignRight,
                  content: content)
    }

    public init(_ title: String,
                systemImage: String,
                animation: NSWindow.AnimationBehavior = .none,
                menu: NSMenu? = nil,
                alignRight: Bool = false,
                @ViewBuilder content: @escaping () -> Content) {
        self.init(title,
                  image: .systemNamed(systemImage),
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
        if nil == state.statusItem {
            state.statusItem = FluidMenuBarExtraStatusItem(title: title,
                                                           image: image,
                                                           window: FluidMenuBarExtraWindow(title: title,
                                                                                           animation: animation,
                                                                                           content: content),
                                                           menu: menu,
                                                           alignRight: alignRight)
        }

        return Settings {}
    }
}


fileprivate class FluidMenuBarExtraStatusItemWrapper<Content: View>: ObservableObject {
    var statusItem: FluidMenuBarExtraStatusItem? = nil
}
