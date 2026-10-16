# CustomAlert

A customizable SwiftUI alert library for iOS 26 and later, with fold-aware placement on iPhone Duo.

This is an independent fork of [David Walter’s CustomAlert](https://github.com/divadretlaw/CustomAlert), based on upstream version 6.0.1. The fork’s first release is **7.0.0**. Development takes place on the [`ios26-base`](https://github.com/sechkarenkoDD/CustomAlert/tree/ios26-base) branch.

## Requirements

| Requirement | Version |
| --- | --- |
| Minimum iOS deployment target | iOS 26.0 |
| Build environment | Xcode 27.1 with the iOS 27.1 SDK |
| Fold-aware placement | iOS 27.1 or later |

The package also retains upstream visionOS support. The validation described below covers iOS, not visionOS.

## Changes in this fork

- Alerts avoid active fold regions using the public `reservedRegions` API on iOS 27.1 and later.
- With a vertical fold, the dialog uses the trailing region. With a horizontal fold, it prefers the upper region. When no active division region intersects the view, it uses the full available safe area.
- The dimmed background continues to cover the window while the dialog moves into its available region.
- Alert width is constrained to the available region, and scrolling is updated when the available height changes.
- Custom button styling, vertical actions, and `MultiButton` layouts remain available.
- Compatibility fallbacks for iOS versions earlier than 26 have been removed, and deprecated `onChange` calls have been updated.

On iOS 26, alerts use the existing presentation without querying reserved regions. The `.classic` configuration remains an optional style; it does not imply support for older iOS versions.

## Installation

In Xcode, choose **File → Add Package Dependencies** and enter:

```text
https://github.com/sechkarenkoDD/CustomAlert.git
```

Select **Exact Version** and enter **7.0.0** for a reproducible dependency on the verified release.

For a Swift package:

```swift
.package(url: "https://github.com/sechkarenkoDD/CustomAlert.git", exact: "7.0.0")
```

Add the product to your target’s dependencies:

```swift
.product(name: "CustomAlert", package: "CustomAlert")
```

Then import the library:

```swift
import CustomAlert
```

SPM resolves WindowKit and its dependencies automatically. Consumers do not need a local checkout of this repository.

## Features

CustomAlert presents SwiftUI content in its own window. It supports custom message views, images, text fields, configurable buttons, and Dynamic Type. Message content can scroll when it exceeds the available height.

## Usage

| iOS | SwiftUI Alert | Custom Alert |
|:---:|:-------------:|:------------:|
| iOS 26+ | ![Native Alert](Sources/CustomAlert/Documentation.docc/Resources/SwiftUI_liquidGlass.png) | ![Custom Alert](Sources/CustomAlert/Documentation.docc/Resources/Custom_liquidGlass.png) |

The default configuration on iOS is based on `CustomAlertConfiguration.liquidGlass`.

You can easily add an Image or change the Font used in the alert, or anything else to your imagination.

Something simple with an image and a text field

<img src="Sources/CustomAlert/Documentation.docc/Resources/Fancy.png" width="300">

Or more complex layouts

<img src="Sources/CustomAlert/Documentation.docc/Resources/Complex.png" width="300">

The API is very similar to the SwiftUI Alerts

```swift
.customAlert("Some Fancy Alert", isPresented: $showAlert) {
    Text("I'm a custom Message")
        .font(.custom("Noteworthy", size: 24))
    Image(systemName: "swift")
        .resizable()
        .scaledToFit()
        .frame(maxHeight: 100)
        .foregroundColor(.blue)
} actions: {
    Button {
        // some Action
    } label: {
        Label("Swift", systemImage: "swift")
    }
    
    Button(role: .cancel) {
        // some Action
    } label: {
        Text("Cancel")
    }
}
```

You can create Side by Side Buttons using `MultiButton`

```swift
.customAlert("Alert with Side by Side Buttons", isPresented: $showAlert) {
    Text("Choose left or right")
} actions: {
    MultiButton {
        Button {
            // some Action
        } label: {
            Text("Left")
        }

        Button {
            // some Action
        } label: {
            Text("Right")
        }
    }
}
```

The alert is customizable via the `Environment`

<img src="Sources/CustomAlert/Documentation.docc/Resources/CustomConfiguration.png" width="300">

```swift
.configureCustomAlert { configuration in
    // Adapt the default configuration
}
```

You can also display an Alert inline, within a `List` for example

<img src="Sources/CustomAlert/Documentation.docc/Resources/InlineAlert.png" width="300">

```swift
CustomAlertRow {
    // Content
} actions: {
    // Actions
}
```

## Validation

- Seven Swift Testing tests cover placement with no fold, vertical and horizontal folds, a fold outside the window, partial-window fallbacks, and a zero-width region.
- Folded and unfolded placement was manually verified in the iPhone Duo simulator on iOS 27.1.
- The consuming iOS app builds without warnings after the `onChange` migration.

The usage screenshots above are inherited upstream examples of styling, not evidence of fold testing. Horizontal-fold placement, right-to-left layouts, large accessibility text sizes, and visionOS still need dedicated visual validation.

## Development

Clone this fork and check out `ios26-base` to work on the library. You can temporarily use a local Swift package dependency while developing. After validation, publish a new version tag and update consuming apps to that exact version; keep published tags unchanged.

Version 7.0.0 raises the minimum iOS version from upstream’s iOS 15 to iOS 26. This fork is not a drop-in upgrade for apps that support earlier iOS releases.

## Credits and license

Original library by [David Walter](https://github.com/divadretlaw). This fork preserves the original license and copyright notices. See [LICENSE](LICENSE).
