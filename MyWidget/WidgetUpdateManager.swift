//
//  WidgetUpdateManager.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import WidgetKit

struct WidgetUpdateManager {
    static func reloadAllWidgets() {
        print("🔄 WidgetUpdateManager: Reloading all widgets")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    static func reloadEmergencyWidget() {
        print("🔄 WidgetUpdateManager: Reloading SafeDialWidget")
        WidgetCenter.shared.reloadTimelines(ofKind: "SafeDialWidget")
    }
}
