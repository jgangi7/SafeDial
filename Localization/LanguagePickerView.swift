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
                .toolbarBackground(Color.tcSurface, for: .navigationBar)
                .searchable(text: $searchText, prompt: localizationManager.localize(.searchLanguage))
                .tint(Color.tcSecondary)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        cancelButton
                    }
                    ToolbarItem(placement: .primaryAction) {
                        resetButton
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
            Text(localizationManager.localize(.cancel))
                .foregroundStyle(Color.tcSecondary)
        }
    }

    private var resetButton: some View {
        Button {
            localizationManager.resetToSystemDefault()
        } label: {
            Image(systemName: "arrow.counterclockwise")
                .foregroundStyle(Color.tcSecondary)
        }
        .accessibilityLabel(localizationManager.localize(.resetToSystemDefault))
    }

    private var contentView: some View {
        ZStack {
            Color.tcSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                currentLanguageCard
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                localeList
            }
        }
    }

    private var currentLanguageCard: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "translate")
                    .font(.subheadline)
                    .foregroundStyle(Color.tcSecondary)

                Text(localizationManager.localize(.currentLanguage))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.tcOnSurfaceVariant)

                Spacer()
            }

            if let currentLocale = localizationManager.availableLocales.first(where: {
                $0.identifier == localizationManager.currentLocaleIdentifier
            }) {
                HStack(spacing: 12) {
                    if let flag = currentLocale.flag {
                        Text(flag)
                            .font(.system(size: 32))
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(currentLocale.nativeName)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(Color.tcOnSurface)

                        Text(currentLocale.friendlyName)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.tcOnSurfaceVariant)
                    }

                    Spacer()
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.tcSurfaceContainer)
                .shadow(color: Color.tcOnSurface.opacity(0.06), radius: 12, x: 0, y: 4)
        )
    }

    private var localeList: some View {
        List(filteredLocales) { locale in
            localeButton(for: locale)
                .listRowBackground(Color.tcSurfaceContainerLowest)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
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
        HStack(spacing: 14) {
            if let flag = locale.flag {
                Text(flag)
                    .font(.system(size: 30))
            } else {
                Image(systemName: "translate")
                    .font(.system(size: 22))
                    .foregroundStyle(Color.tcOnSurfaceVariant)
                    .frame(width: 32)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(locale.nativeName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.tcOnSurface)

                Text(locale.friendlyName)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.tcOnSurfaceVariant)
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
    LanguagePickerView()
}
