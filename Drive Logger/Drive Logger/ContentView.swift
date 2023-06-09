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
   @State var appState = AppState()
    init () {
      
        
    }
    var body: some View {
        Group {
            if (appState.currentDrive != nil) {
                DrivingView(appState: appState)
            } else {
                NavigationView {
                    HomeView(appState: appState)
                }.inspector(isPresented: self.$appState.driveEditorPresented, content: {
                    
                    DriveEditorView(drive: self.$appState.driveToBeEdited, appState: self.appState)
               
                
            })
            }
        }.onAppear {
            self.appState.context = modelContext
            print("added appstate model context")
         
        }.onChange(of: scene) {(initial, scene) in
            print("scene change", initial, scene)
            if (scene == .background || scene == ScenePhase.inactive) {
               
                guard  modelContext.hasChanges else {
                    print("no changes")
                    return
                }
                do {
                 //  try modelContext.save()
                 //   print("saved model")
                } catch {
                  //  print("error saving model")
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
