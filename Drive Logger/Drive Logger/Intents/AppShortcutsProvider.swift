//
//  AppShortCutsProvider.swift
//  DriveLoggerKit
//
//  Created by Ronan Furuta on 7/9/23.
//

import Foundation
import AppIntents
struct DLAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: StartDrive(), phrases: ["Start Drive with \(.applicationName)", "Start a Drive with \(.applicationName)", "Begin Drive with \(.applicationName)", "Begin a Drive with \(.applicationName)"], shortTitle: "Start Drive", systemImageName: "car.rear")
        AppShortcut(intent: EndDrive(), phrases: ["End \(.applicationName) Drive", "Stop \(.applicationName) Drive", "End my \(.applicationName) Drive"], shortTitle: "End Drive", systemImageName: "flag.checkered")
        AppShortcut(intent: AmountDrivenIntent(), phrases: ["How much have I driven with \(.applicationName)", "How long have I driven with \(.applicationName)", "How much have I logged with \(.applicationName)"], shortTitle: "Amount Driven", systemImageName: "stopwatch")
        AppShortcut(intent: PercentofGoalIntent(), phrases: ["What percentage of my goal have I driven with \(.applicationName)"], shortTitle: "Perecent Complete", systemImageName: "percent")
        AppShortcut(intent: TimeUntilGoalIntent(), phrases: ["How much longer until I reach my \(.applicationName) goal?"], shortTitle: "Time Until Goal", systemImageName: "timer")
        
       
    }
}
 
