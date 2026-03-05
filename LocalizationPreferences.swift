//
//  LocalizationPreferences.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/5/26.
//

import Foundation

/// Manages user preferences for localization
enum LocalizationPreferences {
    private static let selectedLocaleKey = "selectedLocaleIdentifier"
    
    /// Saves the user's selected locale identifier
    static func saveSelectedLocale(_ identifier: String) {
        do {
            try AppGroup.secureSet(identifier, forKey: selectedLocaleKey)
        } catch {
            // Fallback to standard UserDefaults if secure storage fails
            AppGroup.userDefaults.set(identifier, forKey: selectedLocaleKey)
        }
    }
    
    /// Loads the user's selected locale identifier
    static func loadSelectedLocale() -> String? {
        do {
            return try AppGroup.secureGet(String.self, forKey: selectedLocaleKey)
        } catch {
            // Fallback to standard UserDefaults
            return AppGroup.userDefaults.string(forKey: selectedLocaleKey)
        }
    }
    
    /// Removes the saved locale preference (resets to system default)
    static func resetLocalePreference() {
        AppGroup.secureRemove(forKey: selectedLocaleKey)
    }
}
