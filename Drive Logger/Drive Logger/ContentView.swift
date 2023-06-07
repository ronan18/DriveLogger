//
//  ContetView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/3/23.
//

import SwiftUI
import SwiftData
import DriveLoggerCore

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scene
    @Query private var appState: [AppState]
    
    var body: some View {
        Group {
            if (appState.first?.driving ?? false) {
                DrivingView()
            } else {
                NavigationView {
                    HomeView()
                }
            }
        }.onAppear {
           
            if self.appState.isEmpty {
                modelContext.insert(AppState(firstBoot: true))
                
                print("appstate created")
            } else {
                print("appstate exists")
                self.appState.first!.intAppStateContext()
            }
        }.onChange(of: scene) {(initial, scene) in
            print("scene change", initial, scene)
            if scene == .background {
                guard  modelContext.hasChanges else {
                    print("no changes")
                    return
                }
                do {
                   try modelContext.save()
                    print("saved model")
                } catch {
                    print("error saving model")
                }
            }
            
        }
    }
 
}


struct ContetView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().modelContainer(previewContainer)
    }
}
