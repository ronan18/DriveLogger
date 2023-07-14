//
//  StatisticsSection.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/4/23.
//

import SwiftUI
import DriveLoggerUI
import DriveLoggerKit
import SwiftData
import Charts

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
            if (self.appState.statistics.totalDriveTime >= 5 * 60) {
                VStack {
                    TimeDrivenTodayStatCard(drivenToday: self.appState.statistics.timeDrivenToday.formatedForDrive(), drives: drives)
                    PercentCompleteStatCard(goal: self.appState.goal, statistics: self.appState.statistics, drives: drives).padding(.vertical, 7)
                    TimeUntilGoalStatCard(statistics: self.appState.statistics, goal: self.appState.goal).padding(.bottom, 7)
                    Grid(horizontalSpacing: 15,
                         verticalSpacing: 15) {
                     
                        GridRow {
                            
                            NumberStat(value: LocalizedStringResource(stringLiteral: String(self.drives.count)), label: "logged drives")
                            NumberStat(time: self.appState.statistics.longestDriveLength, label: "longest drive")
                            NumberStat(time: self.appState.statistics.averageDriveDuration, label: "average drive duration")
                            
                        }.frame(minHeight: 130)
                    }
                }
            } else {
                VStack {
                    Spacer()
                    ContentUnavailableView {
                        Label("Statistics Locked", systemImage: "lock.circle.fill").font(.headline)
                    } description: {
                        Text("Drive five minutes or more to unlock your driving statistics")
                    }
                    Spacer()
                }.background(Color.lightBG).cornerRadius(6).frame(height: 250).padding(.vertical, 2)
            }
            
           
        }.padding(.vertical)
    }
}

struct StatisticsSection_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsSection(appState: AppState()).padding().modelContainer(previewContainer)
    }
}
