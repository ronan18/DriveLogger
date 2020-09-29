//
//  DriveLoggerApp.swift
//  DriveLogger
//
//  Created by Ronan Furuta on 9/24/20.
//

import SwiftUI
import Intents
import Firebase
import FirebaseAnalytics
@main
struct DriveLoggerApp: App {
    @StateObject private var appState = AppState()
    @Environment(\.scenePhase) private var scenePhase
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appState).preferredColorScheme(.light).environment(\.colorScheme, .light).onContinueUserActivity("StartDriveIntent", perform: { userActivity in
                print("SIRI: Start Drive Intent Activated")
                self.appState.startDrive()
            }).onContinueUserActivity("StopDriveIntent", perform: { userActivity in
                print("SIRI: Stop Drive Intent Activated")
                self.appState.endDrive()
            }).onContinueUserActivity("ViewAllDrivesIntent", perform: { userActivity in
                print("SIRI: View all drives Intent Activated")
                self.appState.viewAllDrives()
            })
        }.onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .background {
                appState.dlService.upateWidgets(true)
            }
            
        }
    }
}
