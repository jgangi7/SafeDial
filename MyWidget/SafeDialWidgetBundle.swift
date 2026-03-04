//
//  SafeDialWidgetBundle.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/4/26.
//

import WidgetKit
import SwiftUI

@main
struct SafeDialWidgetBundle: WidgetBundle {
    init() {
        print("🔷 SafeDialWidgetBundle: Widget extension launched")
    }
    
    var body: some Widget {
        SafeDialWidget()
    }
}
