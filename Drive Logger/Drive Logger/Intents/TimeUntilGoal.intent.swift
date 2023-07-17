//
//  TimeUntilGoal.intent.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 7/16/23.
//

import Foundation

import AppIntents
import SwiftData
import DriveLoggerKit
import SwiftUI
import DriveLoggerUI
struct TimeUntilGoalIntent: AppIntent {
    static var title: LocalizedStringResource = "Time Until Goal Achieved"
    static var description =
           IntentDescription("See how much longer you have until you reach your goal.")

    @MainActor
    func perform() async throws -> some IntentResult {
      //  Navigator.shared.openShelf(.currentlyReading)
        print("app intent Time Till Goal")
        let container = try ModelContainer(
            for: [DLDrive.self]
        )
        let context = container.mainContext
        let drivesFetch = FetchDescriptor<DLDrive>()
       

            let drives = try? context.fetch(drivesFetch)
        
    
            let statistics = DriveLoggerStatistics(drives: drives ?? [])
        let goal: Double = DLDiskService().readUserPreferences()?.goal ?? 50*60*60
        print("app intent",statistics.totalDriveTime)
        let result: TimeInterval = goal - statistics.totalDriveTime
        return .result(value: result, dialog: IntentDialog(.init(stringLiteral: "\(result.formatedForDrive())")), content: {
            TimeUntilGoalStatCard(statistics: statistics, goal: goal, widgetMode: true).padding()
        })
        
         
        
    
     
    }
  
    static var openAppWhenRun: Bool = false
}
