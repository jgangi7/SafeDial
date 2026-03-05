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
    
    /// Gradient background for each service type
    var gradient: LinearGradient {
        switch self {
        case .emergency:
            return LinearGradient(
                colors: [
                    Color(red: 0.9, green: 0.2, blue: 0.2),
                    Color(red: 0.7, green: 0.1, blue: 0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .police:
            return LinearGradient(
                colors: [
                    Color(red: 0.2, green: 0.4, blue: 0.9),
                    Color(red: 0.1, green: 0.3, blue: 0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .ambulance:
            return LinearGradient(
                colors: [
                    Color(red: 0.2, green: 0.8, blue: 0.4),
                    Color(red: 0.1, green: 0.6, blue: 0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .fire:
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.6, blue: 0.2),
                    Color(red: 0.9, green: 0.4, blue: 0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    /// Solid color for icons and accents
    var solidColor: Color {
        switch self {
        case .emergency:
            return Color(red: 0.9, green: 0.2, blue: 0.2)
        case .police:
            return Color(red: 0.2, green: 0.4, blue: 0.9)
        case .ambulance:
            return Color(red: 0.2, green: 0.8, blue: 0.4)
        case .fire:
            return Color(red: 1.0, green: 0.6, blue: 0.2)
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
