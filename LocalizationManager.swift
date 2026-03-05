//
//  LocalizationManager.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/5/26.
//

import Foundation
import SwiftUI
import Combine

/// Manages app-wide localization and translation
final class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    /// Currently selected locale
    @Published var currentLocale: Locale
    
    /// Currently selected locale identifier
    @Published var currentLocaleIdentifier: String
    
    /// All available locales on the device
    let availableLocales: [LocaleInfo]
    
    private init() {
        // Load saved preference or use system default
        let savedIdentifier = LocalizationPreferences.loadSelectedLocale()
        let identifier = savedIdentifier ?? Locale.current.identifier
        self.currentLocaleIdentifier = identifier
        self.currentLocale = Locale(identifier: identifier)
        
        // Build list of all available locales
        self.availableLocales = Self.buildAvailableLocales()
    }
    
    /// Changes the app's locale
    func changeLocale(to identifier: String) {
        currentLocaleIdentifier = identifier
        currentLocale = Locale(identifier: identifier)
        LocalizationPreferences.saveSelectedLocale(identifier)
    }
    
    /// Resets to system default locale
    func resetToSystemDefault() {
        let systemIdentifier = Locale.current.identifier
        changeLocale(to: systemIdentifier)
    }
    
    /// Gets localized string for a key
    func localize(_ key: LocalizedStringKey) -> String {
        LocalizedStrings.translate(key, locale: currentLocale)
    }
    
    // MARK: - Available Locales
    
    private static func buildAvailableLocales() -> [LocaleInfo] {
        // Curated list of supported locales
        let supportedIdentifiers = [
            // English variants
            "en-US",      // English, United States
            "en-GB",      // English, United Kingdom
            "en-AU",      // English, Australia
            
            // Spanish variants
            "es-ES",      // Spanish, Spain
            "es-MX",      // Spanish, Mexico
            "es-AR",      // Spanish, Argentina
            "es-CO",      // Spanish, Colombia
            
            // French variants
            "fr-FR",      // French, France
            "fr-CA",      // French, Canada
            
            // German
            "de-DE",      // German, Germany
            
            // Italian
            "it-IT",      // Italian, Italy
            
            // Portuguese variants
            "pt-BR",      // Portuguese, Brazil
            "pt-PT",      // Portuguese, Portugal
            
            // Japanese
            "ja-JP",      // Japanese, Japan
            
            // Chinese variants
            "zh-Hans-CN", // Chinese, Simplified (China)
            "zh-Hant-TW", // Chinese, Traditional (Taiwan)
            
            // Korean
            "ko-KR",      // Korean, South Korea
            
            // Dutch variants
            "nl-NL",      // Dutch, Netherlands
            "nl-BE",      // Dutch, Belgium
            
            // Greek
            "el-GR",      // Greek, Greece
            
            // Turkish
            "tr-TR",      // Turkish, Turkey
            
            // Polish
            "pl-PL",      // Polish, Poland
            
            // Swedish
            "sv-SE",      // Swedish, Sweden
            
            // Norwegian
            "nb-NO",      // Norwegian, Norway (Bokmål)
            
            // Danish
            "da-DK",      // Danish, Denmark
            
            // Finnish
            "fi-FI",      // Finnish, Finland
            
            // Russian
            "ru-RU",      // Russian, Russia
            
            // Ukrainian
            "uk-UA",      // Ukrainian, Ukraine
            
            // Hindi
            "hi-IN",      // Hindi, India
            
            // Thai
            "th-TH",      // Thai, Thailand
            
            // Vietnamese
            "vi-VN",      // Vietnamese, Vietnam
            
            // Indonesian
            "id-ID",      // Indonesian, Indonesia
            
            // Malay
            "ms-MY",      // Malay, Malaysia
            
            // Tagalog
            "tl-PH",      // Tagalog, Philippines
            
            // Arabic variants
            "ar-SA",      // Arabic, Saudi Arabia
            "ar-AE",      // Arabic, United Arab Emirates
            "ar-EG",      // Arabic, Egypt
            
            // Hebrew
            "he-IL",      // Hebrew, Israel
            
            // Afrikaans
            "af-ZA",      // Afrikaans, South Africa
            
            // Swahili
            "sw-KE"       // Swahili, Kenya
        ]
        
        // Use English locale to display names consistently
        let displayLocale = Locale(identifier: "en-US")
        
        var locales: [LocaleInfo] = supportedIdentifiers.compactMap { identifier in
            guard let languageCode = Locale(identifier: identifier).language.languageCode?.identifier else {
                return nil
            }
            
            // Get the friendly name in English
            let friendlyName = displayLocale.localizedString(forIdentifier: identifier) ?? identifier
            
            // Get the native name (how speakers of that language would write it)
            let nativeLocale = Locale(identifier: identifier)
            let nativeName = nativeLocale.localizedString(forIdentifier: identifier) ?? friendlyName
            
            return LocaleInfo(
                identifier: identifier,
                languageCode: languageCode,
                friendlyName: friendlyName,
                nativeName: nativeName
            )
        }
        
        return locales
    }
    
    /// Gets flag emoji for a locale (if available)
    static func flag(for locale: Locale) -> String? {
        guard let regionCode = locale.region?.identifier else {
            return nil
        }
        
        let base: UInt32 = 127397
        var flag = ""
        
        for scalar in regionCode.unicodeScalars {
            if let unicodeScalar = UnicodeScalar(base + scalar.value) {
                flag.append(String(unicodeScalar))
            }
        }
        
        return flag.isEmpty ? nil : flag
    }
}

// MARK: - Locale Info

/// Information about a locale
struct LocaleInfo: Identifiable, Hashable {
    let identifier: String
    let languageCode: String
    let friendlyName: String  // e.g., "English (United States)"
    let nativeName: String    // e.g., "English (United States)" or "Español (España)"
    
    var id: String { identifier }
    
    /// Flag emoji if available
    var flag: String? {
        let locale = Locale(identifier: identifier)
        return LocalizationManager.flag(for: locale)
    }
    
    /// Display name with flag
    var displayName: String {
        if let flag = flag {
            return "\(flag) \(nativeName)"
        }
        return nativeName
    }
}

// MARK: - Array Extension for Uniquing

extension Array where Element: Hashable {
    func uniqued<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { element in
            let key = element[keyPath: keyPath]
            if seen.contains(key) {
                return false
            } else {
                seen.insert(key)
                return true
            }
        }
    }
}
