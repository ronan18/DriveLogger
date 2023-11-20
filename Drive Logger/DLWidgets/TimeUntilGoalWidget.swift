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
    @Environment(\.widgetFamily) private var widgetFamily
    @Query(sort: \DLDrive.startTime, order: .reverse) private var drives: [DLDrive]
    var entry: Provider.Entry

    var body: some View {
        VStack {
            TimeUntilGoalStatCard(statistics: DriveLoggerStatistics(drives: drives), goal: entry.goal ?? 60*60*50, widgetMode: true, widgetFamily: widgetFamily)
        }
    }
}

struct TimeUntilCompletWidget: Widget {
    let kind: String = "TimeUntilComplete"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
         
            TimeUntilCompleteWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget).modelContainer(for: [DLDrive.self])
           
        }
        .configurationDisplayName("Time Left")
        .description("This is an example widget.").supportedFamilies([.systemMedium, .systemSmall])
    }
}
