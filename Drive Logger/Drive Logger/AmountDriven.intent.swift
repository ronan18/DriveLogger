//
//  HowmuchLonger.intent.swift
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
struct AmountDrivenIntent: AppIntent {
    static var title: LocalizedStringResource = "Amount Driven"
    static var description =
           IntentDescription("See how much you have driven so far. Returns time driven in seconds.")

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
        print("app intent",statistics.totalDriveTime)
        let formatter = DateComponentsFormatter()

        formatter.unitsStyle = .spellOut
        formatter.allowedUnits = [.hour, .minute]
        
        return .result(value: statistics.totalDriveTime, dialog: IntentDialog(.init(stringLiteral: formatter.string(from: statistics.totalDriveTime) ?? statistics.totalDriveTime.formatedForDrive())), content: {
            TimeDrivenTodayStatCard(drivenTotal: statistics.totalDriveTime.formatedForDrive(), drives: drives ?? [], widgetMode: true).padding()
        })
        
         
        
    
     
    }
  
    static var openAppWhenRun: Bool = false
}
