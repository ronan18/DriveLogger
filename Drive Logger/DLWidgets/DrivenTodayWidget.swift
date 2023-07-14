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

public struct Provider: TimelineProvider {
    public func placeholder(in context: Context) -> DLWidgetEntry {
        DLWidgetEntry(date: Date())
    }

    public  func getSnapshot(in context: Context, completion: @escaping (DLWidgetEntry) -> ()) {
        let entry = DLWidgetEntry(date: Date())
        completion(entry)
    }

    public  func getTimeline(in context: Context, completion: @escaping (Timeline<DLWidgetEntry>) -> ()) {
        var entries: [DLWidgetEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = DLWidgetEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

public struct DLWidgetEntry: TimelineEntry {
    public let date: Date

}

struct DLWidgetsEntryView : View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \.startTime, order: .reverse) private var drives: [Drive]
    var entry: Provider.Entry

    var body: some View {
        VStack {
            TimeDrivenTodayStatCard(drivenToday: DriveLoggerStatistics(drives: drives).timeDrivenToday.formatedForDrive(), drives: drives, widgetMode: true)
        }
    }
}

struct DrivenTodayWidget: Widget {
    let kind: String = "DrivenToday"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
         
                DLWidgetsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget).modelContainer(for: [Drive.self])
           
        }
        .configurationDisplayName("Time Driven Today")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    DrivenTodayWidget()
} timeline: {
    DLWidgetEntry(date: .now)
    DLWidgetEntry(date: .now)
}
