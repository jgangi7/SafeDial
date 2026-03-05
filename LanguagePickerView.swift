//
//  LanguagePickerView.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/5/26.
//

import SwiftUI

struct LanguagePickerView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var localizationManager = LocalizationManager.shared
    
    @State private var searchText = ""
    
    private var filteredLocales: [LocaleInfo] {
        if searchText.isEmpty {
            return localizationManager.availableLocales
        }
        
        return localizationManager.availableLocales.filter { locale in
            let matchesFriendlyName = locale.friendlyName.localizedCaseInsensitiveContains(searchText)
            let matchesNativeName = locale.nativeName.localizedCaseInsensitiveContains(searchText)
            let matchesLanguageCode = locale.languageCode.localizedCaseInsensitiveContains(searchText)
            return matchesFriendlyName || matchesNativeName || matchesLanguageCode
        }
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle(localizationManager.localize(.selectLanguage))
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(toolbarBackgroundColor, for: .navigationBar)
                .searchable(text: $searchText, prompt: localizationManager.localize(.searchLanguage))
                .tint(.cerulean)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        cancelButton
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        resetButton
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
            Text(localizationManager.localize(.cancel))
                .foregroundStyle(Color.cerulean)
        }
    }
    
    private var resetButton: some View {
        Button {
            localizationManager.resetToSystemDefault()
        } label: {
            Image(systemName: "arrow.counterclockwise")
                .foregroundStyle(Color.cerulean)
        }
        .accessibilityLabel(localizationManager.localize(.resetToSystemDefault))
    }
    
    private var contentView: some View {
        ZStack {
            // Background
            Color.honeydew.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Current language indicator
                currentLanguageCard
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                
                // Language list
                localeList
            }
        }
    }
    
    private var currentLanguageCard: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "globe")
                    .font(.headline)
                    .foregroundStyle(.blue)
                
                Text(localizationManager.localize(.currentLanguage))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
            if let currentLocale = localizationManager.availableLocales.first(where: { $0.identifier == localizationManager.currentLocaleIdentifier }) {
                HStack(spacing: 12) {
                    if let flag = currentLocale.flag {
                        Text(flag)
                            .font(.system(size: 32))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(currentLocale.nativeName)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(.primary)
                        
                        Text(currentLocale.friendlyName)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThickMaterial)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
    
    private var localeList: some View {
        List(filteredLocales) { locale in
            localeButton(for: locale)
                .listRowBackground(Color.white.opacity(0.6))
        }
        .scrollContentBackground(.hidden)
    }
    
    private func localeButton(for locale: LocaleInfo) -> some View {
        Button {
            localizationManager.changeLocale(to: locale.identifier)
            
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            // Optionally dismiss after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                dismiss()
            }
        } label: {
            LocaleRowView(
                locale: locale,
                isSelected: localizationManager.currentLocaleIdentifier == locale.identifier
            )
        }
    }
}

// MARK: - Locale Row View

struct LocaleRowView: View {
    let locale: LocaleInfo
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Flag emoji (if available)
            if let flag = locale.flag {
                Text(flag)
                    .font(.system(size: 32))
            } else {
                Image(systemName: "globe")
                    .font(.system(size: 24))
                    .foregroundStyle(.secondary)
                    .frame(width: 32)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Native name (how speakers of that language would see it)
                Text(locale.nativeName)
                    .font(.headline)
                    .foregroundStyle(Color.oxfordNavy)
                
                // Friendly name in English
                Text(locale.friendlyName)
                    .font(.subheadline)
                    .foregroundStyle(Color.oxfordNavy.opacity(0.7))
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
    LanguagePickerView()
}
