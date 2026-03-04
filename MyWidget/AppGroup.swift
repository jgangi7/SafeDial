//
//  AppGroup.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import Foundation

enum AppGroup {
    static let identifier = "group.com.jgangi.emergencyroute"
    
    static var userDefaults: UserDefaults {
        print("📦 AppGroup: Attempting to load UserDefaults for '\(identifier)'")
        
        // Try to load the App Group UserDefaults
        // If it fails, fall back to standard UserDefaults with a warning
        if let defaults = UserDefaults(suiteName: identifier) {
            print("✅ AppGroup: Successfully loaded App Group UserDefaults")
            return defaults
        } else {
            print("⚠️ WARNING: Unable to load App Group UserDefaults. Falling back to standard UserDefaults.")
            print("⚠️ Make sure '\(identifier)' is configured in both app and widget extension targets.")
            print("⚠️ Go to: Target → Signing & Capabilities → + Capability → App Groups")
            return UserDefaults.standard
        }
    }
}

extension UserDefaults {
    static var appGroup: UserDefaults {
        AppGroup.userDefaults
    }
}
