//
//  WidgetUpdateManager.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import WidgetKit

struct WidgetUpdateManager {
    static func reloadAllWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    static func reloadEmergencyWidget() {
        WidgetCenter.shared.reloadTimelines(ofKind: "SafeDialWidget")
    }
}
