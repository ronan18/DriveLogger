//
//  DrivingView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/4/23.
//

import SwiftUI
import DriveLoggerUI
import DriveLoggerKit
import SwiftData

struct DrivingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var drives: [Drive]
    var appState: AppState
    var body: some View {
        VStack {
            Spacer()
            Text(self.appState.currentDrive?.start ?? Date(timeIntervalSince1970: 0), style: .timer).font(.system(size: 85)).fontWeight(.heavy)
            if (self.appState.lastLocation != nil) {
                Text("\(Image(systemName: "location.fill")) \(self.appState.lastLocation?.placeName ?? "error")").font(.subheadline).foregroundColor(.gray)
            } else {
                Text("\(Image(systemName: "location.slash.fill")) location unavailable").font(.subheadline).foregroundColor(.gray)
            }
           
            Spacer()
            Grid(horizontalSpacing: 15,
                 verticalSpacing: 15) {
                GridRow {
                    NumberStat(time: (self.appState.statistics.totalDriveTime), label: "driven")
                    NumberStat(time: (self.appState.statistics.dayDriveTime), label: "daytime")
                    NumberStat(time: (self.appState.statistics.nightDriveTime), label: "nighttime")
                }.frame(height: 130)
            }
            Spacer()
            ProgressBar(percentComplete: ((self.appState.statistics.totalDriveTime +  (0 - (self.appState.currentDrive?.start ?? Date(timeIntervalSince1970: 0)).timeIntervalSinceNow)) / (self.appState.goal)))
            Button(action: {
                // Handle button tap
                Task {
                    await appState.stopDrive()
                }
            }) {
                Text("End Drive")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
        }.padding()
     
    }
}

struct DrivingView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingView(appState: AppState()).modelContainer(for: [Drive.self])
    }
}
