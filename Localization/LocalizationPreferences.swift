//
//  LocalizationPreferences.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/5/26.
//

import Foundation

/// Manages user preferences for localization with widget sync
enum LocalizationPreferences {
    private static let selectedLocaleKey = "selectedLocaleIdentifier"
    private static let selectedLocalePlainKey = "selectedLocaleIdentifierPlain"

    /// Saves the user's selected locale identifier and syncs to widget
    static func saveSelectedLocale(_ identifier: String) {
        // Always write a plain-string copy the widget can read without HMAC
        AppGroup.userDefaults.set(identifier, forKey: selectedLocalePlainKey)

        do {
            try AppGroup.secureSet(identifier, forKey: selectedLocaleKey)
        } catch {
            // Secure write failed; plain key above is the reliable fallback
        }

        WidgetUpdateManager.reloadAllWidgets()
    }

    /// Loads the user's selected locale identifier
    static func loadSelectedLocale() -> String? {
        // Try secure storage first
        if let identifier = try? AppGroup.secureGet(String.self, forKey: selectedLocaleKey) {
            return identifier
        }
        // Reliable plain-string fallback
        return AppGroup.userDefaults.string(forKey: selectedLocalePlainKey)
    }

    /// Removes the saved locale preference and syncs to widget
    static func clearSelectedLocale() {
        AppGroup.secureRemove(forKey: selectedLocaleKey)
        AppGroup.userDefaults.removeObject(forKey: selectedLocalePlainKey)
        WidgetUpdateManager.reloadAllWidgets()
    }

    /// Removes the saved locale preference (resets to system default) - alias for compatibility
    static func resetLocalePreference() {
        clearSelectedLocale()
    }
}
