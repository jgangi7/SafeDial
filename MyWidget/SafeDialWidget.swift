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
                .containerBackground(Color.clear, for: .widget)
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
}

// MARK: - Timeline Provider

struct EmergencyServiceProvider: TimelineProvider {
    typealias Entry = EmergencyEntry

    func placeholder(in context: Context) -> EmergencyEntry {
        print("📱 EmergencyServiceProvider: placeholder requested")
        // Use the actual cached service for placeholder as well
        let service = loadCachedService()
        print("📱 EmergencyServiceProvider: placeholder using service for \(service.countryName)")
        print("   🌍 Country: \(service.countryName) (\(service.countryCode))")
        print("   🚨 Emergency Number: \(service.emergencyNumber)")
        if let police = service.policeNumber {
            print("   👮 Police: \(police)")
        }
        if let ambulance = service.ambulanceNumber {
            print("   🚑 Ambulance: \(ambulance)")
        }
        if let fire = service.fireNumber {
            print("   🚒 Fire: \(fire)")
        }
        return EmergencyEntry(date: Date(), service: service)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (EmergencyEntry) -> Void) {
        print("📱 EmergencyServiceProvider: snapshot requested (isPreview: \(context.isPreview))")
        let service = loadCachedService()
        let entry = EmergencyEntry(date: Date(), service: service)
        print("📱 EmergencyServiceProvider: snapshot using service for \(service.countryName)")
        print("   🌍 Country: \(service.countryName) (\(service.countryCode))")
        print("   🚨 Emergency Number: \(service.emergencyNumber)")
        if let police = service.policeNumber {
            print("   👮 Police: \(police)")
        }
        if let ambulance = service.ambulanceNumber {
            print("   🚑 Ambulance: \(ambulance)")
        }
        if let fire = service.fireNumber {
            print("   🚒 Fire: \(fire)")
        }
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<EmergencyEntry>) -> Void) {
        print("📱 EmergencyServiceProvider: timeline requested")
        let currentDate = Date()
        let service = loadCachedService()
        let entry = EmergencyEntry(date: currentDate, service: service)
        
        print("📱 EmergencyServiceProvider: timeline using service for \(service.countryName)")
        print("   🌍 Country: \(service.countryName) (\(service.countryCode))")
        print("   🚨 Emergency Number: \(service.emergencyNumber)")
        if let police = service.policeNumber {
            print("   👮 Police: \(police)")
        }
        if let ambulance = service.ambulanceNumber {
            print("   🚑 Ambulance: \(ambulance)")
        }
        if let fire = service.fireNumber {
            print("   🚒 Fire: \(fire)")
        }
        
        // Reload more frequently to pick up changes from the app
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        print("📱 EmergencyServiceProvider: timeline created, next update at \(nextUpdate)")
        completion(timeline)
    }
    
    private func loadCachedService() -> EmergencyService {
        // Explicitly using the string here to bypass any potential enum issues
        let sharedDefaults = UserDefaults(suiteName: "group.com.jimmygangi.emergencyroute")
        
        if let data = sharedDefaults?.data(forKey: "cachedEmergencyService") {
            do {
                let service = try JSONDecoder().decode(EmergencyService.self, from: data)
                print("✅ WIDGET: FOUND DATA for \(service.countryName)")
                return service
            } catch {
                print("❌ WIDGET: Data found but decode failed: \(error)")
            }
        } else {
            print("❌ WIDGET: Absolutely no data at the shared path.")
            // Debug: Let's see if standard defaults has it (it shouldn't, but good for testing)
            if UserDefaults.standard.data(forKey: "cachedEmergencyService") != nil {
                print("⚠️ WIDGET: Data exists in STANDARD defaults, not SHARED. App Group is not linked.")
            }
        }
        
        return EmergencyServiceDatabase.shared.defaultService
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
            // Country badge
            HStack {
                Text(entry.service.countryCode.uppercased())
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(.blue.opacity(0.15))
                    )
                Spacer()
            }
            
            Text(entry.service.countryName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            // Emergency number
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption2)
                        .foregroundStyle(.red)
                    
                    Text("Emergency")
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
        .widgetURL(URL(string: "safedial://widget-tapped?country=\(entry.service.countryCode)&number=\(entry.service.emergencyNumber)")!)
        .onAppear {
            print("🖼️ SmallWidgetView: Displayed")
            print("   🌍 Showing: \(entry.service.countryName) (\(entry.service.countryCode))")
            print("   🚨 Emergency: \(entry.service.emergencyNumber)")
        }
    }
}

// MARK: - Medium Widget View

struct MediumWidgetView: View {
    var entry: EmergencyEntry
    
    var body: some View {
        HStack(spacing: 0) {
            // Left section - Country Info
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.service.countryCode.uppercased())
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(.primary)
                
                Text(entry.service.countryName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                Spacer()
                
                Image(systemName: "mappin.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.blue.gradient)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color(.secondarySystemGroupedBackground))
            
            // Right section - Emergency Numbers
            VStack(alignment: .leading, spacing: 8) {
                WidgetNumberRow(
                    label: "Emer...",
                    number: entry.service.emergencyNumber,
                    color: .red,
                    isPrimary: true
                )
                
                if let ambulance = entry.service.ambulanceNumber, ambulance != entry.service.emergencyNumber {
                    WidgetNumberRow(
                        label: "Ambula...",
                        number: ambulance,
                        color: .green,
                        isPrimary: false
                    )
                }
                
                if let fire = entry.service.fireNumber, fire != entry.service.emergencyNumber {
                    WidgetNumberRow(
                        label: "Fire",
                        number: fire,
                        color: .orange,
                        isPrimary: false
                    )
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .widgetURL(URL(string: "safedial://widget-tapped?country=\(entry.service.countryCode)&number=\(entry.service.emergencyNumber)")!)
        .onAppear {
            print("🖼️ MediumWidgetView: Displayed")
            print("   🌍 Showing: \(entry.service.countryName) (\(entry.service.countryCode))")
            print("   🚨 Emergency: \(entry.service.emergencyNumber)")
            if let police = entry.service.policeNumber {
                print("   👮 Police: \(police)")
            }
            if let ambulance = entry.service.ambulanceNumber {
                print("   🚑 Ambulance: \(ambulance)")
            }
            if let fire = entry.service.fireNumber {
                print("   🚒 Fire: \(fire)")
            }
        }
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
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 2) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption2)
                
                Text(entry.service.emergencyNumber)
                    .font(.caption)
                    .fontWeight(.bold)
            }
        }
        .widgetURL(URL(string: "safedial://widget-tapped?country=\(entry.service.countryCode)&number=\(entry.service.emergencyNumber)")!)
        .onAppear {
            print("🖼️ AccessoryCircularView: Displayed")
            print("   🌍 Showing: \(entry.service.countryName) (\(entry.service.countryCode))")
            print("   🚨 Emergency: \(entry.service.emergencyNumber)")
        }
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
        .widgetURL(URL(string: "safedial://widget-tapped?country=\(entry.service.countryCode)&number=\(entry.service.emergencyNumber)")!)
        .onAppear {
            print("🖼️ AccessoryRectangularView: Displayed")
            print("   🌍 Showing: \(entry.service.countryName) (\(entry.service.countryCode))")
            print("   🚨 Emergency: \(entry.service.emergencyNumber)")
        }
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
        )
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
        )
    )
}
