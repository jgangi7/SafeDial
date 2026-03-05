//
//  EmergencyService.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import Foundation

struct EmergencyService: Codable, Hashable, Sendable {
    let countryCode: String
    let countryName: String
    let emergencyNumber: String
    let policeNumber: String?
    let ambulanceNumber: String?
    let fireNumber: String?
    
    var primaryNumber: String { 
        emergencyNumber
    }
    
    /// Returns the emoji flag for the country
    var flag: String {
        countryCode
            .unicodeScalars
            .map { 127397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    /// Returns a formatted display string with flag and country name
    var displayName: String {
        "\(flag) \(countryName)"
    }
    
    /// Returns just the country name for smart location display (no country code)
    var smartLocationDisplay: String {
        countryName
    }
}

final class EmergencyServiceDatabase: Sendable {
    static let shared = EmergencyServiceDatabase()
    
    private let services: [String: EmergencyService] = [
        // North America
        "US": EmergencyService(countryCode: "US", countryName: "United States", emergencyNumber: "911", policeNumber: "911", ambulanceNumber: "911", fireNumber: "911"),
        "CA": EmergencyService(countryCode: "CA", countryName: "Canada", emergencyNumber: "911", policeNumber: "911", ambulanceNumber: "911", fireNumber: "911"),
        "MX": EmergencyService(countryCode: "MX", countryName: "Mexico", emergencyNumber: "911", policeNumber: "911", ambulanceNumber: "911", fireNumber: "911"),
        
        // Europe
        "GB": EmergencyService(countryCode: "GB", countryName: "United Kingdom", emergencyNumber: "112", policeNumber: "112", ambulanceNumber: "112", fireNumber: "999"),
        "FR": EmergencyService(countryCode: "FR", countryName: "France", emergencyNumber: "112", policeNumber: "17", ambulanceNumber: "15", fireNumber: "18"),
        "DE": EmergencyService(countryCode: "DE", countryName: "Germany", emergencyNumber: "112", policeNumber: "110", ambulanceNumber: "112", fireNumber: "112"),
        "IT": EmergencyService(countryCode: "IT", countryName: "Italy", emergencyNumber: "112", policeNumber: "112", ambulanceNumber: "118", fireNumber: "115"),
        "ES": EmergencyService(countryCode: "ES", countryName: "Spain", emergencyNumber: "112", policeNumber: "112", ambulanceNumber: "112", fireNumber: "112"),
        "NL": EmergencyService(countryCode: "NL", countryName: "Netherlands", emergencyNumber: "112", policeNumber: "112", ambulanceNumber: "112", fireNumber: "112"),
        "BE": EmergencyService(countryCode: "BE", countryName: "Belgium", emergencyNumber: "112", policeNumber: "112", ambulanceNumber: "112", fireNumber: "112"),
        "CH": EmergencyService(countryCode: "CH", countryName: "Switzerland", emergencyNumber: "117", policeNumber: "117", ambulanceNumber: "144", fireNumber: "118"),
        "AT": EmergencyService(countryCode: "AT", countryName: "Austria", emergencyNumber: "112", policeNumber: "133", ambulanceNumber: "144", fireNumber: "122"),
        "SE": EmergencyService(countryCode: "SE", countryName: "Sweden", emergencyNumber: "112", policeNumber: "112", ambulanceNumber: "112", fireNumber: "112"),
        "NO": EmergencyService(countryCode: "NO", countryName: "Norway", emergencyNumber: "112", policeNumber: "112", ambulanceNumber: "113", fireNumber: "110"),
        "DK": EmergencyService(countryCode: "DK", countryName: "Denmark", emergencyNumber: "112", policeNumber: "114", ambulanceNumber: "112", fireNumber: "112"),
        "FI": EmergencyService(countryCode: "FI", countryName: "Finland", emergencyNumber: "112", policeNumber: "112", ambulanceNumber: "112", fireNumber: "112"),
        "PL": EmergencyService(countryCode: "PL", countryName: "Poland", emergencyNumber: "112", policeNumber: "997", ambulanceNumber: "999", fireNumber: "998"),
        "IE": EmergencyService(countryCode: "IE", countryName: "Ireland", emergencyNumber: "112", policeNumber: "999", ambulanceNumber: "999", fireNumber: "999"),
        "PT": EmergencyService(countryCode: "PT", countryName: "Portugal", emergencyNumber: "112", policeNumber: "112", ambulanceNumber: "112", fireNumber: "112"),
        
        // Asia-Pacific
        "AU": EmergencyService(countryCode: "AU", countryName: "Australia", emergencyNumber: "000", policeNumber: "000", ambulanceNumber: "000", fireNumber: "000"),
        "NZ": EmergencyService(countryCode: "NZ", countryName: "New Zealand", emergencyNumber: "111", policeNumber: "111", ambulanceNumber: "111", fireNumber: "111"),
        "JP": EmergencyService(countryCode: "JP", countryName: "Japan", emergencyNumber: "110", policeNumber: "110", ambulanceNumber: "119", fireNumber: "119"),
        "CN": EmergencyService(countryCode: "CN", countryName: "China", emergencyNumber: "110", policeNumber: "110", ambulanceNumber: "120", fireNumber: "119"),
        "KR": EmergencyService(countryCode: "KR", countryName: "South Korea", emergencyNumber: "112", policeNumber: "112", ambulanceNumber: "119", fireNumber: "119"),
        "IN": EmergencyService(countryCode: "IN", countryName: "India", emergencyNumber: "112", policeNumber: "100", ambulanceNumber: "102", fireNumber: "101"),
        "SG": EmergencyService(countryCode: "SG", countryName: "Singapore", emergencyNumber: "999", policeNumber: "999", ambulanceNumber: "995", fireNumber: "995"),
        "MY": EmergencyService(countryCode: "MY", countryName: "Malaysia", emergencyNumber: "999", policeNumber: "999", ambulanceNumber: "999", fireNumber: "994"),
        "TH": EmergencyService(countryCode: "TH", countryName: "Thailand", emergencyNumber: "191", policeNumber: "191", ambulanceNumber: "1669", fireNumber: "199"),
        "PH": EmergencyService(countryCode: "PH", countryName: "Philippines", emergencyNumber: "911", policeNumber: "911", ambulanceNumber: "911", fireNumber: "911"),
        "ID": EmergencyService(countryCode: "ID", countryName: "Indonesia", emergencyNumber: "112", policeNumber: "110", ambulanceNumber: "118", fireNumber: "113"),
        "VN": EmergencyService(countryCode: "VN", countryName: "Vietnam", emergencyNumber: "113", policeNumber: "113", ambulanceNumber: "115", fireNumber: "114"),
        "HK": EmergencyService(countryCode: "HK", countryName: "Hong Kong", emergencyNumber: "999", policeNumber: "999", ambulanceNumber: "999", fireNumber: "999"),
        "TW": EmergencyService(countryCode: "TW", countryName: "Taiwan", emergencyNumber: "110", policeNumber: "110", ambulanceNumber: "119", fireNumber: "119"),
        
        // Middle East
        "AE": EmergencyService(countryCode: "AE", countryName: "United Arab Emirates", emergencyNumber: "999", policeNumber: "999", ambulanceNumber: "998", fireNumber: "997"),
        "SA": EmergencyService(countryCode: "SA", countryName: "Saudi Arabia", emergencyNumber: "999", policeNumber: "999", ambulanceNumber: "997", fireNumber: "998"),
        "IL": EmergencyService(countryCode: "IL", countryName: "Israel", emergencyNumber: "112", policeNumber: "100", ambulanceNumber: "101", fireNumber: "102"),
        "TR": EmergencyService(countryCode: "TR", countryName: "Turkey", emergencyNumber: "112", policeNumber: "155", ambulanceNumber: "112", fireNumber: "110"),
        
        // South America
        "BR": EmergencyService(countryCode: "BR", countryName: "Brazil", emergencyNumber: "190", policeNumber: "190", ambulanceNumber: "192", fireNumber: "193"),
        "AR": EmergencyService(countryCode: "AR", countryName: "Argentina", emergencyNumber: "911", policeNumber: "911", ambulanceNumber: "911", fireNumber: "911"),
        "CL": EmergencyService(countryCode: "CL", countryName: "Chile", emergencyNumber: "133", policeNumber: "133", ambulanceNumber: "131", fireNumber: "132"),
        "CO": EmergencyService(countryCode: "CO", countryName: "Colombia", emergencyNumber: "123", policeNumber: "112", ambulanceNumber: "125", fireNumber: "119"),
        "PE": EmergencyService(countryCode: "PE", countryName: "Peru", emergencyNumber: "105", policeNumber: "105", ambulanceNumber: "116", fireNumber: "116"),
        
        // Africa
        "ZA": EmergencyService(countryCode: "ZA", countryName: "South Africa", emergencyNumber: "112", policeNumber: "112", ambulanceNumber: "112", fireNumber: "112"),
        "EG": EmergencyService(countryCode: "EG", countryName: "Egypt", emergencyNumber: "122", policeNumber: "122", ambulanceNumber: "123", fireNumber: "180"),
        "KE": EmergencyService(countryCode: "KE", countryName: "Kenya", emergencyNumber: "999", policeNumber: "999", ambulanceNumber: "999", fireNumber: "999"),
        "NG": EmergencyService(countryCode: "NG", countryName: "Nigeria", emergencyNumber: "112", policeNumber: "112", ambulanceNumber: "112", fireNumber: "112"),
    ]
    
    func service(for countryCode: String) -> EmergencyService? {
        services[countryCode]
    }
    
    // Fallback to EU standard
    var defaultService: EmergencyService {
        EmergencyService(countryCode: "EU", countryName: "Unknown Location", emergencyNumber: "112", policeNumber: "112", ambulanceNumber: "112", fireNumber: "112")
    }
}
