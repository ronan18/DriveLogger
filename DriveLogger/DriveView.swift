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
                    TimeStat(value: "", unit: "", description: "current drive duration", date: self.appState.currentDriveStart)
                    Spacer()
                }
                Spacer()
                if (self.appState.startCityName != "") {
                    HStack {
                        Image(systemName: "location.fill")
                        Text(self.appState.startCityName)
                        if(self.appState.startCityName != self.appState.currentCity) {
                            Text("--")
                            Text(self.appState.currentCity)
                        }
                    }.font(.subheadline).foregroundColor(.gray)
                } else {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("none")
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
                BlackButton("End Drive", action: {self.appState.endDrive()})
            }.padding()
        }
    }
}

struct DriveView_Previews: PreviewProvider {
    static var previews: some View {
        DriveView()
    }
}
