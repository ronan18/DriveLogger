//
//  DLWidgets.swift
//  DLWidgets
//
//  Created by Ronan Furuta on 7/13/23.
//

import WidgetKit
import SwiftUI
import DriveLoggerKit
import DriveLoggerUI
import SwiftData

struct DLWidgetsEntryView : View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DLDrive.startTime, order: .reverse) private var drives: [DLDrive]
    var entry: Provider.Entry

    var body: some View {
        VStack {
            TimeDrivenTodayStatCard(drivenToday: DriveLoggerStatistics(drives: drives).timeDrivenToday, widgetMode: true)
        }
    }
}

struct DrivenTodayWidget: Widget {
    let kind: String = "DrivenToday"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
         
                DLWidgetsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget).modelContainer(for: [DLDrive.self])
           
        }
        .configurationDisplayName("Time Driven Today")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    DrivenTodayWidget()
} timeline: {
    DLWidgetEntry(date: .now, goal: 50*60*60)
   
}
