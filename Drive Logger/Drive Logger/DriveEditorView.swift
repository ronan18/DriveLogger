//
//  DriveEditorView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/6/23.
//

import SwiftUI
import DriveLoggerCore
import DriveLoggerUI
import SwiftData

struct DriveEditorView: View {
    @Binding var drive: Drive
    @State var appState: AppState
    var body: some View {
        
            Form {
                Section {
                    LabeledContent {
                        TextField("Start Location Name", text:  self.$drive.startLocationName, prompt: Text("Start location name"))
                    } label: {
                        Text("Name").font(.headline)
                      }
                    DatePicker("Time", selection: self.$drive.startTime, displayedComponents: [.date, .hourAndMinute])
                    
                    
                } header: {
                    Text("\(Image(systemName: "mappin.circle.fill")) Start")
                }
                Section {
                    LabeledContent {
                        TextField("End Location Name", text:  self.$drive.endLocationName, prompt: Text("End location name"))
                    } label: {
                        Text("Name").font(.headline)
                      }
                    DatePicker("Time", selection: self.$drive.endTime, displayedComponents: [.date, .hourAndMinute])
                    
                    
                } header: {
                    Text("\(Image(systemName: "flag.checkered")) Finish")
                }
                Section {
                    DatePicker("\(Image(systemName: "sunrise.fill")) Sunrise", selection: self.$drive.sunriseTime, displayedComponents: [ .hourAndMinute])
                    DatePicker("\(Image(systemName: "sunset.fill")) Sunset", selection: self.$drive.sunsetTime, displayedComponents: [ .hourAndMinute])
                    HStack {
                        Text("\(Image(systemName: "sun.max.circle.fill")) \(self.drive.dayDriveTime.formatedForDrive())")
                        Text("\(Image(systemName: "moon.stars.circle.fill")) \(self.drive.nightDriveTime.formatedForDrive())")
                    }
                } header: {
                    Text("\(Image(systemName: "sun.max")) Additional Data")
                }
                Section {
                    
                    DriveCard(self.drive, noShadow: true)
                }
                
              
            }.navigationTitle(drive.backupDriveString).toolbar {
                ToolbarItem(placement: .primaryAction, content: {
                    Button("Done") {
                        self.appState.driveEditorPresented = false
                    }
                })
            }
        
    }
}

struct DriveEditor_Previews: PreviewProvider {
    static var previews: some View {
        DriveEditorView(drive: .constant(Drive(sampleData: true)), appState: AppState()).modelContainer(previewContainer)
    }
}
