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
        print("📦 loadCachedService: Loading from App Group UserDefaults...")
        
        // Load from App Group UserDefaults - this is synced from the main app
        if let data = UserDefaults.appGroup.data(forKey: "cachedEmergencyService"),
           let service = try? JSONDecoder().decode(EmergencyService.self, from: data) {
            print("✅ loadCachedService: Successfully loaded \(service.countryName) (\(service.countryCode))")
            return service
        }
        
        print("🟡 loadCachedService: No cached service found, using default")
        
        // If no service is saved yet, return a default service with a clear message
        return EmergencyService(
            countryCode: "—",
            countryName: "No Country Selected",
            emergencyNumber: "112",
            policeNumber: nil,
            ambulanceNumber: nil,
            fireNumber: nil
        )
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
            Text(entry.service.countryCode)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(entry.service.countryName)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            
            Divider()
            
            VStack(spacing: 4) {
                Text("Emergency")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(entry.service.emergencyNumber)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
            }
        }
        .padding()
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
        HStack(spacing: 16) {
            // Country Info
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.service.countryCode)
                    .font(.title)
                    .fontWeight(.bold)
                Text(entry.service.countryName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            // Emergency Numbers
            VStack(alignment: .leading, spacing: 8) {
                NumberRow(label: "Emergency", number: entry.service.emergencyNumber, color: .red)
                
                if let police = entry.service.policeNumber {
                    NumberRow(label: "Police", number: police, color: .blue)
                }
                
                if let ambulance = entry.service.ambulanceNumber {
                    NumberRow(label: "Ambulance", number: ambulance, color: .green)
                }
                
                if let fire = entry.service.fireNumber {
                    NumberRow(label: "Fire", number: fire, color: .orange)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
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

struct NumberRow: View {
    let label: String
    let number: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Spacer()
            Text(number)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(color)
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
                Text(entry.service.countryCode)
                    .font(.caption2)
                    .fontWeight(.bold)
                Text(entry.service.emergencyNumber)
                    .font(.caption)
                    .fontWeight(.semibold)
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
                Text(entry.service.countryCode)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(entry.service.countryName)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(entry.service.emergencyNumber)
                .font(.title3)
                .fontWeight(.bold)
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
