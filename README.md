# SafeDial

An iOS app that provides instant access to the correct emergency service numbers based on your current location — directly from your lock screen or home screen.

## Overview

SafeDial detects your country automatically using GPS and displays the appropriate emergency numbers (police, fire, ambulance, etc.) for that region. One-tap dialing is available via lock screen and home screen widgets, so you can reach help without unlocking your phone or knowing the local number.

Supports 60+ countries with offline caching, so it works even without an internet connection.

## Features

- **Lock Screen & Home Screen Widgets** — quick-dial emergency services from iOS 16+ lock screen or home screen (iOS 14+)
- **Automatic Location Detection** — uses CoreLocation to identify your country and surface the correct numbers
- **Offline Support** — emergency data is cached locally so it works without connectivity
- **Multi-language Support** — localization system supporting multiple languages
- **Privacy-First** — location is processed on-device only; no data is sent to external servers

## Architecture

| Component | Description |
|-----------|-------------|
| `SafeDial/` | Main app — disclaimer, manual country picker, settings |
| `MyWidget/` | WidgetKit extension for lock screen and home screen widgets |
| `Localization/` | Language management and localized strings |
| `ColorScheme.swift` | Design system ("Tactical Calm") — colors, spacing, typography |

Data is shared between the main app and widget extension via App Groups and `UserDefaults`.

## Requirements

- iOS 14+ (home screen widgets)
- iOS 16+ (lock screen widgets)
- Xcode 15+
- Location permission (used locally only)

## Building

Open `SafeDial.xcodeproj` in Xcode, select your target device or simulator, and build (`Cmd+B`).

Ensure the App Group identifier in `AppGroup.swift` matches the one configured in your provisioning profile.

## Privacy

Location data is used only to determine your country code. It is never stored on servers or shared with third parties. See [PRIVACY_POLICY.md](PRIVACY_POLICY.md) for full details.
