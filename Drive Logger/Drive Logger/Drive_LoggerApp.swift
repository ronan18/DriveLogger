//
//  Drive_LoggerApp.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/5/23.
//

import SwiftUI
import SwiftData
import DriveLoggerCore

@main
struct Drive_LoggerApp: App {
   
    var body: some Scene {
        WindowGroup {
            ContentView().modelContainer(for: [Drive.self], isUndoEnabled: true)
        }
        
    }
}
