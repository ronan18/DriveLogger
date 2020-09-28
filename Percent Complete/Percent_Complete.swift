//
//  Percent_Complete.swift
//  Percent Complete
//
//  Created by Ronan Furuta on 9/27/20.
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


struct Percent_CompleteEntryView : View {
    var entry: Provider.Entry
    let dlService = DriveLoggerService()
    let desc: String
    init (entry: Provider.Entry) {
        self.entry = entry
        if let state = entry.state {
        self.desc = "\(dlService.displayTimeInterval(state.totalTime).value)\(dlService.displayTimeInterval(state.totalTime).unit) driven"
        } else {
            self.desc = "loading"
        }
    }
    var body: some View {
        if (entry.state == nil) {
            ProgressStat(value: 0, unit: "%", description: desc).redacted(reason: .placeholder).frame(maxWidth: 150)
        } else {
            ProgressStat(value: Double(entry.state!.percentComplete), unit: "%", description: desc).frame(maxWidth: 150)
        }
        
    }
}

@main
struct Percent_Complete: Widget {
    let kind: String = "Percent_Complete"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Percent_CompleteEntryView(entry: entry)
        }
        .configurationDisplayName("Percent Complete")
        .description("View how close you are to completing your driving goal")
    }
}

struct Percent_Complete_Previews: PreviewProvider {
    static var previews: some View {
        Percent_CompleteEntryView(entry: SimpleEntry(date: Date(), state: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
