//
//  PercentofGoal.intent.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 7/14/23.
//

import Foundation
import Foundation
import AppIntents
import SwiftData
import DriveLoggerKit
import SwiftUI
import DriveLoggerUI
struct PercentofGoalIntent: AppIntent {
    static var title: LocalizedStringResource = "Percent of Goal Driven"
    static var description =
           IntentDescription("See what percentage of your goal you have driven")

    @MainActor
    func perform() async throws -> some IntentResult {
      //  Navigator.shared.openShelf(.currentlyReading)
        print("app intent how much driven")
        let container = try ModelContainer(
            for: [Drive.self]
        )
        let context = container.mainContext
        let drivesFetch = FetchDescriptor<Drive>()
       

            let drives = try? context.fetch(drivesFetch)
        
    
            let statistics = DriveLoggerStatistics(drives: drives ?? [])
        let goal: Double = DLDiskService().readUserPreferences()?.goal ?? 50*60*60
        print("app intent",statistics.totalDriveTime)
        let result = statistics.totalDriveTime / goal
        return .result(value: result, dialog: IntentDialog(.init(stringLiteral: "\(Int(round(result * 100)))%")), content: {
            PercentCompleteStatCard(goal: goal, statistics: statistics, widgetMode: true).modelContainer(for: [Drive.self]).padding()
        })
        
         
        
    
     
    }
  
    static var openAppWhenRun: Bool = false
}

