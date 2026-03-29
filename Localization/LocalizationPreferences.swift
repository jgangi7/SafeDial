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
    
    /// Saves the user's selected locale identifier and syncs to widget
    static func saveSelectedLocale(_ identifier: String) {
        do {
            // Save to secure App Group storage
            try AppGroup.secureSet(identifier, forKey: selectedLocaleKey)
            
            // Immediately sync to widget - this ensures widget updates when language changes
            WidgetUpdateManager.reloadAllWidgets()
            
        } catch {
            // Fallback to insecure storage if secure storage fails
            AppGroup.userDefaults.set(identifier, forKey: selectedLocaleKey)
            WidgetUpdateManager.reloadAllWidgets()
            
        }
    }
    
    /// Loads the user's selected locale identifier
    static func loadSelectedLocale() -> String? {
        do {
            let identifier = try AppGroup.secureGet(String.self, forKey: selectedLocaleKey)
            return identifier
        } catch {
            // Fallback to insecure storage for backward compatibility
            let identifier = AppGroup.userDefaults.string(forKey: selectedLocaleKey)
            return identifier
        }
    }
    
    /// Removes the saved locale preference and syncs to widget
    static func clearSelectedLocale() {
        AppGroup.secureRemove(forKey: selectedLocaleKey)
        WidgetUpdateManager.reloadAllWidgets()
        
    }
    
    /// Removes the saved locale preference (resets to system default) - alias for compatibility
    static func resetLocalePreference() {
        clearSelectedLocale()
    }
}
