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
    @Query(sort: \.startTime, order: .reverse) private var drives: [Drive]
    init () {
      
        
    }
    var body: some View {
        NavigationView {
            if (appState.currentDrive != nil) {
                DrivingView(appState: appState)
            } else {
                 
                    HomeView(appState: appState)
                
            }
        }.inspector(isPresented: self.$appState.driveEditorPresented, content: {
            
            DriveEditorView(drive: self.$appState.driveToBeEdited, appState: self.appState)
            
            
        }).onAppear {
            self.appState.context = modelContext
            print("added appstate model context")
            self.appState.statistics.updateStatistics(drives: drives)
            print("DLSTAT triggered stat update on launch", drives.count)
           
            Task {
                await testWeather()
            }
         
        }.onChange(of: scene) {(initial, scene) in
            print("scene change", initial, scene)
            if (scene == .background || scene == ScenePhase.inactive) {
               
                guard  modelContext.hasChanges else {
                    print("no changes")
                    return
                }
               
            }
            
        }.onChange(of: drives) {_,new in
            print("DLSTAT drives change", new.count)
            self.appState.statistics.updateStatistics(drives: new)
        }.onChange(of: self.appState.driveEditorPresented, {old, new in
            if (new == false) {
                print("DLSTAT drive editor closed", new)
                self.appState.statistics.updateStatistics(drives: drives)
            }
        })
    }
 
}


struct ContetView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().modelContainer(previewContainer)
    }
}
