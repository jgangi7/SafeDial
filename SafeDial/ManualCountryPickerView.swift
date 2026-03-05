//
//  ManualCountryPickerView.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import SwiftUI

struct ManualCountryPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedService: EmergencyService?
    @StateObject private var localizationManager = LocalizationManager.shared
    
    @State private var searchText = ""
    
    private var allServices: [EmergencyService] {
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
            let matchesCountryName = service.countryName.localizedCaseInsensitiveContains(searchText)
            let matchesCountryCode = service.countryCode.localizedCaseInsensitiveContains(searchText)
            let matchesEmergencyNumber = service.emergencyNumber.contains(searchText)
            return matchesCountryName || matchesCountryCode || matchesEmergencyNumber
        }
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle(String(localized: .selectCountry))
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(toolbarBackgroundColor, for: .navigationBar)
                .searchable(text: $searchText, prompt: String(localized: .searchCountry))
                .tint(.cerulean)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        cancelButton
                    }
                }
        }
        .tint(.cerulean)
    }
    
    private var toolbarBackgroundColor: Color {
        Color.honeydew.opacity(0.95)
    }
    
    private var cancelButton: some View {
        Button {
            dismiss()
        } label: {
            LocalizedText(.cancel)
                .foregroundStyle(Color.cerulean)
        }
    }
    
    private var contentView: some View {
        ZStack {
            // Background
            Color.honeydew.ignoresSafeArea()
            
            serviceList
        }
    }
    
    private var serviceList: some View {
        List(filteredServices, id: \.countryCode) { service in
            serviceButton(for: service)
                .listRowBackground(Color.white.opacity(0.6))
        }
        .scrollContentBackground(.hidden)
    }
    
    private func serviceButton(for service: EmergencyService) -> some View {
        Button {
            selectedService = service
            dismiss()
        } label: {
            CountryRowView(
                service: service,
                isSelected: selectedService?.countryCode == service.countryCode
            )
        }
    }
}

// MARK: - Helper Row View
// Extracting this prevents the "compiler unable to type-check in reasonable time" error

struct CountryRowView: View {
    let service: EmergencyService
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Flag emoji
            Text(service.flag)
                .font(.system(size: 40))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(service.countryName)
                    .font(.headline)
                    .foregroundStyle(Color.oxfordNavy)
                
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption2)
                        .foregroundStyle(Color.emergencyRed)
                    
                    Text(service.emergencyNumber)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.oxfordNavy.opacity(0.7))
                }
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Color.cerulean)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ManualCountryPickerView(selectedService: .constant(nil))
}
