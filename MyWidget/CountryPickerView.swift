//
//  CountryPickerView.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import SwiftUI

struct CountryPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedService: EmergencyService?
    
    @State private var searchText = ""
    
    private var allServices: [EmergencyService] {
        // Get all services from the database
        let database = EmergencyServiceDatabase.shared
        let countryCodes = [
            "US", "CA", "MX", "GB", "FR", "DE", "IT", "ES", "NL", "BE",
            "CH", "AT", "SE", "NO", "DK", "FI", "PL", "IE", "PT", "AU",
            "NZ", "JP", "CN", "KR", "IN", "SG", "MY", "TH", "PH", "ID",
            "VN", "HK", "TW", "AE", "SA", "IL", "TR", "BR", "AR", "CL",
            "CO", "PE", "ZA", "EG", "KE", "NG"
        ]
        
        return countryCodes.compactMap { database.service(for: $0) }
            .sorted { $0.countryName < $1.countryName }
    }
    
    private var filteredServices: [EmergencyService] {
        if searchText.isEmpty {
            return allServices
        }
        return allServices.filter { service in
            service.countryName.localizedCaseInsensitiveContains(searchText) ||
            service.countryCode.localizedCaseInsensitiveContains(searchText) ||
            service.emergencyNumber.contains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredServices, id: \.countryCode) { service in
                Button {
                    selectedService = service
                    LocationManager.shared.cacheEmergencyService(service)
                    WidgetUpdateManager.reloadEmergencyWidget()
                    dismiss()
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(service.countryName)
                                .font(.headline)
                            
                            Text("Emergency: \(service.emergencyNumber)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        if selectedService?.countryCode == service.countryCode {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search countries")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CountryPickerView(selectedService: .constant(nil))
}
