//
//  SafeDialWidget.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import WidgetKit
import SwiftUI

struct SafeDialWidget: Widget {
    let kind: String = "SafeDialWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EmergencyServiceProvider()) { entry in
            SafeDialWidgetEntryView(entry: entry)
                .containerBackground(Color(.secondarySystemGroupedBackground), for: .widget)
        }
        .configurationDisplayName("Emergency Services")
        .description("Quick access to emergency service numbers for your location.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular])
    }
}

// MARK: - Timeline Entry

struct EmergencyEntry: TimelineEntry {
    let date: Date
    let service: EmergencyService
    let locale: Locale // Add locale to timeline entry for translations
}

// MARK: - Timeline Provider

struct EmergencyServiceProvider: TimelineProvider {
    typealias Entry = EmergencyEntry

    func placeholder(in context: Context) -> EmergencyEntry {
        // Use the actual cached service for placeholder as well
        let service = loadCachedService()
        let locale = loadCachedLocale()
        return EmergencyEntry(date: Date(), service: service, locale: locale)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (EmergencyEntry) -> Void) {
        let service = loadCachedService()
        let locale = loadCachedLocale()
        let entry = EmergencyEntry(date: Date(), service: service, locale: locale)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<EmergencyEntry>) -> Void) {
        let currentDate = Date()
        let service = loadCachedService()
        let locale = loadCachedLocale()
        let entry = EmergencyEntry(date: currentDate, service: service, locale: locale)
        
        // Reload more frequently to pick up changes from the app
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
    
    /// Loads cached locale preference for translations
    private func loadCachedLocale() -> Locale {
        if let identifier = LocalizationPreferences.loadSelectedLocale() {
            return Locale(identifier: identifier)
        }

        return Locale.current
    }
    
    /// Loads cached service with HMAC integrity verification
    /// OWASP MASVS: STORAGE-1, RESILIENCE-1
    private func loadCachedService() -> EmergencyService {
        do {
            // Use secure storage with HMAC verification
            if let service = try AppGroup.secureGet(EmergencyService.self, forKey: "cachedEmergencyService") {
                // Validate loaded data
                guard validateLoadedService(service) else {
                    return EmergencyServiceDatabase.shared.defaultService
                }
                
                return service
            }
        } catch SecurityError.integrityCheckFailed {
            // Clean up compromised data
            AppGroup.secureRemove(forKey: "cachedEmergencyService")
        } catch {
            // Fallback: Try loading legacy data directly (for migration period)
            if let legacyService = loadLegacyService() {
                return legacyService
            }
        }
        
        return EmergencyServiceDatabase.shared.defaultService
    }
    
    /// Loads legacy service data (without HMAC) for backward compatibility
    private func loadLegacyService() -> EmergencyService? {
        guard let data = AppGroup.userDefaults.data(forKey: "cachedEmergencyService") else {
            return nil
        }
        
        do {
            let service = try JSONDecoder().decode(EmergencyService.self, from: data)
            
            // Validate the legacy data
            guard validateLoadedService(service) else {
                return nil
            }
            
            return service
        } catch {
            return nil
        }
    }
    
    /// Validates loaded emergency service data
    /// OWASP MASVS: PLATFORM-1, RESILIENCE-2
    private func validateLoadedService(_ service: EmergencyService) -> Bool {
        // Validate country code format
        guard EmergencyService.isValidCountryCode(service.countryCode) else {
            return false
        }
        
        // Validate emergency number
        guard EmergencyService.isValidPhoneNumber(service.emergencyNumber) else {
            return false
        }
        
        // Validate optional numbers if present
        if let police = service.policeNumber, !EmergencyService.isValidPhoneNumber(police) {
            return false
        }
        
        if let ambulance = service.ambulanceNumber, !EmergencyService.isValidPhoneNumber(ambulance) {
            return false
        }
        
        if let fire = service.fireNumber, !EmergencyService.isValidPhoneNumber(fire) {
            return false
        }
        
        return true
    }
}

// MARK: - Widget Views

struct SafeDialWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: EmergencyEntry
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .accessoryCircular:
            AccessoryCircularView(entry: entry)
        case .accessoryRectangular:
            AccessoryRectangularView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Small Widget View

struct SmallWidgetView: View {
    var entry: EmergencyEntry
    
    var body: some View {
        VStack(spacing: 8) {
            // Flag and country name
            HStack {
                Text(entry.service.flag)
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.service.countryName)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Text(entry.service.countryCode.uppercased())
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            Spacer()
            
            // Emergency number
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption2)
                        .foregroundStyle(.red)
                    
                    Text(LocalizedStrings.translate(.emergency, locale: entry.locale))
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
                
                Text(entry.service.emergencyNumber)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.red.gradient)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(14)
        .widgetURL(WidgetURLBuilder.buildURL(for: entry.service))
    }
}

// MARK: - Medium Widget View

struct MediumWidgetView: View {
    var entry: EmergencyEntry
    
    var body: some View {
        HStack(spacing: 0) {
            // Left section - Country Info with Flag
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.service.flag)
                    .font(.system(size: 60))
                
                Text(entry.service.countryName)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                Text(entry.service.countryCode.uppercased())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            // Right section - Emergency Numbers
            VStack(alignment: .leading, spacing: 8) {
                WidgetNumberRow(
                    label: LocalizedStrings.translate(.emergency, locale: entry.locale),
                    number: entry.service.emergencyNumber,
                    color: .red,
                    isPrimary: true
                )
                
                if let ambulance = entry.service.ambulanceNumber, ambulance != entry.service.emergencyNumber {
                    WidgetNumberRow(
                        label: LocalizedStrings.translate(.ambulance, locale: entry.locale),
                        number: ambulance,
                        color: .green,
                        isPrimary: false
                    )
                }
                
                if let fire = entry.service.fireNumber, fire != entry.service.emergencyNumber {
                    WidgetNumberRow(
                        label: LocalizedStrings.translate(.fire, locale: entry.locale),
                        number: fire,
                        color: .orange,
                        isPrimary: false
                    )
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .widgetURL(WidgetURLBuilder.buildURL(for: entry.service))
    }
}

// MARK: - Number Row Helper

struct WidgetNumberRow: View {
    let label: String
    let number: String
    let color: Color
    let isPrimary: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                
                Text(number)
                    .font(isPrimary ? .title3 : .headline)
                    .fontWeight(.bold)
                    .foregroundStyle(color.gradient)
            }
        }
    }
}

// MARK: - Accessory Circular View

struct AccessoryCircularView: View {
    var entry: EmergencyEntry

    var body: some View {
        VStack(spacing: 1) {
            Image(systemName: "phone.fill")
                .font(.system(size: 22, weight: .bold))
                .widgetAccentable()

            Text(entry.service.emergencyNumber)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        .widgetURL(WidgetURLBuilder.buildURL(for: entry.service))
    }
}

// MARK: - Accessory Rectangular View

struct AccessoryRectangularView: View {
    var entry: EmergencyEntry
    
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.service.countryCode.uppercased())
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(entry.service.countryName)
                    .font(.caption2)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption)
                
                Text(entry.service.emergencyNumber)
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
        .widgetURL(WidgetURLBuilder.buildURL(for: entry.service))
        .environment(\.colorScheme, .light)
    }
}

// MARK: - Widget URL Builder with OWASP Validation

/// Builds validated widget URLs with security checks
/// OWASP MASVS: PLATFORM-2, RESILIENCE-2
enum WidgetURLBuilder {
    static func buildURL(for service: EmergencyService) -> URL {
        // Validate service data before building URL
        guard EmergencyService.isValidCountryCode(service.countryCode) else {
            return fallbackURL()
        }
        
        guard EmergencyService.isValidPhoneNumber(service.emergencyNumber) else {
            return fallbackURL()
        }
        
        // Sanitize values for URL safety
        let sanitizedCountry = service.countryCode.uppercased()
        let sanitizedNumber = EmergencyService.sanitizePhoneNumber(service.emergencyNumber)
        
        // Build URL with validated components
        let urlString = "safedial://widget-tapped?country=\(sanitizedCountry)&number=\(sanitizedNumber)"
        
        guard let url = URL(string: urlString) else {
            return fallbackURL()
        }
        
        return url
    }
    
    /// Fallback URL if validation fails
    private static func fallbackURL() -> URL {
        // Return a safe no-op URL that uses EU standard 112
        return URL(string: "safedial://widget-tapped?country=EU&number=112")!
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    SafeDialWidget()
} timeline: {
    EmergencyEntry(
        date: Date.now,
        service: EmergencyService(
            countryCode: "US",
            countryName: "United States",
            emergencyNumber: "911",
            policeNumber: "911",
            ambulanceNumber: "911",
            fireNumber: "911"
        ),
        locale: Locale(identifier: "en-US")
    )
}

#Preview(as: .systemMedium) {
    SafeDialWidget()
} timeline: {
    EmergencyEntry(
        date: Date.now,
        service: EmergencyService(
            countryCode: "FR",
            countryName: "France",
            emergencyNumber: "112",
            policeNumber: "17",
            ambulanceNumber: "15",
            fireNumber: "18"
        ),
        locale: Locale(identifier: "fr-FR")
    )
}
