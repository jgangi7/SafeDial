import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager.shared
    @State private var selectedService: EmergencyService?
    @State private var showingCountryPicker = false
    
    var body: some View {
        ZStack {
            // Soft pastel gradient background (8k quality aesthetic)
            softPastelBackground
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                    if let service = selectedService {
                        // Smart Location Card
                        smartLocationCard(for: service)
                        
                        // Main emergency action cards
                        emergencyActionCards(for: service)
                    } else {
                        emptyStateView
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .ignoresSafeArea()
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
    
    /// Soft pastel gradient background for 8k aesthetic
    private var softPastelBackground: some View {
        LinearGradient(
            colors: [
                Color(red: 0.95, green: 0.93, blue: 0.98),  // Soft lavender
                Color(red: 0.93, green: 0.95, blue: 0.98),  // Soft sky blue
                Color(red: 0.98, green: 0.95, blue: 0.93)   // Soft peach
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Smart Location Card with glassmorphism and flag
    private func smartLocationCard(for service: EmergencyService) -> some View {
        VStack(spacing: 16) {
            // Title
            HStack {
                Image(systemName: "location.fill")
                    .font(.headline)
                    .foregroundStyle(.blue)
                
                Text("Location")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
            Divider()
                .background(.quaternary)
            
            // Flag, country info, and change button inline
            HStack(spacing: 16) {
                // High-resolution flag icon with country name stacked below
                VStack(spacing: 8) {
                    Text(service.flag)
                        .font(.system(size: 48))
                    
                    Text(service.smartLocationDisplay)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Change button - subtle grey pill inline
                Button {
                    showingCountryPicker = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.subheadline)
                        Text("Change")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color(.systemGray5))
                    )
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThickMaterial)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    /// Emergency Action Cards - Vertical stack with color-coded cards
    @ViewBuilder
    private func emergencyActionCards(for service: EmergencyService) -> some View {
        VStack(spacing: 16) {
            // Always show Emergency card
            GlassmorphismEmergencyCard(
                type: .emergency,
                service: service
            )
            
            // Show Police if different from emergency number
            if let police = service.policeNumber, police != service.emergencyNumber {
                GlassmorphismEmergencyCard(
                    type: .police,
                    service: service
                )
            }
            
            // Show Ambulance if different from emergency number
            if let ambulance = service.ambulanceNumber, ambulance != service.emergencyNumber {
                GlassmorphismEmergencyCard(
                    type: .ambulance,
                    service: service
                )
            }
            
            // Show Fire if different from emergency number
            if let fire = service.fireNumber, fire != service.emergencyNumber {
                GlassmorphismEmergencyCard(
                    type: .fire,
                    service: service
                )
            }
        }
    }
    
    /// Empty state when no country is selected
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "globe")
                .font(.system(size: 72))
                .foregroundStyle(.blue.gradient)
                .padding(.top, 60)
            
            VStack(spacing: 12) {
                Text("No Country Selected")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text("Select a country manually or enable location services to automatically detect your region.")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Button {
                showingCountryPicker = true
            } label: {
                HStack {
                    Image(systemName: "globe")
                    Text("Select Country")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(.blue.gradient)
                        .shadow(color: .blue.opacity(0.3), radius: 12, x: 0, y: 6)
                )
            }
            .padding(.top, 8)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThickMaterial)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
}

// MARK: - Glassmorphism Emergency Card

/// A sophisticated glassmorphism card with gradient background and haptic-ready call button
struct GlassmorphismEmergencyCard: View {
    let type: EmergencyServiceType
    let service: EmergencyService
    
    @State private var isPressed = false
    
    var body: some View {
        Button {
            makeCall()
        } label: {
            HStack(spacing: 20) {
                // Left side: Icon, label, and phone number
                VStack(alignment: .leading, spacing: 8) {
                    // Icon and title
                    HStack(spacing: 12) {
                        Image(systemName: type.icon)
                            .font(.title2)
                            .foregroundStyle(.white)
                        
                        Text(type.title)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    
                    // Large format phone number
                    if let number = type.number(from: service) {
                        Text(number)
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                }
                
                Spacer()
                
                // Right side: Circular call button
                callButton
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    // Gradient background
                    RoundedRectangle(cornerRadius: 28)
                        .fill(type.gradient)
                    
                    // Glassmorphism overlay
                    RoundedRectangle(cornerRadius: 28)
                        .fill(.ultraThinMaterial)
                        .opacity(0.3)
                    
                    // Inner glow (rim light)
                    RoundedRectangle(cornerRadius: 28)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.white.opacity(0.4), .white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            )
            .shadow(color: type.solidColor.opacity(0.25), radius: 16, x: 0, y: 8)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        // Haptic feedback
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
    
    /// Circular call button with phone glyph (60x60pt hit target)
    private var callButton: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.95))
                .frame(width: 60, height: 60)
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            
            Image(systemName: "phone.fill")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(type.solidColor)
        }
    }
    
    /// Makes a phone call to the emergency number
    private func makeCall() {
        guard let number = type.number(from: service),
              let url = URL(string: "tel://\(number)") else { return }
        
        // Haptic feedback before call
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.warning)
        
        UIApplication.shared.open(url)
    }
}
