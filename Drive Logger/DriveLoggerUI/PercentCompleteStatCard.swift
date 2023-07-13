//
//  PercentCompleteStatCard.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 7/13/23.
//

import Foundation
import SwiftUI
import Charts
import DriveLoggerKit

private struct DayPercentageStat: Identifiable {
    var id: Int
    var driven: TimeInterval
    var today: Bool
}
public struct PercentCompleteStatCard: View {
    var goal: TimeInterval
    var drives: [Drive] = []
    var percentComplete: String
    fileprivate var days: [DayPercentageStat] = []
    let todaysDay: Int = Calendar.current.dateComponents([.day], from: Date()).day ?? 1
    var chartYAxisHeight: TimeInterval
    public init(goal: TimeInterval, statistics: DriveLoggerStatistics, drives: [Drive], daysInGraph: Int = 7) {
        self.goal = goal
        let number = round((statistics.totalDriveTime / goal) * 100)
        if number.isNaN || number.isInfinite {
            self.percentComplete = "100"
        } else {
            self.percentComplete = String(Int(number))
        }
        var data: [Int: TimeInterval] = [:]
        self.chartYAxisHeight = goal
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
                let totalDriven: TimeInterval = yesterdays + (data[daysIncluded[i]] ?? 0) 
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
    public var body: some View {
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
                                            y: .value("Goal", self.goal)
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
