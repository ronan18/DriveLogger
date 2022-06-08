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
    @State var exportDataModal = false
    @State var importDataModal = false
    @State private var errorImporting = false
    @State private var confirmImport = false
    @State private var importState: DriveLoggerAppState? = nil
    @State private var setGoalTime = false
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
                ToolbarItem(placement:.navigationBarTrailing, content:{
                    Menu {
                        Button(action: {
                            self.exportDataModal = true
                        }) {
                            Label("Export Data", systemImage: "square.and.arrow.up.on.square")
                        }
                        
                        Button(action: {
                            self.importDataModal = true
                        }) {
                            Label("Import Data", systemImage: "square.and.arrow.down.on.square")
                        }
                        Button(action: {
                            self.setGoalTime = true
                        }) {
                            Label("Change Driving Goal", systemImage: "timer")
                        }
                    }
                    label: {
                        Label("Add", systemImage: "ellipsis").padding()
                    }
                    
                })
         
                 ToolbarItem(placement:.navigationBarTrailing, content:{
                 Button(action: {
                 self.newDriveModal = true
                 }) {
                 Image(systemName: "plus").padding()
                 }
                 })
            })
            Text("").fileExporter(isPresented: self.$exportDataModal, document: self.appState.dataExport,  contentType: .plainText,
                                  defaultFilename: "DriveLoggerData") {result in
                if case .success = result {
                    // Handle success.
                } else {
                    // Handle failure.
                }
            }
            .fileImporter(
                isPresented: self.$importDataModal,
                allowedContentTypes: [.plainText],
                allowsMultipleSelection: false
            ) { result in
                print("load state", result)
                
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    if (CFURLStartAccessingSecurityScopedResource(selectedFile as CFURL)) {
                    print("load state got file", selectedFile)
                    let data = try Data(contentsOf: selectedFile)
                    guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                    
                    print("load got state", message)
                    let decoder = JSONDecoder()
                    let state = try decoder.decode(DriveLoggerAppState.self, from: data)
                        CFURLStopAccessingSecurityScopedResource(selectedFile as CFURL)
                        self.confirmImport = true
                        self.importState = state
                  
                        
                    } else {
                        print("Permission error!")
                        self.errorImporting = true
                    }
                } catch {
                    print("error getting load state" ,error)
                    self.errorImporting = true
                    // Handle failure.
                }
            }.alert(isPresented: self.$errorImporting) {
                Alert(title: Text("Error Importing Data"), message: Text("there was an error importing your previous drives. Try rexporting them. If this problem persists, please contact support and send your database file."), dismissButton: .default(Text("OK")))
            }.actionSheet(isPresented: self.$confirmImport) {
                ActionSheet(title: Text("Are you sure you want to import your previous drives"), message: Text("This will erase all of your current data"), buttons: [.cancel(Text("cancel")), .destructive(Text("import"), action: {
                    guard self.importState != nil else {return}
                    self.appState.state = self.importState!
                    self.appState.dlService.saveState(self.importState!)
                })])
            }
            Text("").sheet(isPresented: self.$setGoalTime, content: {
                OboardingGoal(next: {val in
                    self.appState.updateGoalTime(val)
                    self.setGoalTime = false
                }, confirmText: true, defaultVal: Int(self.appState.state.goalTime / 60 / 60))
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
