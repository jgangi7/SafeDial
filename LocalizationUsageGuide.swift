//
//  LocalizationUsageGuide.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/5/26.
//
//  USAGE GUIDE: How to use the Localization System in SafeDial
//

import SwiftUI

/*
 
 OVERVIEW
 ========
 
 SafeDial now includes a comprehensive localization system that allows the app to be
 translated into multiple languages. The system consists of:
 
 1. LocalizationManager - Main manager for handling locale selection
 2. LocalizedStrings - Translation dictionary for all supported languages
 3. LocalizationPreferences - Persistent storage for user's language choice
 4. LanguagePickerView - UI for selecting a language
 
 
 SUPPORTED LANGUAGES
 ===================
 
 Currently supported languages include:
 - English (United States) - en-US
 - English (United Kingdom) - en-GB
 - English (Australia) - en-AU
 - Spanish (Spain) - es-ES
 - Spanish (Mexico) - es-MX
 - French (France) - fr-FR
 - French (Canada) - fr-CA
 - German (Germany) - de-DE
 - Italian (Italy) - it-IT
 - Portuguese (Brazil) - pt-BR
 - Japanese (Japan) - ja-JP
 - Chinese Simplified (China) - zh-Hans-CN
 - Chinese Traditional (Taiwan) - zh-Hant-TW
 - Dutch (Netherlands) - nl-NL
 - Dutch (Belgium) - nl-BE
 - Greek (Greece) - el-GR
 - Turkish (Turkey) - tr-TR
 - Polish (Poland) - pl-PL
 - Swedish (Sweden) - sv-SE
 - Norwegian (Norway, Bokmål) - nb-NO
 - Danish (Denmark) - da-DK
 - Finnish (Finland) - fi-FI
 - Russian (Russia) - ru-RU
 - Ukrainian (Ukraine) - uk-UA
 
 
 USAGE IN SWIFTUI VIEWS
 =======================
 
 1. Using Text views with localization:
 
    // Instead of:
    Text("Cancel")
    
    // Use:
    LocalizedText(.cancel)
    
    // Note: Use LocalizedText, not Text, because this project uses
    // a custom LocalizedStringKey enum, not SwiftUI's built-in one.
    
 
 2. Using String values:
 
    let manager = LocalizationManager.shared
    let localizedString = manager.localize(.emergency)
    
 
 3. Showing the language picker:
 
    @State private var showingLanguagePicker = false
    
    Button("Select Language") {
        showingLanguagePicker = true
    }
    .sheet(isPresented: $showingLanguagePicker) {
        LanguagePickerView()
    }
 
 
 4. Observing locale changes:
 
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        Text("Current locale: \(localizationManager.currentLocale.identifier)")
    }
 
 
 ADDING NEW LOCALIZABLE STRINGS
 ===============================
 
 To add a new localizable string:
 
 1. Add the key to LocalizedStringKey enum:
 
    enum LocalizedStringKey: String, CaseIterable {
        // ...existing cases...
        case myNewString = "my_new_string"
    }
 
 
 2. Add translations to LocalizedStrings.translations:
 
    private static let translations: [String: [LocalizedStringKey: String]] = [
        "en": [
            // ...existing translations...
            .myNewString: "My New String"
        ],
        
        "es": [
            // ...existing translations...
            .myNewString: "Mi Nueva Cadena"
        ],
        
        // ...add for all supported languages...
    ]
 
 
 3. Use it in your views:
 
    LocalizedText(.myNewString)
 
 
 PROGRAMMATIC LOCALE CHANGES
 ============================
 
 Change the app's locale programmatically:
 
    let manager = LocalizationManager.shared
    manager.changeLocale(to: "es") // Spanish
    
 Reset to system default:
 
    let manager = LocalizationManager.shared
    manager.resetToSystemDefault()
 
 
 ACCESSING ALL AVAILABLE LOCALES
 ================================
 
 Get list of all available locales on device:
 
    let manager = LocalizationManager.shared
    let allLocales = manager.availableLocales
    
    for locale in allLocales {
        print("\(locale.flag ?? "🌐") \(locale.nativeName)")
        print("  Identifier: \(locale.identifier)")
        print("  Language Code: \(locale.languageCode)")
    }
 
 
 LOCALE INFO STRUCTURE
 =====================
 
 Each locale provides:
 - identifier: The full locale identifier (e.g., "en-US")
 - languageCode: The ISO language code (e.g., "en")
 - friendlyName: English name (e.g., "English (United States)")
 - nativeName: Native language name (e.g., "English (United States)")
 - flag: Optional emoji flag for the region
 - displayName: Combines flag + nativeName
 
 
 BEST PRACTICES
 ==============
 
 1. Always use LocalizedStringKey enum - don't hardcode strings
 2. Provide translations for ALL supported languages when adding new keys
 3. Use the LocalizedText(.key) syntax for SwiftUI views (not Text)
 4. Test your app in different languages to ensure proper layout
 5. Consider RTL (Right-to-Left) languages like Arabic when designing layouts
 
 
 INTEGRATION WITH EXISTING FEATURES
 ===================================
 
 The localization system is already integrated into:
 - ContentView (Location card, empty state, change button)
 - ManualCountryPickerView (Title, search placeholder, cancel button)
 - EmergencyServiceType (Emergency, Police, Ambulance, Fire labels)
 - Security alerts (Validation error messages)
 
 
 PERSISTENCE
 ===========
 
 The user's language selection is automatically saved using:
 - LocalizationPreferences (backed by AppGroup.secureSet)
 - Persists across app launches
 - Shared between app and widgets (via App Group)
 - Includes HMAC integrity protection for security
 
 
 DYNAMIC UPDATES
 ===============
 
 When the user changes language:
 1. LocalizationManager.currentLocale is updated
 2. All @StateObject references are notified (via @Published)
 3. SwiftUI views automatically re-render with new translations
 4. No app restart required
 
 
 EXAMPLE: Complete Implementation
 =================================
 */

struct ExampleLocalizationView: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var showingLanguagePicker = false
    
    var body: some View {
        NavigationStack {
            List {
                // Section 1: Current language info
                Section {
                    HStack {
                        if let currentLocale = localizationManager.availableLocales.first(where: { $0.identifier == localizationManager.currentLocaleIdentifier }),
                           let flag = currentLocale.flag {
                            Text(flag)
                                .font(.largeTitle)
                        }
                        
                        VStack(alignment: .leading) {
                            LocalizedText(.currentLanguage)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text(localizationManager.currentLocale.identifier)
                                .font(.headline)
                        }
                    }
                }
                
                // Section 2: Localized UI examples
                Section {
                    LocalizedText(.emergency)
                    LocalizedText(.police)
                    LocalizedText(.ambulance)
                    LocalizedText(.fire)
                }
                
                // Section 3: Actions
                Section {
                    Button {
                        showingLanguagePicker = true
                    } label: {
                        Label {
                            LocalizedText(.selectLanguage)
                        } icon: {
                            Image(systemName: "globe")
                        }
                    }
                    
                    Button {
                        localizationManager.resetToSystemDefault()
                    } label: {
                        Label {
                            LocalizedText(.resetToSystemDefault)
                        } icon: {
                            Image(systemName: "arrow.counterclockwise")
                        }
                    }
                }
            }
            .navigationTitle(localizationManager.localize(.language))
            .sheet(isPresented: $showingLanguagePicker) {
                LanguagePickerView()
            }
        }
    }
}

#Preview {
    ExampleLocalizationView()
}
