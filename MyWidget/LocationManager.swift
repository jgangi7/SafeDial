import Foundation
import CoreLocation
import MapKit
import Combine
import WidgetKit

@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private let database = EmergencyServiceDatabase.shared
    
    @Published var currentEmergencyService: EmergencyService?
    @Published var isLoading = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.authorizationStatus = locationManager.authorizationStatus
        
        // Initial load from disk to keep UI consistent immediately
        self.currentEmergencyService = getCachedEmergencyService()
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// The ONLY way to trigger GPS now is by calling this manually
    func updateLocation() {
        print("📍 LocationManager: Manual update requested")
        isLoading = true
        locationManager.requestLocation()
    }
    
    // MARK: - Delegate Methods
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        Task { @MainActor in
            await reverseGeocodeLocation(location)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("🔴 LocationManager error: \(error.localizedDescription)")
        Task { @MainActor in
            isLoading = false
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationStatus = manager.authorizationStatus
        }
    }
    
    // MARK: - Data Logic
    
    private func reverseGeocodeLocation(_ location: CLLocation) async {
        let search = MKLocalSearch(request: createSearchRequest(for: location.coordinate))
        do {
            let response = try await search.start()
            if let code = response.mapItems.first?.placemark.countryCode,
               let service = database.service(for: code) {
                self.currentEmergencyService = service
                cacheEmergencyService(service)
            }
        } catch {
            print("🔴 Geocoding failed")
        }
        isLoading = false
    }
    
    private func createSearchRequest(for coord: CLLocationCoordinate2D) -> MKLocalSearch.Request {
        let request = MKLocalSearch.Request()
        request.region = MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        request.resultTypes = .address
        return request
    }
    
    // MARK: - Disk I/O (Consistency Layer)
    
    nonisolated func getCachedEmergencyService() -> EmergencyService {
        if let data = UserDefaults.appGroup.data(forKey: "cachedEmergencyService"),
           let service = try? JSONDecoder().decode(EmergencyService.self, from: data) {
            return service
        }
        return EmergencyServiceDatabase.shared.defaultService
    }
    
    func cacheEmergencyService(_ service: EmergencyService) {
        // 1. Force the use of the SUITE NAME directly to ensure it hits the shared container
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.jimmygangi.emergencyroute") else {
            print("❌ APP: Failed to initialize Shared Defaults!")
            return
        }
        
        do {
            let data = try JSONEncoder().encode(service)
            sharedDefaults.set(data, forKey: "cachedEmergencyService")
            
            // 2. Synchronize forces the file to be written to disk immediately
            // instead of waiting for the system to feel like it.
            sharedDefaults.synchronize()
            
            // 3. Trigger the reload
            WidgetCenter.shared.reloadAllTimelines()
            print("💾 APP: Saved \(service.countryName) to Shared Container")
        } catch {
            print("❌ APP: Encoding error: \(error)")
        }
    }
}
