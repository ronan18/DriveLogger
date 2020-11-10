//
//  DriveView.swift
//  DriveLogger
//
//  Created by Ronan Furuta on 9/24/20.
//

import SwiftUI
import DriveLoggerCore
struct DriveView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    TimeStat(value: "", unit: "", description: "current drive duration", date: self.appState.currentDrive?.startTime)
                    Spacer()
                }
                Spacer()
                if (self.appState.currentCity != "") {
                    HStack {
                        Text("\(Image(systemName: "location.fill")) \(self.appState.currentCity)")
                        
                      /*
                       
                        if(self.appState.startCityName != self.appState.currentCity) {
                            VStack {
                            Text("\(Image(systemName: "flag.fill")) \(self.appState.startCityName)")
                                Text("to").padding(.vertical, 5)
                                Text("\(Image(systemName: "location.fill")) \(self.appState.currentCity)")
                            }
                            //Text(self.appState.currentCity)
                        } else {
                            Text("\(Image(systemName: "location.fill")) \(self.appState.startCityName)")
                        }*/
                    }.font(.subheadline).foregroundColor(.gray).multilineTextAlignment(.center)
                } else {
                    HStack {
                     
                        Text("\(Image(systemName: "location.fill")) none")
                    }.font(.subheadline).foregroundColor(.gray)
                }
                Spacer()
                HStack {
                    StatCard(width: geometry.size.width, value: String(appState.state.percentComplete), unit: "%", description: "complete")
                    StatCard(width: geometry.size.width, value: appState.dlService.displayTimeInterval(appState.state.totalTime).value, unit: appState.dlService.displayTimeInterval(appState.state.totalTime).unit, description: "completed")
                }
                Spacer().frame(height: 15)
                HStack {
                    StatCard(width: geometry.size.width, value: appState.dlService.displayTimeInterval(appState.state.dayDriveTime).value, unit: appState.dlService.displayTimeInterval(appState.state.dayDriveTime).unit, description: "day driving")
                    StatCard(width: geometry.size.width, value: appState.dlService.displayTimeInterval(appState.state.nightDriveTime).value, unit: appState.dlService.displayTimeInterval(appState.state.nightDriveTime).unit, description: "night driving")
                }
                Spacer()
               
                BlackButton("End Drive", action: {
                    self.appState.dlService.hapticResponse()
                                self.appState.endDrive()
                    
                })
            }.padding()
        }
    }
}

struct DriveView_Previews: PreviewProvider {
    static var previews: some View {
        DriveView()
    }
}
