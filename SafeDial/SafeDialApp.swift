//
//  SafeDialApp.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import SwiftUI

@main
struct SafeDialApp: App {
    init() {
        print("🚀 SafeDialApp: App launched")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    handleWidgetTap(url: url)
                }
        }
    }
    
    private func handleWidgetTap(url: URL) {
        print("🔗 SafeDialApp: URL received - \(url.absoluteString)")
        
        guard url.scheme == "safedial",
              url.host == "widget-tapped" else {
            print("🔗 SafeDialApp: Unknown URL scheme/host")
            return
        }
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let country = components?.queryItems?.first(where: { $0.name == "country" })?.value ?? "Unknown"
        let number = components?.queryItems?.first(where: { $0.name == "number" })?.value ?? "Unknown"
        
        print("👆 WIDGET TAPPED!")
        print("   🌍 Country Code: \(country)")
        print("   📞 Emergency Number: \(number)")
        print("   ⏰ Time: \(Date())")
    }
}
