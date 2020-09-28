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
                                //Text(String(Int(geometry.size.height)))
                    
                                   /* HStack {
                                        Spacer()
                                        NavigationLink(
                                            destination: Text("Destination"),
                                            label: {
                                                Image(systemName: "gearshape").font(.headline)
                                            }).foregroundColor(.black)
                                        
                                    }.padding(.trailing).frame(height: 10)*/
                                   
                                if (appState.dlService.displayTimeInterval(appState.state.totalTime).value == "0") {
                                    TimeStat(value: appState.dlService.displayTimeInterval(appState.state.totalTime).value, unit: appState.dlService.displayTimeInterval(appState.state.totalTime).unit, description: "Time Driven").padding(.bottom, 30).padding(.top, 20)
                                } else {
                                    TimeStat(value: appState.dlService.displayTimeInterval(appState.state.totalTime).value, unit: appState.dlService.displayTimeInterval(appState.state.totalTime).unit, description: self.appState.state.timeBreakdown).padding(.bottom, 30).padding(.top, 20)
                                }
                                
                                HStack {
                                    Text("recent drives").font(.headline)
                                    Spacer()
                                    NavigationLink(destination: DriveListView(), tag: 1, selection: self.$appState.viewAllDrivesScreen) {
                                        Text("show more")
                                    }
                                }.padding(.horizontal)
                                if (appState.state.drives.count > 0) {
                                    VStack {
                                        if (appState.state.drivesSortedByDate.count > self.recentDrivesLimit) {
                                            ForEach(appState.state.drivesSortedByDate.prefix(through: self.recentDrivesLimit - 1)) { drive in
                                                DriveCard(drive, action: {drive in self.presentedDrive = drive;
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
                                    }.frame(minHeight: self.recentDrivesListHeight)
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
                                
                                HStack {
                                    Text("statistics").font(.headline)
                                    Spacer()
                                    
                                }.padding(.top, 20).padding(.horizontal)
                                HStack {
                                    ProgressStatCard(width: geometry.size.width, value: Double(appState.state.percentComplete), unit: "%", description: "complete")
                                    Spacer()
                                    StatCard(width: geometry.size.width, value: appState.dlService.displayTimeInterval(appState.state.averageDriveDuration).value, unit: appState.dlService.displayTimeInterval(appState.state.averageDriveDuration).unit, description: "average drive duration")
                                }.padding(.horizontal)
                                Spacer()
                            }
                            Spacer().frame(height: 90)
                        }.edgesIgnoringSafeArea(.bottom)
                        VStack {
                            Spacer()
                            ZStack{
                                
                                
                                VisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
                                    .edgesIgnoringSafeArea(.all)
                                Border()
                                HStack {
                                    BlackButton("Start Drive", action: {
                                        self.appState.startDrive()
                                    })
                                }.padding()
                                
                            }.frame(height:90)
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
            }.environment(\.colorScheme, .light).preferredColorScheme(.light).onAppear {
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
        }.environment(\.colorScheme, .light).preferredColorScheme(.light)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


