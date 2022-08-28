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
                            
                        }.font(.headline).foregroundColor(.gray).multilineTextAlignment(.center)
                        
                    } else {
                        HStack {
                            
                            Text("\(Image(systemName: "location.fill")) none")
                        }.font(.subheadline).foregroundColor(.gray)
                    }
                    if #available(iOS 16.0, *) {
                        if (self.appState.currentSun != nil) {
                            HStack(alignment: .lastTextBaseline) {
                                Image(systemName: "sunrise")
                                Text(self.appState.currentSun?.sunriseTime ?? Date(), style: .time)
                                if (self.appState.currentWeather != nil) {
                                    HStack(spacing: 0) {
                                        Image(systemName: self.appState.currentWeather?.current.symbolName ?? "cloud")
                                        Text(self.appState.currentWeather?.current.condition.description ?? "")
                                        
                                        Text(self.appState.currentWeather?.current.temperature.formatted() ?? "").padding(.leading, 5)
                                    }.padding(.horizontal)
                                } else {
                                    Spacer().frame(width: 25)
                                }
                                
                                Image(systemName: "sunset")
                                Text(self.appState.currentSun?.sunsetTime ?? Date(), style: .time)
                            }.font(.subheadline).foregroundColor(.gray).padding(.bottom).padding(.top, 5)
                        }
                    }
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
