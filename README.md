<h1 align="center">
  &#128421;
  <br>
  FluidMenuBarExtra 
  <br>
</h1>

<h4 align="center">A lightweight tool for building great menu bar extras with SwiftUI.</h4>

<p align="center">
  <a href="https://github.com/wadetregaskis/FluidMenuBarExtra/issues"><img alt="GitHub issues" src="https://img.shields.io/github/issues/wadetregaskis/FluidMenuBarExtra"></a>
  <img alt="GitHub contributors" src="https://img.shields.io/github/contributors/wadetregaskis/FluidMenuBarExtra">
  <a href="https://github.com/wadetregaskis/FluidMenuBarExtra/stargazers"><img alt="GitHub stars" src="https://img.shields.io/github/stars/wadetregaskis/FluidMenuBarExtra"></a>
  <a href="https://github.com/wadetregaskis/FluidMenuBarExtra"><img alt="GitHub license" src="https://img.shields.io/github/license/wadetregaskis/FluidMenuBarExtra"></a>
  <a href="https://swiftpackageindex.com/wadetregaskis/FluidMenuBarExtra"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fwadetregaskis%2FFluidMenuBarExtra%2Fbadge%3Ftype%3Dplatforms"></a>
</p>

<p align="center">
  <img alt="Menu Sample" src="https://user-images.githubusercontent.com/3951690/208313040-34f97eb5-1ac2-4f25-a510-ba30da2303e8.gif" width="300px">
</p>

## About

SwiftUI's built-in [`MenuBarExtra`](https://developer.apple.com/documentation/swiftui/menubarextra) API makes it easy to create menu bar applications in pure SwiftUI.  However, as of macOS 13 its functionality is extremely limited.  Worse, it doesn't behave correctly (e.g. it doesn't animate, it doesn't close the pop-up when the user interacts with other menu items, etc).

FluidMenuBarExtra provides a drop-in replacement to correct these issues.

### Key Features

- Animated resizing when SwiftUI content changes.
- Ability to access the scene phase of the menu using the `scenePhase` environment key.
- Persisted highlighting of the menu bar button.
- Smooth fade out animation when the menu is dismissed.
- Automatic repositioning if the menu would otherwise surpass the screen edge.

## Usage

Use FluidMenuBarExtra like you would Apple's MenuBarExtra, e.g.:

```swift
import SwiftUI
import FluidMenuBarExtra

@main
private struct DemoApp: App {
    @AppStorage("showMenuBarExtra") var showMenuBarExtra = true

    var body: some Scene {
        FluidMenuBarExtra("Demo", systemImage: "chevron.down.circle", isInserted: $showMenuBarExtra) {
            Text("Hello, world!")
                .padding(20)
        }
    }
}
```

See also the included demo application for a more elaborate example.

## Caveats

- Since FluidMenuBarExtra uses an `NSWindow`, not an `NSMenu`, you'll find that the window presented by FluidMenuBarExtra has a slighter wider corner radius than other menus.

## Contributions

All contributions are welcome. If you have a need for this kind of package, feel free to resolve any issues and add any features that may be useful.

## License

FluidMenuBarExtra is released under the [MIT License](LICENSE) unless otherwise noted.
