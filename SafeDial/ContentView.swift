import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager.shared
    @State private var selectedService: EmergencyService?
    @State private var showingCountryPicker = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                ScrollView {
                    VStack(spacing: 20) {
                        if let service = selectedService {
                            serviceContentView(for: service)
                        } else {
                            emptyStateView
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("SafeDial")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("SafeDial")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
            }
        }
        .tint(.blue)
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
    
    // MARK: - Subviews
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [Color(.systemBackground), Color(.systemGroupedBackground)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .font(.system(size: 64))
                .foregroundStyle(.blue.gradient)
                .padding(.top, 60)
            
            Text("No Country Selected")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text("Select a country manually or enable location services to automatically detect your region.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button {
                showingCountryPicker = true
            } label: {
                Label("Select Country", systemImage: "globe")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue.gradient)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 32)
            .padding(.top, 8)
        }
    }
    
    private var locationButton: some View {
        Button { locationManager.updateLocation() } label: {
            Image(systemName: "location.circle.fill")
                .foregroundStyle(.blue)
        }
    }
    
    private var menuButton: some View {
        Button { showingCountryPicker = true } label: {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .foregroundStyle(.blue)
        }
    }
    
    @ViewBuilder
    private func serviceContentView(for service: EmergencyService) -> some View {
        if locationManager.isLoading {
            loadingIndicator
        }
        
        headerCard(for: service)
        
        EmergencyNumberCard(
            title: "Emergency",
            number: service.emergencyNumber,
            icon: "exclamationmark.triangle.fill",
            color: .red,
            isPrimary: true
        )
        
        if let police = service.policeNumber, police != service.emergencyNumber {
            EmergencyNumberCard(
                title: "Police",
                number: police,
                icon: "shield.fill",
                color: .blue,
                isPrimary: false
            )
        }
        
        if let ambulance = service.ambulanceNumber, ambulance != service.emergencyNumber {
            EmergencyNumberCard(
                title: "Ambulance",
                number: ambulance,
                icon: "cross.case.fill",
                color: .green,
                isPrimary: false
            )
        }
        
        if let fire = service.fireNumber, fire != service.emergencyNumber {
            EmergencyNumberCard(
                title: "Fire",
                number: fire,
                icon: "flame.fill",
                color: .orange,
                isPrimary: false
            )
        }
    }
    
    private var loadingIndicator: some View {
        HStack(spacing: 12) {
            ProgressView()
                .tint(.blue)
            Text("Detecting location...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private func headerCard(for service: EmergencyService) -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.blue.gradient)
                Text("Current Location")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
            
            Text(service.countryName)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.primary)
            
            Text(service.countryCode.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(.blue.opacity(0.1))
                )
            
            Button { showingCountryPicker = true } label: {
                Label("Change Country", systemImage: "arrow.triangle.2.circlepath")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.blue.opacity(0.1))
                    .foregroundStyle(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.top, 4)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
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
            VStack(spacing: 0) {
                // Top section with icon and title
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(color)
                        .frame(width: 32)
                    
                    Text(title)
                        .font(isPrimary ? .title3 : .headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 12)
                
                // Phone number - large and prominent
                HStack {
                    Text(number)
                        .font(isPrimary ? .system(size: 48, weight: .bold, design: .rounded) : .system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(color.gradient)
                    
                    Spacer()
                    
                    // Call button
                    ZStack {
                        Circle()
                            .fill(color.gradient)
                            .frame(width: isPrimary ? 64 : 56, height: isPrimary ? 64 : 56)
                            .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "phone.fill")
                            .font(isPrimary ? .title2 : .title3)
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: color.opacity(isPrimary ? 0.2 : 0.1), radius: isPrimary ? 12 : 8, x: 0, y: isPrimary ? 6 : 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        color.opacity(isPrimary ? 0.3 : 0.2),
                        lineWidth: isPrimary ? 2 : 1.5
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
