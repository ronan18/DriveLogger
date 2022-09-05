//
//  HomeView.swift
//  DriveLogger
//
//  Created by Ronan Furuta on 9/24/20.
//

import SwiftUI
import DriveLoggerCore
import DriveLoggerServicePackage
struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State var presentedDrive: Drive = Drive(startTime: Date(), endTime: Date(), location: "loading")
    @State var driveEditor = false
    @State var recentDrivesLimit = 3
    @State var recentDrivesListHeight: CGFloat = 200
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                NavigationView {
                    ZStack {
                        VStack {
                            ScrollView {
                                if (appState.dlService.displayTimeInterval(appState.state.totalTime).value == "0") {
                                    TimeStat(value: appState.dlService.displayTimeInterval(appState.state.totalTime).value, unit: appState.dlService.displayTimeInterval(appState.state.totalTime).unit, description: "Time Driven").padding(.bottom, 30).padding(.top, 20)
                                } else {
                                    TimeStat(value: appState.dlService.displayTimeInterval(appState.state.totalTime).value, unit: appState.dlService.displayTimeInterval(appState.state.totalTime).unit, description: self.appState.state.timeBreakdown).padding(.bottom, 30).padding(.top, 20)
                                }
                                
                                HStack {
                                    Text("recent drives").font(.headline)
                                   
                                    Spacer()
                                    NavigationLink(destination: DriveListView(), tag: 1, selection: self.$appState.viewAllDrivesScreen) {
                                        Text("show all")
                                    }
                                }.padding(.horizontal)
                                if (self.appState.loading == .preparingData) {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            VStack {
                                                ProgressView()
                                                Text("Loading Drives")
                                            }
                                            Spacer()
                                        }.padding(.bottom, 5)
                                       
                                    }.padding().frame(height: 200).multilineTextAlignment(.center).foregroundColor(.gray)
                                   
                                } else {
                                    if (appState.state.drives.count > 0) {
                                        VStack {
                                            if (appState.state.drivesSortedByDate.count > self.recentDrivesLimit) {
                                                ForEach(appState.state.drivesSortedByDate.prefix(through: self.recentDrivesLimit - 1)) { drive in
                                                    DriveCard(drive, action: {drive in self.presentedDrive = drive;
                                                        //TODO: this is causing the editor to load slowly. Need to push update from appstate
                                                        print("presneting drive", drive.location)
                                                        self.appState.computeStatistics()
                                                        self.driveEditor = true}).padding(.vertical, 2.5).padding(.horizontal)
                                                    
                                                }
                                            } else {
                                                ForEach(appState.state.drivesSortedByDate) { drive in
                                                    DriveCard(drive, action: {drive in self.presentedDrive = drive;
                                                        self.appState.computeStatistics()
                                                        self.driveEditor = true}).padding(.vertical, 2.5).padding(.horizontal)
                                                    
                                                }
                                            }
                                            
                                            Spacer()
                                        }.frame(minHeight: self.recentDrivesListHeight).onAppear {
                                            print("HANG: drives showedup", Date().timeIntervalSince(self.appState.initTime))
                                        }
                                    } else {
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Text("No Logged Drives Yet").font(.headline)
                                                
                                                Spacer()
                                            }.padding(.bottom, 5)
                                            Text("Tap Start Drive to begin recording a drive").padding(.bottom, 1).lineLimit(2)
                                            Text("Tap show more than plus to manually log a drive")
                                        }.padding().frame(height: 200).multilineTextAlignment(.center).foregroundColor(.gray)
                                    }
                                }
                                
                                HStack {
                                    Text("statistics").font(.headline)
                                    Spacer()
                                    
                                }.padding(.top, 20).padding(.horizontal)
                                HStack {
                                    ProgressStatCard(width: geometry.size.width, value: Double(appState.state.percentComplete), unit: "%", description: "complete")
                                    Spacer()
                                    StatCard(width: geometry.size.width, value: appState.dlService.displayTimeInterval(appState.state.averageDriveDuration).value, unit: appState.dlService.displayTimeInterval(appState.state.averageDriveDuration).unit, description: "average drive duration")
                                }.padding(.horizontal).padding(.bottom)
                                
                                HStack {
                                    StatCard(width: geometry.size.width, value: appState.dlService.displayTimeInterval(appState.state.timeToday ?? 0).value, unit: appState.dlService.displayTimeInterval(appState.state.timeToday ?? 0).unit, description: "time driven today")
                                    Spacer()
                                    StatCard(width: geometry.size.width, value: appState.dlService.displayTimeInterval(appState.state.goalTime - appState.state.totalTime).value, unit: appState.dlService.displayTimeInterval(appState.state.goalTime - appState.state.totalTime).unit, description: "until goal completion")
                                }.padding(.horizontal).padding(.bottom)
                                if (self.appState.chartSatisticsReady) {
                                    VStack {
                                        ChartCard(data: self.appState.state).padding(.horizontal).frame(height: 250).padding(.bottom)
                                        PercentOfGoalChart(data: self.appState.state).padding().card().padding(.horizontal).frame(height: 250)
                                    }
                                } else {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            VStack {
                                                ProgressView()
                                                Text("Preparing Charts")
                                            }
                                            Spacer()
                                        }.padding().foregroundColor(.gray)
                                        
                                    }
                                }
                               
                                Spacer()
                                
                                
                                Text("Drive Logger is an open source app developed by **[Ronan Furuta](https://ronan.link/K9cd6Q)**").font(.footnote).multilineTextAlignment(.center).padding()
                                
                                Spacer()
                                
                                
                            }
                            Spacer().frame(height: 120)
                        }.edgesIgnoringSafeArea(.bottom)
                        VStack {
                            Spacer()
                            if #available(iOS 15.0, *) {
                                VStack{
                                    
                                    Border()
                                    
                                    HStack {
                                        BlackButton("Start Drive", action: {
                                            self.appState.dlService.hapticResponse()
                                            self.appState.startDrive()
                                        }, stayBlack: true)
                                    }.padding()
                                    
                                }.frame(height:90).background(.ultraThinMaterial)
                            } else {
                                
                                ZStack{
                                    
                                    
                                    VisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
                                        .edgesIgnoringSafeArea(.all)
                                    
                                    Border()
                                    HStack {
                                        BlackButton("Start Drive", action: {
                                            self.appState.dlService.hapticResponse()
                                            self.appState.startDrive()
                                        }, stayBlack: false)
                                    }.padding()
                                    
                                }.frame(height:90)
                            }
                        }
                        
                        
                    }.navigationBarTitle("")
                        .navigationBarHidden(true)
                }.navigationViewStyle(StackNavigationViewStyle())
                Text("").sheet(isPresented: self.$driveEditor, content: {
                    if (self.presentedDrive != nil) {
                        DriveEditor(self.presentedDrive, save: {drive in
                            self.appState.updateDrive(drive)
                            self.driveEditor = false
                        }, cancel: {self.driveEditor = false}, delete: {drive in self.appState.deleteDrive(drive); self.driveEditor = false}, editDrive: true)
                    }
                    
                })
                Text("").sheet(isPresented: self.$appState.driveEditor, content: {
                    if (self.appState.presentedDrive != nil) {
                        DriveEditor(self.appState.presentedDrive, save: {drive in
                            self.appState.logDrive(drive)
                            self.appState.driveEditor = false
                        }, cancel: {self.appState.driveEditor = false})
                    }
                    
                })
            }.onAppear {
                print(geometry.size.height)
                if (geometry.size.height < 650) {
                    self.recentDrivesLimit = 2
                    self.recentDrivesListHeight = 150
                }
                if (geometry.size.height < 550) {
                    self.recentDrivesLimit = 1
                    self.recentDrivesListHeight = 80
                }
                
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AppState())
    }
}


