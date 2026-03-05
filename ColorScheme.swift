//
//  ColorScheme.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import SwiftUI

extension Color {
    // Custom color scheme
    static let honeydew = Color(hex: "f1faee")
    static let frostedBlue = Color(hex: "a8dadc")
    static let cerulean = Color(hex: "457b9d")
    static let oxfordNavy = Color(hex: "1d3557")
    
    // Semantic colors for the app
    static let appBackground = honeydew
    static let cardBackground = frostedBlue.opacity(0.3)
    static let primaryAccent = cerulean
    static let secondaryAccent = oxfordNavy
    static let emergencyRed = Color(hex: "e63946")
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
