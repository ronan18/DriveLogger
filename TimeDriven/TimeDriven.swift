//
//  TimeDriven.swift
//  TimeDriven
//
//  Created by Ronan Furuta on 9/24/20.
//

import WidgetKit
import SwiftUI
import DriveLoggerCore


import DriveLoggerServicePackage
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), state: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let dlService = DriveLoggerService()
        var state = dlService.retreiveState()
        
      let entry = SimpleEntry(date: Date(), state: state)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let dlService = DriveLoggerService()
        var state = dlService.retreiveState()
        
      let entry = SimpleEntry(date: Date(), state: state)
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
       

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let state: DriveLoggerAppState?
}

struct TimeDrivenEntryView : View {
    var entry: Provider.Entry
    let dlService = DriveLoggerService()
    let desc: String
    init(entry: Provider.Entry) {
        if (entry.state != nil) {
            if (entry.state!.timeBreakdown == "") {
                desc = "time driven"
            } else {
                desc = entry.state!.timeBreakdown
            }
        } else {
            desc = "time driven"
        }
        
        self.entry = entry
    }
    var body: some View {
        if (entry.state != nil) {
            TimeStat(value: dlService.displayTimeInterval(entry.state!.totalTime).value, unit:  dlService.displayTimeInterval(entry.state!.totalTime).unit, description: desc)
        } else {
            TimeStat(value: "12", unit: "hr", description: "7hr day 5hr night").redacted(reason: .placeholder)
        }
      
    }
}

@main
struct TimeDriven: Widget {
    let kind: String = "TimeDriven"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TimeDrivenEntryView(entry: entry)
        }
        .configurationDisplayName("Time Driven")
        .description("See how much time you have been driving at a glance")
    }
}

struct TimeDriven_Previews: PreviewProvider {
    static var previews: some View {
        TimeDrivenEntryView(entry: SimpleEntry(date: Date(), state: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
