//
//  TimeUntilGoalWidget.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 7/14/23.
//

import WidgetKit
import SwiftUI
import DriveLoggerKit
import DriveLoggerUI
import SwiftData


struct TimeUntilCompleteWidgetView : View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \.startTime, order: .reverse) private var drives: [Drive]
    var entry: Provider.Entry

    var body: some View {
        VStack {
            TimeUntilGoalStatCard(statistics: DriveLoggerStatistics(drives: drives), goal: 60*60*50, widgetMode: true)
        }
    }
}

struct TimeUntilCompletWidget: Widget {
    let kind: String = "TimeUntilComplete"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
         
            TimeUntilCompleteWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget).modelContainer(for: [Drive.self])
           
        }
        .configurationDisplayName("Time Left")
        .description("This is an example widget.")
    }
}
