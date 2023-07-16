//
//  DLWidgetEntry.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 7/14/23.
//

import Foundation
import WidgetKit
import DriveLoggerKit
public struct Provider: TimelineProvider {
    public func placeholder(in context: Context) -> DLWidgetEntry {
        
        DLWidgetEntry(date: Date(), goal: DLDiskService().readUserPreferences()?.goal)
    }

    public  func getSnapshot(in context: Context, completion: @escaping (DLWidgetEntry) -> ()) {
        let entry = DLWidgetEntry(date: Date(), goal: DLDiskService().readUserPreferences()?.goal)
        completion(entry)
    }

    public  func getTimeline(in context: Context, completion: @escaping (Timeline<DLWidgetEntry>) -> ()) {
       

       

        let timeline = Timeline(entries: [DLWidgetEntry(date: Date(), goal: DLDiskService().readUserPreferences()?.goal)], policy: .after(Date(timeIntervalSinceNow: 60*60*5)))
        completion(timeline)
    }
    public init() {
        
    }
}

public struct DLWidgetEntry: TimelineEntry {
    public let date: Date
    public let goal: TimeInterval?
    public init(date: Date, goal: TimeInterval?) {
        self.date = date
        self.goal = goal
    }

}
