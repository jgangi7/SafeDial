//
//  LocationManager.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

public import Foundation
public import CoreLocation
public import MapKit
public import Combine
public import WidgetKit

@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    @Published var currentCountryCode: String?
    @Published var currentEmergencyService: EmergencyService?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isLoading = false
    
    private override init() {
        super.init()
        print("📍 LocationManager: Initializing...")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // We don't need precise location
        authorizationStatus = locationManager.authorizationStatus
        print("📍 LocationManager: Initial authorization status: \(authorizationStatus.rawValue)")
    }
    
    func requestAuthorization() {
        print("📍 LocationManager: Requesting location authorization...")
        locationManager.requestWhenInUseAuthorization()
    }
    
    func updateLocation() {
        print("📍 LocationManager: updateLocation() called")
        isLoading = true
        locationManager.requestLocation()
        print("📍 LocationManager: Location request sent")
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            print("📍 LocationManager: Authorization changed to \(manager.authorizationStatus.rawValue)")
            authorizationStatus = manager.authorizationStatus
            
            if manager.authorizationStatus == .authorizedWhenInUse || 
               manager.authorizationStatus == .authorizedAlways {
                print("📍 LocationManager: Authorization granted, updating location...")
                updateLocation()
            } else {
                print("📍 LocationManager: Authorization not granted (status: \(manager.authorizationStatus.rawValue))")
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print("📍 LocationManager: didUpdateLocations called but no locations provided")
            return
        }
        
        print("📍 LocationManager: Location updated - lat: \(location.coordinate.latitude), lon: \(location.coordinate.longitude)")
        
        Task { @MainActor in
            await reverseGeocodeLocation(location)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("🔴 LocationManager: Location error - \(error.localizedDescription)")
        Task { @MainActor in
            isLoading = false
            // Use default service on error
            print("📍 LocationManager: Using default service due to error")
            let defaultService = EmergencyServiceDatabase.shared.defaultService
            currentEmergencyService = defaultService
            cacheEmergencyService(defaultService)
        }
    }
    
    private func reverseGeocodeLocation(_ location: CLLocation) async {
        print("📍 LocationManager: Starting reverse geocode for location...")
        let coordinate = location.coordinate
        let request = MKLocalSearch.Request()
        request.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        request.resultTypes = .address
        
        let search = MKLocalSearch(request: request)
        
        do {
            print("📍 LocationManager: Executing MKLocalSearch...")
            let response = try await search.start()
            
            if let countryCode = response.mapItems.first?.placemark.countryCode {
                print("✅ LocationManager: Found country code: \(countryCode)")
                currentCountryCode = countryCode
                
                if let service = EmergencyServiceDatabase.shared.service(for: countryCode) {
                    print("✅ LocationManager: Found emergency service for \(service.countryName)")
                    currentEmergencyService = service
                    cacheEmergencyService(service)
                } else {
                    print("🟡 LocationManager: No service found for \(countryCode), using default")
                    let defaultService = EmergencyServiceDatabase.shared.defaultService
                    currentEmergencyService = defaultService
                    cacheEmergencyService(defaultService)
                }
            } else {
                print("🔴 LocationManager: No country code in response")
                let defaultService = EmergencyServiceDatabase.shared.defaultService
                currentEmergencyService = defaultService
                cacheEmergencyService(defaultService)
            }
        } catch {
            print("🔴 LocationManager: Geocoding error - \(error.localizedDescription)")
            let defaultService = EmergencyServiceDatabase.shared.defaultService
            currentEmergencyService = defaultService
            cacheEmergencyService(defaultService)
        }
        
        print("📍 LocationManager: Reverse geocode completed, isLoading = false")
        isLoading = false
    }
    
    // For widget use - synchronous fetch from UserDefaults
    nonisolated func getCachedEmergencyService() -> EmergencyService {
        print("📍 LocationManager: getCachedEmergencyService() called")
        if let data = UserDefaults.appGroup.data(forKey: "cachedEmergencyService"),
           let service = try? JSONDecoder().decode(EmergencyService.self, from: data) {
            print("📍 LocationManager: Returning cached service for \(service.countryCode)")
            return service
        }
        print("📍 LocationManager: No cached service, returning default")
        return EmergencyServiceDatabase.shared.defaultService
    }
    
    nonisolated func cacheEmergencyService(_ service: EmergencyService) {
        print("📍 LocationManager: Caching service for \(service.countryName) (\(service.countryCode))")
        if let data = try? JSONEncoder().encode(service) {
            UserDefaults.appGroup.set(data, forKey: "cachedEmergencyService")
            print("📍 LocationManager: Service cached successfully (\(data.count) bytes)")
            
            // Verify it was written
            if let verifyData = UserDefaults.appGroup.data(forKey: "cachedEmergencyService") {
                print("✅ LocationManager: Verified cache write - \(verifyData.count) bytes in UserDefaults")
                if let verifyService = try? JSONDecoder().decode(EmergencyService.self, from: verifyData) {
                    print("✅ LocationManager: Verified decode - \(verifyService.countryName) (\(verifyService.countryCode))")
                }
            } else {
                print("🔴 LocationManager: FAILED to verify cache write!")
            }
            
            // Trigger widget reload
            print("📍 LocationManager: Triggering widget reload")
            WidgetCenter.shared.reloadTimelines(ofKind: "SafeDialWidget")
        } else {
            print("🔴 LocationManager: Failed to encode service for caching")
        }
    }
}
