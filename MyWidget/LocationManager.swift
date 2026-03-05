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
        }
        isLoading = false
    }
    
    private func createSearchRequest(for coord: CLLocationCoordinate2D) -> MKLocalSearch.Request {
        let request = MKLocalSearch.Request()
        request.region = MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        request.resultTypes = .address
        return request
    }
    
    // MARK: - Disk I/O (Consistency Layer) with OWASP Security
    
    nonisolated func getCachedEmergencyService() -> EmergencyService {
        do {
            // Use secure storage with HMAC integrity verification
            // OWASP MASVS: STORAGE-1, RESILIENCE-1
            if let service = try AppGroup.secureGet(EmergencyService.self, forKey: "cachedEmergencyService") {
                return service
            }
        } catch SecurityError.integrityCheckFailed {
            // HMAC verification failed - data was tampered with
            // Clean up compromised data
            AppGroup.secureRemove(forKey: "cachedEmergencyService")
        } catch {
        }
        
        // Return default service if no valid cached data
        return EmergencyServiceDatabase.shared.defaultService
    }
    
    func cacheEmergencyService(_ service: EmergencyService) {
        // Validate service data before caching
        // OWASP MASVS: PLATFORM-1, CODE-1
        guard EmergencyService.isValidCountryCode(service.countryCode) else {
            return
        }
        
        guard EmergencyService.isValidPhoneNumber(service.emergencyNumber) else {
            return
        }
        
        // Validate optional numbers if present
        if let police = service.policeNumber, !EmergencyService.isValidPhoneNumber(police) {
            return
        }
        
        if let ambulance = service.ambulanceNumber, !EmergencyService.isValidPhoneNumber(ambulance) {
            return
        }
        
        if let fire = service.fireNumber, !EmergencyService.isValidPhoneNumber(fire) {
            return
        }
        
        do {
            // Use secure storage with HMAC integrity protection
            // OWASP MASVS: STORAGE-1, CRYPTO-1, RESILIENCE-1
            try AppGroup.secureSet(service, forKey: "cachedEmergencyService")
            
            // Trigger widget reload
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
        }
    }
}
