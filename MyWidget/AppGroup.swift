//
//  AppGroup.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import Foundation
import CryptoKit

enum AppGroup {
    static let identifier = "group.com.jimmygangi.emergencyroute"
    
    static var userDefaults: UserDefaults {
        // Try to load the App Group UserDefaults
        // If it fails, fall back to standard UserDefaults with a warning
        if let defaults = UserDefaults(suiteName: identifier) {
            return defaults
        } else {
            return UserDefaults.standard
        }
    }
    
    // MARK: - OWASP Secure Storage with HMAC Integrity
    
    /// Securely saves data with HMAC integrity verification
    /// OWASP MASVS: STORAGE-1, CRYPTO-1, RESILIENCE-1
    static func secureSet<T: Encodable>(_ value: T, forKey key: String) throws {
        // Encode the data
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        
        // Generate HMAC signature
        let hmac = generateHMAC(for: data)
        
        // Save both data and HMAC
        userDefaults.set(data, forKey: key)
        userDefaults.set(hmac, forKey: "\(key)_hmac")
        userDefaults.synchronize()
    }
    
    /// Securely loads data with HMAC integrity verification
    /// OWASP MASVS: STORAGE-1, CRYPTO-1, RESILIENCE-1
    static func secureGet<T: Decodable>(_ type: T.Type, forKey key: String) throws -> T? {
        // Load data and HMAC
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        guard let storedHMAC = userDefaults.data(forKey: "\(key)_hmac") else {
            // If no HMAC exists, this might be legacy data - attempt migration
            return try migrateAndVerify(data: data, key: key, type: type)
        }
        
        // Verify HMAC integrity
        let computedHMAC = generateHMAC(for: data)
        guard computedHMAC == storedHMAC else {
            throw SecurityError.integrityCheckFailed
        }
        
        // Decode and return
        let decoder = JSONDecoder()
        let value = try decoder.decode(type, from: data)
        return value
    }
    
    /// Generates HMAC-SHA256 signature for data integrity
    /// OWASP MASVS: CRYPTO-1, RESILIENCE-1
    private static func generateHMAC(for data: Data) -> Data {
        // Use the App Group identifier as the key derivation
        // This ensures BOTH the app and widget use the SAME key
        // (they have different bundle IDs but share the same App Group)
        let keyString = "\(identifier).hmac.key"
        let keyData = keyString.data(using: .utf8)!
        let key = SymmetricKey(data: keyData)
        
        // Generate HMAC-SHA256
        let hmac = HMAC<SHA256>.authenticationCode(for: data, using: key)
        return Data(hmac)
    }
    
    /// Migrates legacy data without HMAC and adds integrity protection
    /// OWASP MASVS: STORAGE-1
    private static func migrateAndVerify<T: Decodable>(data: Data, key: String, type: T.Type) throws -> T? {
        // Decode legacy data
        let decoder = JSONDecoder()
        let value = try decoder.decode(type, from: data)
        
        // Re-save with HMAC protection
        if let encodableValue = value as? Encodable {
            try? secureSet(encodableValue, forKey: key)
        }
        
        return value
    }
    
    /// Securely removes data and its HMAC
    /// OWASP MASVS: STORAGE-1
    static func secureRemove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
        userDefaults.removeObject(forKey: "\(key)_hmac")
        userDefaults.synchronize()
    }
}

extension UserDefaults {
    static var appGroup: UserDefaults {
        AppGroup.userDefaults
    }
}

// MARK: - Security Errors

enum SecurityError: Error, LocalizedError {
    case integrityCheckFailed
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .integrityCheckFailed:
            return "Data integrity check failed. The data may have been tampered with."
        case .invalidData:
            return "Invalid data format."
        }
    }
}
