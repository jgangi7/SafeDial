//
//  ColorScheme.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import SwiftUI

extension Color {
    // Tactical Calm — Surface Hierarchy
    static let tcSurface             = Color(hex: "f8f9fb")
    static let tcSurfaceContainer    = Color(hex: "eceef0")
    static let tcSurfaceContainerHigh = Color(hex: "e6e8ea")
    static let tcSurfaceContainerLowest = Color(hex: "ffffff")
    static let tcSurfaceDim          = Color(hex: "d8dadc")

    // Tactical Calm — Primary (Emergency Red)
    static let tcPrimary             = Color(hex: "89000e")
    static let tcPrimaryContainer    = Color(hex: "b1121b")

    // Tactical Calm — Secondary (Clinical Blue)
    static let tcSecondary           = Color(hex: "115cb9")
    static let tcSecondaryContainer  = Color(hex: "659dfe")

    // Tactical Calm — Tertiary (Amber/Fire)
    static let tcTertiary            = Color(hex: "722b00")
    static let tcTertiaryContainer   = Color(hex: "983c00")

    // Tactical Calm — Text & Outline
    static let tcOnSurface           = Color(hex: "191c1e")
    static let tcOnSurfaceVariant    = Color(hex: "424752")
    static let tcOutline             = Color(hex: "727784")

    // Legacy aliases — updated to Tactical Calm values
    static let honeydew      = tcSurface
    static let cerulean      = tcSecondary
    static let oxfordNavy    = tcOnSurface
    static let emergencyRed  = tcPrimary
    static let appBackground = tcSurface
    static let cardBackground = tcSurfaceContainer
    static let primaryAccent = tcSecondary
    static let secondaryAccent = tcOnSurface
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
