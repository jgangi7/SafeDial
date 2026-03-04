# SafeDial - Emergency Services Quick Dial

An iOS app and widget that automatically detects your location and provides instant access to emergency services numbers for your current country.

## Features

✅ **Automatic Location Detection** - Detects your current country and displays the correct emergency numbers
✅ **Lock Screen Widget** - Add to Lock Screen for instant access in emergencies
✅ **Home Screen Widget** - Multiple widget sizes (Small, Medium, Large)
✅ **One-Tap Dialing** - Tap the widget to immediately call emergency services
✅ **60+ Countries Supported** - Comprehensive database of emergency numbers worldwide
✅ **Offline Support** - Caches last known location for offline use
✅ **Multiple Service Numbers** - Shows police, ambulance, and fire numbers when they differ

## Setup Instructions

### 1. Enable App Groups (Required for Widget)

For the widget to share data with the main app, you need to enable App Groups:

1. Select your main app target in Xcode
2. Go to **Signing & Capabilities**
3. Click **+ Capability** and add **App Groups**
4. Enable or create a group named: `group.com.yourcompany.safedial`
5. Repeat steps 1-4 for the **Widget Extension target**

**Important:** Update the group identifier in `AppGroup.swift` if you use a different name:
```swift
enum AppGroup {
    static let identifier = "group.com.yourcompany.safedial" // Change this
}
```

### 2. Add Location Permission

The app needs location permission to detect the user's country. This is already handled in code, but you need to add the usage description to your Info.plist:

**Key:** `NSLocationWhenInUseUsageDescription`  
**Value:** "SafeDial needs your location to show emergency numbers for your current country."

### 3. Build and Run

1. Build and run the main app first
2. Grant location permission when prompted
3. The app will detect your location and cache the emergency service info
4. Add the widget to your Home Screen or Lock Screen
5. Tap the widget to dial emergency services

## Widget Sizes

- **Lock Screen - Circular:** Shows SOS icon and number
- **Lock Screen - Rectangular:** Shows full service name and location
- **Lock Screen - Inline:** Shows compact SOS info
- **Home Screen - Small:** Large emergency number with SOS icon
- **Home Screen - Medium:** Emergency number plus specific services
- **Home Screen - Large:** Full service list with individual tap targets

## How It Works

1. **Location Detection:** The app uses CoreLocation to determine the user's country code
2. **Emergency Database:** Matches country code against a built-in database of 60+ countries
3. **Data Sharing:** Emergency service info is cached in App Group UserDefaults
4. **Widget Updates:** Widget reads cached data and updates hourly
5. **Quick Dial:** Tapping the widget opens the Phone app with the emergency number pre-dialed

## Supported Countries

The app includes emergency numbers for:
- 🇺🇸 North America (US, Canada, Mexico)
- 🇪🇺 Europe (UK, France, Germany, Italy, Spain, and 15+ more)
- 🌏 Asia-Pacific (Japan, China, Australia, India, Singapore, and 10+ more)
- 🌍 Middle East & Africa (UAE, South Africa, Israel, and more)
- 🌎 South America (Brazil, Argentina, Chile, and more)

Default fallback: **112** (EU standard, works in many countries)

## Privacy

- Location data is only used to determine your country
- No data is sent to servers or third parties
- Location information is processed on-device only
- Only approximate location is used (kilometer accuracy)

## Testing

To test with different locations:

1. Run the app in Simulator
2. In Simulator menu: **Features → Location → Custom Location**
3. Enter coordinates for different countries:
   - London, UK: 51.5074, -0.1278
   - Tokyo, Japan: 35.6762, 139.6503
   - Sydney, Australia: -33.8688, 151.2093
   - New York, US: 40.7128, -74.0060
4. Pull down to refresh in the app
5. Widget will update on next refresh

## Future Enhancements

- [ ] Add more countries
- [ ] Support for regions with different emergency numbers (e.g., US states)
- [ ] Travel mode: Pin multiple countries for quick access
- [ ] Emergency contact shortcuts
- [ ] Medical info quick access
- [ ] Offline maps integration

## Important Notes

⚠️ **This app is for informational purposes.** Always verify emergency numbers with local authorities.

⚠️ **Test calling features carefully** - The app will actually dial emergency services when tapped.

⚠️ **Requires iOS 16+** for Lock Screen widgets. Home Screen widgets work on iOS 14+.

## License

Created by Jimmy Gangi on 3/4/26
