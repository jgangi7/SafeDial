//
//  EmergencyServiceType.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/5/26.
//

import SwiftUI

enum EmergencyServiceType {
    case emergency
    case police
    case ambulance
    case fire
    
    /// SF Symbol icon for each service type
    var icon: String {
        switch self {
        case .emergency:
            return "exclamationmark.triangle.fill"
        case .police:
            return "shield.fill"
        case .ambulance:
            return "cross.case.fill"
        case .fire:
            return "flame.fill"
        }
    }
    
    /// Display title for each service type
    var title: String {
        let manager = LocalizationManager.shared
        switch self {
        case .emergency:
            return manager.localize(.emergency)
        case .police:
            return manager.localize(.police)
        case .ambulance:
            return manager.localize(.ambulance)
        case .fire:
            return manager.localize(.fire)
        }
    }
    
    /// Gradient background for each service type (Tactical Calm palette, 135°)
    var gradient: LinearGradient {
        switch self {
        case .emergency:
            return LinearGradient(
                colors: [Color.tcPrimary, Color.tcPrimaryContainer],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .police:
            return LinearGradient(
                colors: [Color.tcSecondary, Color(hex: "0a4a9e")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .ambulance:
            return LinearGradient(
                colors: [Color(hex: "006a4e"), Color(hex: "004d38")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .fire:
            return LinearGradient(
                colors: [Color.tcTertiaryContainer, Color.tcTertiary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    /// Solid color for call button icon tint
    var solidColor: Color {
        switch self {
        case .emergency:  return Color.tcPrimary
        case .police:     return Color.tcSecondary
        case .ambulance:  return Color(hex: "006a4e")
        case .fire:       return Color.tcTertiaryContainer
        }
    }
    
    /// Extract the appropriate phone number from an EmergencyService
    func number(from service: EmergencyService) -> String? {
        switch self {
        case .emergency:
            return service.emergencyNumber
        case .police:
            return service.policeNumber
        case .ambulance:
            return service.ambulanceNumber
        case .fire:
            return service.fireNumber
        }
    }
}
