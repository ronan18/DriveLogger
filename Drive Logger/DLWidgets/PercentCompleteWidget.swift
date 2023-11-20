//
//  PercentCompleteWidget.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 7/13/23.
//
import WidgetKit
import SwiftUI
import DriveLoggerKit
import DriveLoggerUI
import SwiftData

struct PercentCompleteWidgetView : View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DLDrive.startTime, order: .reverse) private var drives: [DLDrive]
    var entry: Provider.Entry

    var body: some View {
        VStack {
            PercentCompleteStatCard(goal: entry.goal ?? 60*60*50, statistics: DriveLoggerStatistics(drives: drives), widgetMode: true)
        }
    }
}

struct PercentCompleteWidget: Widget {
    let kind: String = "PercentComplete"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
         
            PercentCompleteWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget).modelContainer(for: [DLDrive.self])
           
        }
        .configurationDisplayName("Percent Complete Widget")
        .description("This is an example widget.")
    }
}
