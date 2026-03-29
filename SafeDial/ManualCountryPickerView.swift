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
                .toolbarBackground(Color.tcSurface, for: .navigationBar)
                .searchable(text: $searchText, prompt: String(localized: .searchCountry))
                .tint(Color.tcSecondary)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        cancelButton
                    }
                }
        }
        .tint(Color.tcSecondary)
        .preferredColorScheme(.light)
    }

    private var cancelButton: some View {
        Button {
            dismiss()
        } label: {
            LocalizedText(.cancel)
                .foregroundStyle(Color.tcSecondary)
        }
    }

    private var contentView: some View {
        ZStack {
            Color.tcSurface.ignoresSafeArea()
            serviceList
        }
    }

    private var serviceList: some View {
        List(filteredServices, id: \.countryCode) { service in
            serviceButton(for: service)
                .listRowBackground(Color.tcSurfaceContainerLowest)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
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
        HStack(spacing: 14) {
            Text(service.flag)
                .font(.system(size: 36))

            VStack(alignment: .leading, spacing: 3) {
                Text(service.countryName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.tcOnSurface)

                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption2)
                        .foregroundStyle(Color.tcPrimary)

                    Text(service.emergencyNumber)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.tcOnSurfaceVariant)
                }
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Color.tcSecondary)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ManualCountryPickerView(selectedService: .constant(nil))
}
