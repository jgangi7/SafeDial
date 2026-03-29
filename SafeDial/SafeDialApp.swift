//
//  SafeDialApp.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import SwiftUI

@main
struct SafeDialApp: App {
    @State private var urlHandler = URLHandler()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    urlHandler.handleWidgetTap(url: url)
                }
        }
    }
}

// MARK: - URL Handler with OWASP Security

@Observable
class URLHandler {
    // Rate limiting to prevent URL spam attacks
    // OWASP MASVS: CODE-2
    private var lastURLHandleTime: Date?
    private let urlHandleThrottleInterval: TimeInterval = 1.0 // 1 second between URL handling
    
    func handleWidgetTap(url: URL) {
        // OWASP MASVS: CODE-2 - Rate limiting
        if !passesRateLimiting() {
            return
        }
        
        // OWASP MASVS: PLATFORM-2 - URL validation
        guard validateURLStructure(url) else {
            return
        }
        
        // Extract and validate parameters
        // OWASP MASVS: PLATFORM-1, CODE-1
        guard let validatedParams = extractAndValidateParameters(from: url) else {
            return
        }
        
        // Cross-validate against database
        // OWASP MASVS: RESILIENCE-2
        guard crossValidateWithDatabase(
            countryCode: validatedParams.country,
            emergencyNumber: validatedParams.number
        ) else {
            return
        }
    }
    
    // MARK: - Security Validation Methods
    
    /// Rate limiting to prevent URL spam attacks
    /// OWASP MASVS: CODE-2
    private func passesRateLimiting() -> Bool {
        let now = Date()
        
        if let lastTime = lastURLHandleTime {
            let timeSinceLastHandle = now.timeIntervalSince(lastTime)
            
            if timeSinceLastHandle < urlHandleThrottleInterval {
                return false
            }
        }
        
        lastURLHandleTime = now
        return true
    }
    
    /// Validates URL scheme, host, and structure
    /// OWASP MASVS: PLATFORM-2
    private func validateURLStructure(_ url: URL) -> Bool {
        // Validate scheme
        guard url.scheme == "safedial" else {
            return false
        }
        
        // Validate host
        guard url.host == "widget-tapped" else {
            return false
        }
        
        // Validate URL length (prevent DoS)
        guard url.absoluteString.count < 200 else {
            return false
        }
        
        return true
    }
    
    /// Extracts and validates URL parameters
    /// OWASP MASVS: PLATFORM-1, CODE-1
    private func extractAndValidateParameters(from url: URL) -> (country: String, number: String)? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        // Extract country parameter
        guard let country = components.queryItems?.first(where: { $0.name == "country" })?.value else {
            return nil
        }
        
        // Validate country code format
        guard EmergencyService.isValidCountryCode(country) else {
            return nil
        }
        
        // Extract number parameter
        guard let number = components.queryItems?.first(where: { $0.name == "number" })?.value else {
            return nil
        }
        
        // Sanitize and validate phone number
        let sanitizedNumber = EmergencyService.sanitizePhoneNumber(number)
        guard EmergencyService.isValidPhoneNumber(sanitizedNumber) else {
            return nil
        }
        
        return (country: country, number: sanitizedNumber)
    }
    
    /// Cross-validates URL parameters against emergency service database
    /// OWASP MASVS: RESILIENCE-2
    private func crossValidateWithDatabase(countryCode: String, emergencyNumber: String) -> Bool {
        let database = EmergencyServiceDatabase.shared
        
        // Special case: "EU" is our default/unknown location code
        if countryCode == "EU" && emergencyNumber == "112" {
            return true
        }
        
        // Check if country exists in database
        guard let service = database.service(for: countryCode) else {
            return false
        }
        
        // Verify the emergency number matches one of the valid numbers for this country
        let validNumbers = [
            service.emergencyNumber,
            service.policeNumber,
            service.ambulanceNumber,
            service.fireNumber
        ].compactMap { $0 }
        
        guard validNumbers.contains(emergencyNumber) else {
            return false
        }
        
        return true
    }
}
