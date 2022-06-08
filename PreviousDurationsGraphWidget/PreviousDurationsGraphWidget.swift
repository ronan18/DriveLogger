//
//  PreviousDurationsGraphWidget.swift
//  PreviousDurationsGraphWidget
//
//  Created by Ronan Furuta on 6/8/22.
//

import WidgetKit
import SwiftUI
import DriveLoggerCore
import DriveLoggerServicePackage
import Charts

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), state: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let dlService = DriveLoggerService()
        var state = dlService.retreiveState()
        state = dlService.computeStatistics(state)
        let entry = SimpleEntry(date: Date(), state: state)
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let dlService = DriveLoggerService()
        var state = dlService.retreiveState()
        state = dlService.computeStatistics(state)
        
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

struct PreviousDurationEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    let dlService = DriveLoggerService()
    var average: Bool
    var axis: Bool
    var label: String?
    init(entry: Provider.Entry) {
        self.entry = entry
        self.average = true
        self.axis = false
        self.label = nil
        print("WIDGET FAMILY", widgetFamily)
        if widgetFamily == .systemSmall {
            print("WIDGET FAMILY SMALL")
            self.average = false
            self.axis = false
            self.label = "Previous drives"
        }
        
    }
    var body: some View {
     //   Text("avg:\(average.description) axis:\(axis.description) lbl:\(label?.description ?? "nil") fam:\(widgetFamily.description)").font(.caption2)
        if (entry.state != nil) {
            ChartView(data: entry.state!, average: average, axis: widgetFamily == .systemSmall ? false : true, label: widgetFamily == .systemSmall ? "Drives" : nil).padding()
        } else {
            Text("farts").redacted(reason: .placeholder)
        }
        
    }
}

@main
struct PreviousDuration: Widget {
    
    let kind: String = "PreviousDurationGraph"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PreviousDurationEntryView(entry: entry)
        }
        .configurationDisplayName("Previous Durations Graph")
        .description("View a graph of your previous drives by day")
    }
}

struct PreviousDuration_Previews: PreviewProvider {
    static var previews: some View {
        PreviousDurationEntryView(entry: SimpleEntry(date: Date(), state: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
