//
//  Drive_LoggerApp.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/3/23.
//

import SwiftUI

@main
struct Drive_LoggerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
