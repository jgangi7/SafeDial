//
//  ContentView.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import SwiftUI
internal import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager.shared
    @State private var selectedService: EmergencyService?
    @State private var showingCountryPicker = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let service = selectedService {
                        VStack(spacing: 16) {
                            // Location Status Indicator
                            if locationManager.isLoading {
                                HStack {
                                    ProgressView()
                                        .padding(.trailing, 8)
                                    Text("Detecting your location...")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                            }
                            
                            // Current Location
                            VStack(spacing: 8) {
                                Label("Selected Country", systemImage: "mappin.circle.fill")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                
                                Text(service.countryName)
                                    .font(.title2)
                                    .bold()
                                
                                Text(service.countryCode)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Button {
                                    showingCountryPicker = true
                                } label: {
                                    Label("Change Country", systemImage: "globe")
                                        .font(.subheadline)
                                }
                                .buttonStyle(.bordered)
                                .padding(.top, 4)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            
                            // Primary Emergency Number
                            EmergencyNumberCard(
                                title: "Emergency Services",
                                number: service.emergencyNumber,
                                icon: "exclamationmark.triangle.fill",
                                color: .red,
                                isPrimary: true
                            )
                            
                            // Specific Services
                            if let policeNumber = service.policeNumber, policeNumber != service.emergencyNumber {
                                EmergencyNumberCard(
                                    title: "Police",
                                    number: policeNumber,
                                    icon: "shield.fill",
                                    color: .blue,
                                    isPrimary: false
                                )
                            }
                            
                            if let ambulanceNumber = service.ambulanceNumber, ambulanceNumber != service.emergencyNumber {
                                EmergencyNumberCard(
                                    title: "Ambulance",
                                    number: ambulanceNumber,
                                    icon: "cross.fill",
                                    color: .green,
                                    isPrimary: false
                                )
                            }
                            
                            if let fireNumber = service.fireNumber, fireNumber != service.emergencyNumber {
                                EmergencyNumberCard(
                                    title: "Fire",
                                    number: fireNumber,
                                    icon: "flame.fill",
                                    color: .orange,
                                    isPrimary: false
                                )
                            }
                        }
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "globe")
                                .font(.system(size: 60))
                                .foregroundStyle(.secondary)
                            
                            Text("No country selected")
                                .font(.headline)
                            
                            Text("Please select your country to view emergency service numbers.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button("Select Country") {
                                showingCountryPicker = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                    
                    // Info Section
                    VStack(alignment: .leading, spacing: 12) {
                        Label("How to use", systemImage: "info.circle.fill")
                            .font(.headline)
                        
                        Text("Add the SafeDial widget to your Lock Screen or Home Screen for instant access to emergency numbers for your selected country.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("Tap the widget to immediately dial emergency services.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
                .padding()
            }
            .navigationTitle("SafeDial")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingCountryPicker = true
                    } label: {
                        Image(systemName: "globe")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button {
                            print("🔄 Manual location refresh requested")
                            locationManager.updateLocation()
                        } label: {
                            Label("Update Location", systemImage: "location.fill")
                        }
                        
                        Button {
                            print("🔍 Debug: Testing widget data read...")
                            if let data = UserDefaults.appGroup.data(forKey: "cachedEmergencyService"),
                               let service = try? JSONDecoder().decode(EmergencyService.self, from: data) {
                                print("✅ Debug: Widget CAN read: \(service.countryName) (\(service.countryCode))")
                            } else {
                                print("🔴 Debug: Widget CANNOT read data!")
                            }
                            
                            print("🔄 Debug: Forcing widget reload...")
                            WidgetUpdateManager.reloadAllWidgets()
                        } label: {
                            Label("Test Widget Sync", systemImage: "arrow.triangle.2.circlepath")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .onAppear {
            print("🔵 ContentView: onAppear called")
            loadSavedService()
            
            // Check authorization status and request if needed
            print("🔵 ContentView: Checking location authorization status: \(locationManager.authorizationStatus.rawValue)")
            switch locationManager.authorizationStatus {
            case .notDetermined:
                print("🔵 ContentView: Location not determined, requesting authorization...")
                locationManager.requestAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                print("🔵 ContentView: Location authorized, updating location...")
                locationManager.updateLocation()
            case .denied, .restricted:
                print("🔴 ContentView: Location access denied or restricted")
            @unknown default:
                print("🔴 ContentView: Unknown authorization status")
            }
        }
        .onChange(of: selectedService) { oldValue, newValue in
            print("🟢 ContentView: selectedService changed from \(oldValue?.countryCode ?? "nil") to \(newValue?.countryCode ?? "nil")")
            
            if let service = newValue {
                print("🟡 ContentView: Saving service for \(service.countryName) (\(service.countryCode))")
                saveService(service)
                print("✅ ContentView: Save completed")
            } else {
                print("🔴 ContentView: selectedService is nil, not saving")
            }
        }
        .onChange(of: locationManager.currentEmergencyService) { oldValue, newValue in
            print("📍 ContentView: LocationManager emergency service changed")
            if let service = newValue {
                print("📍 ContentView: Location detected \(service.countryName) (\(service.countryCode))")
                // Only auto-update if user hasn't manually selected a country yet
                if selectedService == nil {
                    print("📍 ContentView: Auto-selecting location-based service")
                    selectedService = service
                } else {
                    print("📍 ContentView: User has manual selection, not overriding")
                }
            }
        }
        .sheet(isPresented: $showingCountryPicker) {
            ManualCountryPickerView(selectedService: $selectedService)
        }
    }
    
    private func loadSavedService() {
        print("🔵 loadSavedService: Attempting to load cached service...")
        
        // Try loading from UserDefaults
        if let data = UserDefaults.appGroup.data(forKey: "cachedEmergencyService") {
            print("🟢 loadSavedService: Found cached data, attempting to decode...")
            
            if let service = try? JSONDecoder().decode(EmergencyService.self, from: data) {
                print("✅ loadSavedService: Successfully loaded \(service.countryName) (\(service.countryCode))")
                selectedService = service
            } else {
                print("🔴 loadSavedService: Failed to decode cached data")
            }
        } else {
            print("🟡 loadSavedService: No cached service found")
        }
    }
    
    private func saveService(_ service: EmergencyService) {
        print("💾 saveService: Encoding service for \(service.countryName)...")
        
        if let data = try? JSONEncoder().encode(service) {
            print("💾 saveService: Successfully encoded, saving to UserDefaults...")
            UserDefaults.appGroup.set(data, forKey: "cachedEmergencyService")
            
            // Verify the save
            if let verifyData = UserDefaults.appGroup.data(forKey: "cachedEmergencyService") {
                print("✅ saveService: Verified data was saved (\(verifyData.count) bytes)")
            } else {
                print("🔴 saveService: Failed to verify saved data!")
            }
            
            print("🔄 saveService: Reloading widget...")
            WidgetUpdateManager.reloadEmergencyWidget()
            print("✅ saveService: Widget reload requested")
        } else {
            print("🔴 saveService: Failed to encode service")
        }
    }
}

struct EmergencyNumberCard: View {
    let title: String
    let number: String
    let icon: String
    let color: Color
    let isPrimary: Bool
    
    var body: some View {
        Button {
            if let url = URL(string: "tel://\(number)") {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.2), in: Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(isPrimary ? .headline : .subheadline)
                        .foregroundStyle(.primary)
                    
                    Text(number)
                        .font(isPrimary ? .title : .title3)
                        .bold()
                        .foregroundStyle(color)
                }
                
                Spacer()
                
                Image(systemName: "phone.fill")
                    .foregroundStyle(color)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isPrimary ? color.opacity(0.1) : Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(color.opacity(isPrimary ? 0.3 : 0.2), lineWidth: isPrimary ? 2 : 1)
            )
        }
    }
}

#Preview {
    ContentView()
}
