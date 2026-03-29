//
//  DisclaimerView.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/29/26.
//

import SwiftUI

struct DisclaimerView: View {
    @Binding var hasSeenDisclaimer: Bool
    @Binding var showingDisclaimer: Bool
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        ZStack {
            Color.tcSurface.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Warning Icon
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.tcPrimary, Color.tcPrimaryContainer],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .padding(.bottom, 8)
                
                // Title
                Text("Important Notice")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.tcOnSurface)
                    .multilineTextAlignment(.center)
                
                // Disclaimer Points
                VStack(spacing: 16) {
                    disclaimerText("SafeDial provides emergency numbers for informational purposes only.")
                    disclaimerText("Always verify emergency numbers with local authorities in your area.")
                    disclaimerText("This app will actually dial emergency services when you tap to call. Use with caution during testing.")
                    disclaimerText("Your location is used only to detect your country and is never shared with third parties or servers.")
                    disclaimerText("Emergency numbers are stored locally on your device for offline access.")
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Accept Button
                Button {
                    // Haptic feedback
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    
                    hasSeenDisclaimer = true
                    showingDisclaimer = false
                } label: {
                    Text("I Understand")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
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
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .preferredColorScheme(.light)
    }
    
    private func disclaimerText(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.body)
                .foregroundStyle(Color.tcSecondary)
                .offset(y: 2)
            
            Text(text)
                .font(.system(size: 15))
                .foregroundStyle(Color.tcOnSurfaceVariant)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    DisclaimerView(
        hasSeenDisclaimer: .constant(false),
        showingDisclaimer: .constant(true)
    )
}
