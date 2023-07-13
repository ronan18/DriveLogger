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
                    TimeDrivenTodayStatCard(appState: appState, drives: drives)
                    PercentCompleteStatCard(appState: appState, drives: drives).padding(.vertical, 7)
                    Grid(horizontalSpacing: 15,
                         verticalSpacing: 15) {
                        GridRow {
                            PercentageStat(percentComplete: (self.appState.statistics.totalDriveTime / (self.appState.goal)), lable: "percent complete").frame(maxWidth: .infinity).background(Color.cardBG).card()
                            if ((self.appState.goal - self.appState.statistics.totalDriveTime) >= 0) {
                                NumberStat(time: (self.appState.goal - self.appState.statistics.totalDriveTime), label: "until goal")
                            } else {
                                NumberStat(time: -(self.appState.goal - self.appState.statistics.totalDriveTime), label: "past goal")
                            }
                            NumberStat(time: self.appState.statistics.averageDriveDuration, label: "average drive duration")
                            
                        }
                        GridRow {
                            
                            NumberStat(value: LocalizedStringResource(stringLiteral: String(self.drives.count)), label: "logged drives")
                            NumberStat(time: self.appState.statistics.longestDriveLength, label: "longest drive")
                            NumberStat(time: self.appState.statistics.timeDrivenToday, label: "driven today")
                            
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


struct TimeDrivenTodayStatCard: View {
    var appState: AppState
    var drives: [Drive] = []
    init(appState: AppState, drives: [Drive], daysInGraph: Int = 7) {
        self.appState = appState
        drives.forEach {drive in
            
            guard Calendar.current.dateComponents([.day], from: drive.startTime, to: Date()).day ?? 0 < daysInGraph else {
                return
            }
            self.drives.append(drive)
    
        }
       
    }
    var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Spacer()
                Text(self.appState.statistics.timeDrivenToday.formatedForDrive()).font(.title).bold()
                Text("driven today").font(.subheadline)
            }
            Spacer()
            VStack (alignment: .trailing) {
                Spacer()
                Chart(drives, id: \.id) {
                  
                        BarMark(x: .value("day", $0.startTime, unit: .day), y: .value("length", $0.driveLength)).foregroundStyle(Calendar.current.isDateInToday($0.startTime) ? Color.black : Color.gray)
                    
                }.chartXAxis(.hidden).chartYAxis(.hidden).frame(width: 100, height: 60)
               // Spacer()
            }
           
        }.frame(height: 80).padding().background(Color.cardBG).card()
    }
}

struct DayPercentageStat: Identifiable {
    var id: Int
    var driven: TimeInterval
    var today: Bool
}

struct PercentCompleteStatCard: View {
    var appState: AppState
    var drives: [Drive] = []
    var percentComplete: String
    var days: [DayPercentageStat] = []
    let todaysDay: Int = Calendar.current.dateComponents([.day], from: Date()).day ?? 1
    var chartYAxisHeight: TimeInterval
    init(appState: AppState, drives: [Drive], daysInGraph: Int = 7) {
        self.appState = appState
        let number = round((appState.statistics.totalDriveTime / appState.goal) * 100)
        if number.isNaN || number.isInfinite {
            self.percentComplete = "100"
        } else {
            self.percentComplete = String(Int(number))
        }
        var data: [Int: TimeInterval] = [:]
        self.chartYAxisHeight = appState.goal
        drives.forEach { drive in
            
            guard Calendar.current.dateComponents([.day], from: drive.startTime, to: Date()).day ?? 0 < daysInGraph else {
                return
            }
            let day = Calendar.current.dateComponents([.day], from: drive.startTime)
           
            self.drives.append(drive)
            if let day = day.day {
                if let currentLength = data[day] {
                    data[day] = currentLength + drive.driveLength
                } else {
                    data[day] = drive.driveLength
                }
                
            }
           
           
        }
        let daysIncluded = data.keys.sorted { a, b in
         return a < b
        }
       // print("stat, days included", daysIncluded)
        
        for i in 0..<daysIncluded.count {
            
            if (i == 0) {
             //   print("stat", i, daysIncluded[i], data[daysIncluded[i]])
                days.append(.init(id: daysIncluded[i], driven: data[daysIncluded[i]] ?? 0, today: daysIncluded[i] == todaysDay))
            } else {
                let yesterdays: TimeInterval = days[i-1].driven
                let totalDriven: TimeInterval = yesterdays + (data[daysIncluded[i]] ?? 0) ?? 0
              //  print("stat", i, daysIncluded[i], data[daysIncluded[i]], yesterdays )
              //  print("stat total driven,", totalDriven)
                days.append(.init(id: daysIncluded[i], driven: totalDriven, today: daysIncluded[i] == todaysDay))
                if ((totalDriven + 60*60) > self.chartYAxisHeight) {
                    self.chartYAxisHeight = totalDriven + 60*60
                }
               // print("stat", daysIncluded[i], todaysDay, daysIncluded[i] == todaysDay)
            }
        }
       
       

    }
    let chartHeight: CGFloat = 60
    var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Spacer()
                Text(percentComplete).font(.title).bold() + Text("%").font(.title3)
                Text("complete").font(.subheadline)
            }
            Spacer()
            VStack (alignment: .trailing) {
                Spacer()
                ZStack {
                    Chart() {
                      
                        ForEach (days) {day in
                            
                            LineMark(x: .value("day", day.id), y: .value("length", day.driven)).interpolationMethod(.catmullRom).symbol(by: .value("Day", "int")).foregroundStyle(day.today ? Color.black : Color.gray)
                            
                            
                            
                        }
                       
                        RuleMark(
                                            y: .value("Goal", self.appState.goal)
                        ).foregroundStyle(Color.gray).lineStyle(.init(dash: [10, 5]))/*.annotation(position: .bottom, alignment: .leading) {
                            Text("\(self.appState.goal.formatedForDrive())").font(.caption).foregroundColor(Color.gray)
                        }*/
                        
                        
                        
                        
                        
                    }.chartXAxis(.hidden).chartYAxis(.hidden).frame(width: 100, height: chartHeight).chartYScale(domain: [0, chartYAxisHeight]).chartLegend(.hidden).chartXScale(domain: [days.first?.id ?? 0, days.last?.id ?? 7])
                  Chart() {
                        ForEach (days) {day in
                            if (day.today) {
                                LineMark(x: .value("day", day.id), y: .value("length", day.driven)).interpolationMethod(.catmullRom).symbol(by: .value("Day", "int")).foregroundStyle( Color.black)
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                    }.chartXAxis(.hidden).chartYAxis(.hidden).frame(width: 100, height: chartHeight).chartYScale(domain: [0, chartYAxisHeight]).chartLegend(.hidden).chartXScale(domain: [days.first?.id ?? 0, days.last?.id ?? 7])
                }
                Spacer()
            }
           
        }.frame(height: 80).padding().background(Color.cardBG).card()
    }
}
