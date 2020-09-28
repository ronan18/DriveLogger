//
//  DriveListView.swift
//  DriveLogger
//
//  Created by Ronan Furuta on 9/24/20.
//

import SwiftUI
import DriveLoggerCore
import DriveLoggerServicePackage
struct DriveListView: View {
    @EnvironmentObject var appState: AppState
    @State var presentedDrive: Drive = Drive(startTime: Date(), endTime: Date(), location: "loading")
    @State var driveEditor = false
    @State var newDriveModal = false
    var body: some View {
        ZStack {
            VStack {
             
                
                if (appState.state.drives.count == 0) {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("No Logged Drives Yet").font(.headline)
                            
                            Spacer()
                        }.padding(.bottom, 5)
                        
                        Text("Tap the plus to manually log a drive")
                        Spacer()
                    }.padding().multilineTextAlignment(.center).foregroundColor(.gray)
                } else {
                    ScrollView {
                        
                        VStack {
                            ForEach(appState.state.drivesSortedByDate) {drive in
                                DriveCard(drive, action: {drive in self.presentedDrive = drive;
                                            self.appState.computeStatistics()
                                            self.driveEditor = true})
                            }
                            
                            
                        }.padding()
                        
                    }
                }
            }.navigationTitle("All Drives").toolbar(content: {
                ToolbarItem(content:{
                    Button(action: {
                        self.newDriveModal = true
                    }) {
                        Image(systemName: "plus")
                    }
                })
            })
            Text("").sheet(isPresented: self.$newDriveModal, content: {
                DriveEditor(nil, save: {drive in
                    self.newDriveModal = false
                    self.appState.logDrive(drive)
                }, cancel: {self.newDriveModal = false})
        })
            Text("").sheet(isPresented: self.$driveEditor, content: {
                if (self.presentedDrive != nil) {
                    DriveEditor(self.presentedDrive, save: {drive in
                        self.appState.updateDrive(drive)
                        self.driveEditor = false
                    }, cancel: {self.driveEditor = false}, delete: {drive in self.appState.deleteDrive(drive); self.driveEditor = false}, editDrive: true)
                }
                
            })
        }.onAppear {
            self.appState.logDrivesViewed()
           // self.appState.viewAllDrivesScreen = nil
        }
    }
       
}

struct DriveListView_Previews: PreviewProvider {
    static var previews: some View {
        DriveListView()
    }
}
