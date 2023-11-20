//
//  DriveEditorView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/6/23.
//

import SwiftUI
import DriveLoggerKit
import DriveLoggerUI
import SwiftData
import MapKit

struct DriveEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var position: MapCameraPosition = .automatic
    @State var drive: DLDrive
    @State var appState: AppState
    @State var deletionConfirmation: Bool = false
    public init(drive: DLDrive, appState: AppState) {
        self._appState = .init(initialValue: appState)
        self._drive = .init(initialValue: drive)
    }
    var body: some View {
        NavigationView {
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
                    //TODO: Limit Drive End to after start
                    
                } header: {
                    Text("\(Image(systemName: "flag.checkered")) Finish")
                }
                Section {
                    DatePicker("\(Image(systemName: "sunrise.fill")) Sunrise", selection: self.$drive.sunriseTime, displayedComponents: [ .hourAndMinute])
                    DatePicker("\(Image(systemName: "sunset.fill")) Sunset", selection: self.$drive.sunsetTime, displayedComponents: [ .hourAndMinute])
                    //TODO: Limit date sunset to after sunrise
                    HStack {
                        Text("\(Image(systemName: "sun.max.circle.fill")) \(self.drive.dayDriveTime.formatedForDrive())")
                        Text("\(Image(systemName: "moon.stars.circle.fill")) \(self.drive.nightDriveTime.formatedForDrive())")
                    }
                } header: {
                    Text("\(Image(systemName: "sun.max")) Additional Data")
                } footer: {
                    HStack(spacing: 0) {
                        Text("Learn more about ")
                        Link(destination: URL(string: "google.com")!, label: {Text("Weather Data Sources").underline()})
                        Spacer()
                    }.font(.footnote).foregroundColor(.gray)
                    
                }
                Section {
                    
                    DriveCard(self.drive, noShadow: true)
                    if (self.drive.startLocation != nil || self.drive.endLocation != nil) {
                        Map(position: $position,interactionModes: []) {
                            if (self.drive.startLocation != nil) {
                                Marker("start", coordinate: self.drive.startLocation!.coordinate)
                            }
                            if (self.drive.endLocation != nil) {
                                Marker("end", coordinate: self.drive.endLocation!.coordinate)
                            }
                            if (self.drive.route != nil) {
                                MapPolyline(self.drive.route!.tripPolyLine).stroke(.blue, style: mapStrokeStyle)
                            }
                            
                        }.frame(height: 200).cornerRadius(10)
                    }
                    if (self.drive.route?.averageSpeed != nil) {
                        Text("Average speed: \(Int(round(self.drive.route?.averageSpeed ?? 0)))mph")
                    }
                    //Text(self.drive.route?.debugDescription ?? "none")
                    
                    
                }
                
                Section {
                    Button("Delete Drive", role: .destructive, action: {
                        self.deletionConfirmation = true
                        
                    })
                }.confirmationDialog("Are you sure you want to delete this drive?", isPresented: self.$deletionConfirmation, titleVisibility: .visible, actions: {
                    Button("Delete Drive", role: .destructive) {
                        guard let context = drive.context else {
                            self.appState.driveEditorPresented = false
                            return
                        }
                        context.delete(drive)
                        self.appState.driveEditorPresented = false
                        self.appState.driveToBeEdited = nil
                    }
                    Button("Cancel", role: .cancel) {
                        self.deletionConfirmation = false
                    }
                })
                
                
            }.navigationTitle(String(localized: drive.backupDriveString)).toolbar {
                ToolbarItem(placement: .primaryAction, content: {
                    Button("Done") {
                        self.appState.driveEditorPresented = false
                        self.appState.driveToBeEdited = nil
                    }
                })
            }
        }
        
    }
}

struct DriveEditor_Previews: PreviewProvider {
    static var previews: some View {
        DriveEditorView(drive: DLDrive(sampleData:true),appState: AppState()).modelContainer(previewContainer)
    }
}

let mapStrokeStyle = StrokeStyle(lineWidth: 5, lineCap: .round)
