//
//  DLWidgetsBundle.swift
//  DLWidgets
//
//  Created by Ronan Furuta on 7/13/23.
//

import WidgetKit
import SwiftUI

@main
struct DLWidgetsBundle: WidgetBundle {
    var body: some Widget {
        DrivenTodayWidget()
        PercentCompleteWidget()
        TimeUntilCompletWidget()
    }
}
