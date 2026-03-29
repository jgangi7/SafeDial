import SwiftUI
import WidgetKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager.shared
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @State private var selectedService: EmergencyService?
    @State private var showingCountryPicker = false
    @State private var showingLanguagePicker = false
    
    // Disclaimer
    @AppStorage("hasSeenDisclaimer") private var hasSeenDisclaimer = false
    @State private var showingDisclaimer = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.tcSurface.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        if let service = selectedService {
                            smartLocationCard(for: service)
                            emergencyActionCards(for: service)
                        } else {
                            emptyStateView
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 100)
                    .padding(.bottom, 24)
                }
            }
            .ignoresSafeArea()
        }
        .preferredColorScheme(.light)
        .onAppear {
            // Check if user has seen disclaimer
            if !hasSeenDisclaimer {
                showingDisclaimer = true
            }

            // Simply use what the manager already loaded from disk
            self.selectedService = locationManager.currentEmergencyService

            // Sync widget with current selection on every app launch
            WidgetCenter.shared.reloadAllTimelines()
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
        .sheet(isPresented: $showingLanguagePicker) {
            LanguagePickerView()
        }
        .sheet(isPresented: $showingDisclaimer) {
            DisclaimerView(hasSeenDisclaimer: $hasSeenDisclaimer, showingDisclaimer: $showingDisclaimer)
                .interactiveDismissDisabled()
        }
    }
    
    // MARK: - Subviews

    /// Location card — Tactical Calm tonal surface, no glassmorphism
    private func smartLocationCard(for service: EmergencyService) -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "location.fill")
                    .font(.subheadline)
                    .foregroundStyle(Color.tcSecondary)

                LocalizedText(.location)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.tcOnSurfaceVariant)

                Spacer()

                Button {
                    showingLanguagePicker = true
                } label: {
                    Image(systemName: "translate")
                        .font(.subheadline)
                        .foregroundStyle(Color.tcSecondary)
                        .padding(8)
                        .background(Circle().fill(Color.tcSurfaceContainerHigh))
                }
                .accessibilityLabel(localizationManager.localize(.selectLanguage))
            }

            HStack(spacing: 16) {
                VStack(spacing: 6) {
                    Text(service.flag)
                        .font(.system(size: 48))

                    Text(service.smartLocationDisplay)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.tcOnSurface)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                Button {
                    showingCountryPicker = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.caption)
                        LocalizedText(.change)
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(Color.tcOnSurfaceVariant)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .background(Capsule().fill(Color.tcSurfaceContainerHigh))
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.tcSurfaceContainer)
                .shadow(color: Color.tcOnSurface.opacity(0.06), radius: 24, x: 0, y: 8)
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
    
    /// Empty state — Tactical Calm: tonal surface, red gradient CTA
    private var emptyStateView: some View {
        VStack(spacing: 0) {
            // Translate / language button top-right
            HStack {
                Spacer()
                Button {
                    showingLanguagePicker = true
                } label: {
                    Image(systemName: "translate")
                        .font(.subheadline)
                        .foregroundStyle(Color.tcOnSurfaceVariant)
                        .padding(10)
                        .background(Circle().fill(Color.tcSurfaceContainerHigh))
                }
                .accessibilityLabel(localizationManager.localize(.selectLanguage))
            }
            .padding(.bottom, 32)

            // Globe icon with secondary blue gradient
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.tcSecondary, Color.tcSecondaryContainer],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 96, height: 96)
                    .shadow(color: Color.tcOnSurface.opacity(0.06), radius: 24, x: 0, y: 8)

                Image(systemName: "globe")
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 28)

            // Headline — asymmetric left margin per editorial style
            LocalizedText(.noCountrySelected)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.tcOnSurface)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 4)
                .padding(.bottom, 12)

            LocalizedText(.noCountryMessage)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.tcOnSurfaceVariant)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 4)
                .padding(.bottom, 32)

            // Primary CTA — red gradient, large touch target
            Button {
                showingCountryPicker = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "globe")
                        .font(.system(size: 17, weight: .semibold))
                    LocalizedText(.selectCountry)
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Color.tcPrimary, Color.tcPrimaryContainer],
                                startPoint: UnitPoint(x: 0.15, y: 0),
                                endPoint: UnitPoint(x: 0.85, y: 1)
                            )
                        )
                        .shadow(color: Color.tcOnSurface.opacity(0.06), radius: 24, x: 0, y: 12)
                )
            }
            .padding(.bottom, 16)

            // Privacy reassurance
            HStack(spacing: 6) {
                Image(systemName: "lock.fill")
                    .font(.caption2)
                Text(localizationManager.localize(.locationPrivacy))
                    .font(.system(size: 12))
            }
            .foregroundStyle(Color.tcOutline)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.tcSurfaceContainer)
                .shadow(color: Color.tcOnSurface.opacity(0.06), radius: 24, x: 0, y: 8)
        )
    }
}

// MARK: - Glassmorphism Emergency Card

/// A sophisticated glassmorphism card with gradient background and haptic-ready call button
struct GlassmorphismEmergencyCard: View {
    let type: EmergencyServiceType
    let service: EmergencyService
    
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @State private var isPressed = false
    @State private var alertMessage: String? = nil
    @State private var showingCallConfirmation = false
    @State private var pendingDialURL: URL? = nil
    @State private var pendingDialNumber: String = ""
    
    private var localizedTitle: String {
        switch type {
        case .emergency:
            return localizationManager.localize(.emergency)
        case .police:
            return localizationManager.localize(.police)
        case .ambulance:
            return localizationManager.localize(.ambulance)
        case .fire:
            return localizationManager.localize(.fire)
        }
    }

    private var localizedCallAction: String {
        switch type {
        case .emergency: return localizationManager.localize(.callEmergency)
        case .police:    return localizationManager.localize(.callPolice)
        case .ambulance: return localizationManager.localize(.callAmbulance)
        case .fire:      return localizationManager.localize(.callFire)
        }
    }
    
    var body: some View {
        Button {
            prepareCall()
        } label: {
            HStack(spacing: 20) {
                // Left: icon, label, phone number
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 10) {
                        Image(systemName: type.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)

                        Text(localizedTitle)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                    }

                    if let number = type.number(from: service) {
                        Text(number)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.white)
                            .tracking(-0.5)
                    }
                }

                Spacer()

                callButton
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(type.gradient)
                    .shadow(color: Color.tcOnSurface.opacity(0.06), radius: 24, x: 0, y: 12)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .confirmationDialog(
            "\(localizedTitle) · \(service.countryName)",
            isPresented: $showingCallConfirmation,
            titleVisibility: .visible
        ) {
            Button("📞  \(pendingDialNumber)") {
                guard let url = pendingDialURL else { return }
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.warning)
                UIApplication.shared.open(url)
            }
            Button(localizationManager.localize(.cancel), role: .cancel) {}
        }
        .alert(localizationManager.localize(.securityAlert), isPresented: Binding(
            get: { alertMessage != nil },
            set: { if !$0 { alertMessage = nil } }
        )) {
            Button(localizationManager.localize(.done), role: .cancel) { alertMessage = nil }
        } message: {
            Text(alertMessage ?? "")
        }
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
    
    /// Circular call button — white well, service-colored icon
    private var callButton: some View {
        ZStack {
            Circle()
                .fill(Color.tcSurfaceContainerLowest)
                .frame(width: 60, height: 60)
                .shadow(color: Color.tcOnSurface.opacity(0.1), radius: 8, x: 0, y: 4)

            Image(systemName: "phone.fill")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(type.solidColor)
        }
    }
    
    /// Validates the number and shows a confirmation alert with the exact digits before dialing.
    /// iOS's phone confirmation dialog may reformat short numbers (e.g. "190" → "1 (90)"),
    /// so we show our own alert first so the user always sees the correct number.
    /// OWASP MASVS: PLATFORM-1, CODE-1, RESILIENCE-2
    private func prepareCall() {
        guard let number = type.number(from: service) else { return }

        let manager = LocalizationManager.shared

        // OWASP MASVS: CODE-1 - Sanitize phone number
        let sanitizedNumber = EmergencyService.sanitizePhoneNumber(number)

        // OWASP MASVS: PLATFORM-1 - Validate phone number format
        guard EmergencyService.isValidPhoneNumber(sanitizedNumber) else {
            showSecurityAlert(message: manager.localize(.invalidPhoneNumber))
            return
        }

        // OWASP MASVS: RESILIENCE-2 - Cross-validate with database
        guard validateNumberAgainstDatabase(number: sanitizedNumber) else {
            showSecurityAlert(message: manager.localize(.validationFailed))
            return
        }

        // OWASP MASVS: PLATFORM-1 - Validate URL construction
        // Use "tel:" (not "tel://") for proper emergency number dialing
        // Emergency numbers are local-only — do not prepend international dialing code
        guard let url = URL(string: "tel:\(sanitizedNumber)"),
              UIApplication.shared.canOpenURL(url) else {
            showSecurityAlert(message: manager.localize(.unableToMakeCall))
            return
        }

        // All checks passed — show our confirmation so the user sees the correct number
        // before iOS's phone dialog (which may misformat short numbers like "190" as "1 (90)")
        pendingDialNumber = sanitizedNumber
        pendingDialURL = url
        showingCallConfirmation = true
    }
    
    /// Cross-validates phone number against emergency service database
    /// OWASP MASVS: RESILIENCE-2
    private func validateNumberAgainstDatabase(number: String) -> Bool {
        let validNumbers = [
            service.emergencyNumber,
            service.policeNumber,
            service.ambulanceNumber,
            service.fireNumber
        ].compactMap { $0 }
        
        return validNumbers.contains(number)
    }
    
    /// Shows security alert to user
    private func showSecurityAlert(message: String) {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.error)
        alertMessage = message
    }
}
