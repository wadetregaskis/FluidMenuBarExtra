//
//  FluidMenuBarExtraWindow.swift
//  FluidMenuBarExtra
//
//  Created by Lukas Romsicki on 2022-12-16.
//  Copyright © 2022 Lukas Romsicki.
//

import AppKit
import SwiftUI

/// A custom window configured to behave as closely to an `NSMenu` as possible.
///
/// `FluidMenuBarExtraWindow` listens for changes to the size of its content and
/// automatically adjusts its frame to match.
final class FluidMenuBarExtraWindow<Content: View>: NSPanel {
    private let content: () -> Content

    private lazy var visualEffectView: NSVisualEffectView = {
        print("Creating visual effect view…")

        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .popover
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()

    private var rootView: some View {
        print("Creating root view…")

        return content()
            .modifier(RootViewModifier(windowTitle: title))
            .onSizeUpdate { [weak self] size in
                self?.contentSizeDidUpdate(to: size)
            }
    }

    private var hostingView: NSHostingView<AnyView>? = nil

    private func createHostingView() -> NSHostingView<AnyView> {
        print("Creating hosting view…")

        let view = NSHostingView(rootView: AnyView(rootView))
        // Disable NSHostingView's default automatic sizing behavior.
        view.sizingOptions = []
        view.isVerticalContentSizeConstraintActive = false
        view.isHorizontalContentSizeConstraintActive = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    init(title: String, animation: NSWindow.AnimationBehavior = .none, content: @escaping () -> Content) {
        self.content = content

        super.init(
            contentRect: CGRect(x: 0, y: 0, width: 100, height: 100),
            styleMask: [.titled, .nonactivatingPanel, .utilityWindow, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        self.title = title

        isMovable = false
        isMovableByWindowBackground = false
        isFloatingPanel = true
        level = .statusBar
        isOpaque = false
        titleVisibility = .hidden
        titlebarAppearsTransparent = true

        animationBehavior = animation
        collectionBehavior = [.stationary, .moveToActiveSpace, .fullScreenAuxiliary]
        isReleasedWhenClosed = false
        hidesOnDeactivate = false

        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true

        contentView = visualEffectView
        hostingView = createHostingView()
        visualEffectView.addSubview(hostingView!)

        let size = hostingView!.intrinsicContentSize
        print("Just added views to the pop-up window, which has frame \(frame).\nSetting content size to \(size)…")
        setContentSize(size)

        NSLayoutConstraint.activate([
            hostingView!.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            hostingView!.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor),
            hostingView!.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor),
            hostingView!.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor)
        ])
    }

    @objc func doUpdate() {
        print("doUpdate()\n\tCurrent frame: \(frame)")

        return

//        hostingView?.needsLayout = true
//        hostingView?.needsDisplay = true

//        print("Prior contraints: \(hostingView!.constraints)")
        NSLayoutConstraint.deactivate(hostingView!.constraints)

        let newHostingView = createHostingView()
        contentView?.subviews = []

//        return


//        NSLayoutConstraint.deactivate(
//            hostingView!.topAnchor.constraintsAffectingLayout
//            + hostingView!.trailingAnchor.constraintsAffectingLayout
//            + hostingView!.bottomAnchor.constraintsAffectingLayout
//            + hostingView!.leadingAnchor.constraintsAffectingLayout)

        contentView?.addSubview(newHostingView)
//        contentView?.replaceSubview(hostingView!, with: newHostingView)

        setContentSize(CGSize(width: 300, height: 300))//newHostingView.intrinsicContentSize)

        NSLayoutConstraint.activate([
            newHostingView.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            newHostingView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor),
            newHostingView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor),
            newHostingView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor)
        ])

        hostingView = newHostingView
    }

    private func contentSizeDidUpdate(to size: CGSize) {
        var nextFrame = frame
        let previousContentSize = contentRect(forFrameRect: frame).size

        let deltaX = size.width - previousContentSize.width
        let deltaY = size.height - previousContentSize.height

        print("contentSizeDidUpdate(to: \(size)\n\tCurrent frame: \(frame))\n\tPrevious content size: \(previousContentSize)\n\tDelta: x=\(deltaX), y=\(deltaY)")

        nextFrame.origin.y -= deltaY
        nextFrame.size.width += deltaX
        nextFrame.size.height += deltaY

        print("\tNew frame: \(nextFrame)")

        guard frame != nextFrame else {
            return
        }

        print("\tSetting new frame asynchronously…")

        DispatchQueue.main.async { [weak self] in
            nextFrame.size = CGSize(width: 333, height: 333)
            print("Setting frame to \(nextFrame) (from contentSizeDidUpdate(to:)).")
            self?.setFrame(nextFrame, display: true, animate: true)
        }
    }
}
