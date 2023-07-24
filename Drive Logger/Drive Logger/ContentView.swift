//
//  ContetView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/3/23.
//

import SwiftUI
import SwiftData
import DriveLoggerKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scene
    @State var appState = AppState.shared
    @Query(sort: \.startTime, order: .reverse) private var drives: [DLDrive]
    init () {
      
        
    }
    var body: some View {
        NavigationView {
            if (self.appState.setUpFlow) {
                SetupScreen(appState: appState)
            } else if (appState.currentDrive != nil) {
                DrivingView(appState: appState)
            } else {
                 
                    HomeView(appState: appState).modelContext(modelContext)
                
            }
        }.inspector(isPresented: self.$appState.driveEditorPresented, content: {
            
            DriveEditorView(drive: self.$appState.driveToBeEdited, appState: self.appState)
            
            
        }).onAppear {
            self.appState.context = modelContext
            print("added appstate model context", modelContext.container.schema)
            self.appState.statistics.updateStatistics(drives)
            print("DLSTAT triggered stat update on launch", drives.count)
           
            Task {
                await testWeather()
            }
         
        }.onChange(of: scene) {(initial, scene) in
            print("scene change", initial, scene)
            if (scene == .background || scene == ScenePhase.inactive) {
               
                self.appState.reloadWidgets(hash: self.appState.hashDrives(drives: self.drives))
               
            }
            
        }.onChange(of: drives) {_,new in
            print("DLSTAT drives change", new.count)
            Task {
                 self.appState.statistics.requestStatisticsUpdate(context: self.modelContext)
            }
        }.onChange(of: self.appState.driveEditorPresented, {old, new in
            if (new == false) {
                print("DLSTAT drive editor closed", new)
                self.appState.driveToBeEdited = DLDrive(sampleData: true)
                Task {
                     self.appState.statistics.requestStatisticsUpdate(context: self.modelContext)
                }
            }
        })
    }
 
}


struct ContetView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().modelContainer(previewContainer)
    }
}
