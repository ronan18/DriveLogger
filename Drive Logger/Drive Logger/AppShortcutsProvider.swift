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
        
       
    }
}
 
