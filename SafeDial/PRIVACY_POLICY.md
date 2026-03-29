# Privacy Policy for SafeDial

**Last Updated: March 29, 2026**

## Introduction

SafeDial ("we", "our", or "the app") is committed to protecting your privacy. This Privacy Policy explains how we handle information when you use our emergency services quick dial application.

## Summary

**We do not collect, store, or share any of your personal data.** All data processing happens entirely on your device.

## Information We Access

### Location Data
- **What we access:** Your device's approximate location (country-level)
- **Why we access it:** To automatically detect which country you're in and show the correct emergency service numbers
- **How we use it:** Location is processed entirely on your device using Apple's CoreLocation framework
- **What we don't do:**
  - We do NOT send your location to any servers
  - We do NOT share your location with third parties
  - We do NOT track your movements
  - We do NOT store precise GPS coordinates
  
Location access is completely optional. You can manually select a country if you prefer not to grant location permission.

## Information We Store Locally

The following information is stored only on your device:

1. **Cached Emergency Service Information**
   - The last detected country and its emergency numbers
   - Stored in your device's App Group for widget access
   - Used to provide offline functionality
   - Never leaves your device

2. **Language Preference**
   - Your selected app language
   - Stored in device UserDefaults
   - Used to display the app in your preferred language

3. **Disclaimer Acceptance**
   - A flag indicating you've accepted the app's disclaimer
   - Stored in device UserDefaults
   - Used to prevent showing the disclaimer on every launch

## Data We Do NOT Collect

- ❌ We do NOT collect analytics
- ❌ We do NOT use tracking tools
- ❌ We do NOT store personal information
- ❌ We do NOT use cookies
- ❌ We do NOT share data with advertisers
- ❌ We do NOT send any data to external servers
- ❌ We do NOT require account creation
- ❌ We do NOT collect device identifiers

## Third-Party Services

SafeDial does NOT use any third-party services, SDKs, or analytics frameworks. The app only uses Apple's built-in frameworks:
- CoreLocation (for country detection)
- MapKit (for reverse geocoding)
- WidgetKit (for widget functionality)
- SwiftUI (for user interface)

## Emergency Number Database

The emergency service phone numbers in SafeDial are:
- Stored as part of the app's code
- Not collected from users
- Based on publicly available information
- Provided for informational purposes only

**Important:** While we strive for accuracy, emergency numbers should always be verified with local authorities.

## Children's Privacy

SafeDial does not collect any information from anyone, including children under 13. The app is safe for all ages.

## Your Rights and Choices

### Location Permission
- You can grant or deny location permission at any time
- Go to: Settings → Privacy & Security → Location Services → SafeDial
- The app works fully without location permission (manual country selection)

### Delete Your Data
To delete all app data:
1. Delete the SafeDial app from your device
2. All cached data is automatically removed

Alternatively, you can reset the app without deleting:
1. Go to Settings → General → iPhone Storage → SafeDial
2. Tap "Delete App" or "Offload App"

### App Privacy Report (iOS 15.2+)
You can view the app's privacy behavior in real-time:
1. Go to Settings → Privacy & Security → App Privacy Report
2. Turn on App Privacy Report
3. Use SafeDial
4. Review the report to see exactly what data is accessed

You'll see:
- When location was accessed
- No network activity (because we don't send data anywhere)
- No third-party tracking

## Security

We implement industry-standard security practices:
- HMAC (Hash-based Message Authentication Code) for data integrity
- Phone number validation to prevent malicious input
- Country code validation
- OWASP Mobile Application Security Verification Standard (MASVS) compliance

All data stored on your device uses Apple's secure storage mechanisms.

## Changes to This Privacy Policy

We may update this Privacy Policy occasionally. Changes will be posted in this document with an updated "Last Updated" date. 

Significant changes will be communicated through:
- App Store release notes
- In-app notifications (if applicable)

## Compliance

SafeDial complies with:
- Apple App Store Privacy Requirements
- Apple Privacy Manifest Requirements
- GDPR (General Data Protection Regulation) - No data collection
- CCPA (California Consumer Privacy Act) - No data selling
- COPPA (Children's Online Privacy Protection Act) - No children's data collection

## Contact Information

If you have questions or concerns about this Privacy Policy, please contact:

**Developer:** Jimmy Gangi  
**Email:** [Your Email Address]  
**App:** SafeDial - Emergency Numbers  

## Disclaimer

SafeDial provides emergency service phone numbers for informational purposes only. Always verify emergency numbers with local authorities in your area. The app will actually dial emergency services when you tap to call.

Your location is used only to detect your country and is never shared with any third parties or servers. All data processing happens entirely on your device.

---

**By using SafeDial, you agree to this Privacy Policy.**

Last Updated: March 29, 2026  
Version: 1.0
