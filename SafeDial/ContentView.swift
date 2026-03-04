import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager.shared
    @State private var selectedService: EmergencyService?
    @State private var showingCountryPicker = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let service = selectedService {
                        // Status Indicator
                        if locationManager.isLoading {
                            HStack {
                                ProgressView().padding(.trailing, 8)
                                Text("Detecting location...").font(.subheadline)
                            }
                            .padding().frame(maxWidth: .infinity)
                            .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Button("Force Sync") {
                            let testService = EmergencyService(
                                countryCode: "BR",
                                countryName: "Brazil",
                                emergencyNumber: "190",
                                policeNumber: "190",
                                ambulanceNumber: "190",
                                fireNumber: "190"
                                
                            )
                            LocationManager.shared.cacheEmergencyService(testService)
                        }
                        
                        // Header Card
                        VStack(spacing: 8) {
                            Label("Current Region", systemImage: "mappin.circle.fill")
                                .foregroundStyle(.secondary)
                            Text(service.countryName).font(.title2).bold()
                            
                            Button { showingCountryPicker = true } label: {
                                Label("Change Country", systemImage: "globe")
                            }.buttonStyle(.bordered).padding(.top, 4)
                        }
                        .padding().frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        
                        // Emergency Cards
                        EmergencyNumberCard(title: "Emergency", number: service.emergencyNumber, icon: "exclamationmark.triangle.fill", color: .red, isPrimary: true)
                        
                        if let police = service.policeNumber, police != service.emergencyNumber {
                            EmergencyNumberCard(title: "Police", number: police, icon: "shield.fill", color: .blue, isPrimary: false)
                        }
                        
                        if let ambulance = service.ambulanceNumber, ambulance != service.emergencyNumber {
                            EmergencyNumberCard(title: "Ambulance", number: ambulance, icon: "cross.fill", color: .green, isPrimary: false)
                        }
                    } else {
                        ContentUnavailableView("No country selected", systemImage: "globe", description: Text("Select a country manually or use GPS."))
                    }
                }
                .padding()
            }
            .navigationTitle("SafeDial")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { locationManager.updateLocation() } label: {
                        Image(systemName: "location.circle")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingCountryPicker = true } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
        .onAppear {
            // Simply use what the manager already loaded from disk
            self.selectedService = locationManager.currentEmergencyService
        }
        .onChange(of: locationManager.currentEmergencyService) { _, newValue in
            // Update view when GPS finds something new
            if let newValue { self.selectedService = newValue }
        }
        .onChange(of: selectedService) { _, newValue in
            // Save to disk when user picks manually
            if let newValue { locationManager.cacheEmergencyService(newValue) }
        }
        .sheet(isPresented: $showingCountryPicker) {
            ManualCountryPickerView(selectedService: $selectedService)
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
            .background(isPrimary ? color.opacity(0.1) : Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(color.opacity(isPrimary ? 0.3 : 0.2), lineWidth: isPrimary ? 2 : 1)
            )
        }
    }
}
