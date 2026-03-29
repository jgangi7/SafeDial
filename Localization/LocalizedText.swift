//
//  LocalizedText.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/5/26.
//

import SwiftUI

/// A SwiftUI view that displays localized text
struct LocalizedText: View {
    let key: LocalizedStringKey
    @ObservedObject private var localizationManager: LocalizationManager
    
    init(_ key: LocalizedStringKey) {
        self.key = key
        self.localizationManager = LocalizationManager.shared
    }
    
    var body: some View {
        Text(localizationManager.localize(key))
    }
}

/// Extension to make LocalizedText easier to use
extension View {
    /// Creates a localized text view
    func localizedText(_ key: LocalizedStringKey) -> some View {
        LocalizedText(key)
    }
}

// MARK: - String Extension for Non-View Contexts

extension String {
    /// Initialize a String with a localized key
    init(localized key: LocalizedStringKey) {
        let manager: LocalizationManager = .shared
        self = manager.localize(key)
    }
}
