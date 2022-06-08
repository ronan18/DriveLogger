//
//  ContentView.swift
//  DriveLogger
//
//  Created by Ronan Furuta on 9/24/20.
//

import SwiftUI
import DriveLoggerCore
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        if (self.appState.appScreen == .home) {
            HomeView()
        } else if (self.appState.appScreen == .drive) {
            DriveView()
        } else {
            Onboarding(complete: {goal in appState.startFromOnboard(goal)})
        }

        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
