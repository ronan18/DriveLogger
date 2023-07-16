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
    @State private var renderedImage = Image(systemName: "photo")
     @Environment(\.displayScale) var displayScale
    @State var testing: [Drive] = []
    var appState: AppState
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Statistics").font(.headline)
                Spacer()
                if (self.appState.statistics.totalDriveTime >= 5 * 60) {
                    ShareLink("", item: renderedImage,  preview: SharePreview(Text("Shared image"), image: renderedImage , icon:  Image(systemName: "square.and.arrow.up.circle.fill")))
                }
            }
            if (self.appState.statistics.totalDriveTime >= 5 * 60) {
                StatisticsView(drives: self.drives, appState: self.appState)
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
            
           
        }.padding(.vertical).task {
            await self.render()
        }.onChange(of: self.drives, {old, new in
            Task(priority: .low) {
                await self.render()
            }
        })
    }
    @MainActor func render() async {
        Task(priority: .low) {
            let renderer = ImageRenderer(content: StatisticsView(drives: self.drives, appState: self.appState))
            
            // make sure and use the correct display scale for this device
            renderer.scale = displayScale
            
            if let uiImage = renderer.uiImage {
                renderedImage = Image(uiImage: uiImage)
            }
        }
    }
}

struct StatisticsSection_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsSection(appState: AppState()).padding().modelContainer(previewContainer)
    }
}

struct StatisticsView: View {
  
var drives: [Drive]
    
    var appState: AppState
    
    var body: some View {
        VStack {
            TimeDrivenTodayStatCard(drivenToday: self.appState.statistics.timeDrivenToday).modelContainer(for: [Drive.self])
            PercentCompleteStatCard(goal: self.appState.goal, statistics: self.appState.statistics).padding(.vertical, 7).modelContainer(for: [Drive.self])
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
    }
}
