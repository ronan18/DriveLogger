//
//  StatisticsSection.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/4/23.
//

import SwiftUI
import DriveLoggerUI
import DriveLoggerCore
import SwiftData
struct StatisticsSection: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \.startTime, order: .reverse) private var drives: [Drive]
    var appState: AppState
    
    var body: some View {
        VStack {
            HStack {
                Text("Statistics").font(.headline)
                Spacer()
               
            }
            HStack {
               
                Grid(horizontalSpacing: 15,
                     verticalSpacing: 15) {
                    GridRow {
                        PercentageStat(percentComplete: (self.appState.statistics.totalDriveTime / (self.appState.goal)), lable: "percent complete").frame(maxWidth: .infinity).background(Color.cardBG).card()
                        NumberStat(time: (self.appState.goal - self.appState.statistics.totalDriveTime), label: "until goal")
                        NumberStat(time: self.appState.statistics.averageDriveDuration, label: "average drive duration")
                        
                    }
                    GridRow {
                       
                        NumberStat(value: String(self.drives.count), label: "logged drives")
                        NumberStat(time: self.appState.statistics.longestDriveLength, label: "longest drive")
                        NumberStat(time: self.appState.statistics.timeDrivenToday, label: "time driven today")
                        
                    }.frame(minHeight: 130)
                }
            }
           
        }.padding(.vertical)
    }
}

struct StatisticsSection_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsSection(appState: AppState()).padding().modelContainer(previewContainer)
    }
}

