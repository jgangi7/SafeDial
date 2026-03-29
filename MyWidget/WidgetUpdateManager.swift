//
//  WidgetUpdateManager.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import WidgetKit

struct WidgetUpdateManager {
    static func reloadAllWidgets() {
        // Ensure UserDefaults are synchronized before reloading widgets
        // This guarantees the widget sees the latest locale preference
        AppGroup.userDefaults.synchronize()
        
        // Reload all widget timelines
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    static func reloadEmergencyWidget() {
        // Ensure UserDefaults are synchronized before reloading
        AppGroup.userDefaults.synchronize()
        
        // Reload specific widget timeline
        WidgetCenter.shared.reloadTimelines(ofKind: "SafeDialWidget")
    }
}
