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
import SwiftData

public struct PercentCompleteStatCard: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \.startTime, order: .reverse) private var drives: [Drive]
    
    var goal: TimeInterval
    var percentComplete: String
    var days: [DayPercentageStat]
    let todaysDay: Int = Calendar.current.dateComponents([.day], from: Date()).day ?? 1
    var chartYAxisHeight: TimeInterval
    var widgetMode: Bool
    var chartHeight: CGFloat = 60
    var daysInGraph: Int
    @MainActor
    public init(goal: TimeInterval, statistics: DriveLoggerStatistics, daysInGraph: Int = 7, widgetMode: Bool = false) {
        self.goal = goal
        self.widgetMode = widgetMode
      
        let number = round((statistics.totalDriveTime / goal) * 100)
        if number.isNaN || number.isInfinite {
            self.percentComplete = "100"
        } else {
            self.percentComplete = String(Int(number))
        }
       
        self.daysInGraph = daysInGraph
       
       
        if widgetMode {
           
            self.chartHeight = 80
            
        }
        let today = Calendar.current.dateComponents([.day], from: Date()).day ?? 0
        self.chartYAxisHeight = statistics.percentageStatChartData.suggestedChartYAxisHeight > goal ? statistics.percentageStatChartData.suggestedChartYAxisHeight : goal
        self.days = statistics.percentageStatChartData.data.filter({day in
            return (today - day.id) < daysInGraph
        })
        
       
    }
    
    public var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                if (self.widgetMode) {
                    Image("Icon").resizable().frame(width: iconWidth, height: iconWidth)
                }
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
                        ).foregroundStyle(Color.gray).lineStyle(.init(dash: widgetMode ? [11, 5] : [10, 5]))/*.annotation(position: .bottom, alignment: .leading) {
                            Text("\(self.appState.goal.formatedForDrive())").font(.caption).foregroundColor(Color.gray)
                        }*/
                    }.chartXAxis(.hidden).chartYAxis(.hidden).frame(width: widgetMode ? 120 :  100, height: chartHeight).chartYScale(domain: [0, chartYAxisHeight]).chartLegend(.hidden).chartXScale(domain: [days.first?.id ?? 0, days.last?.id ?? 7])
                  Chart() {
                        ForEach (days) {day in
                            if (day.today) {
                                LineMark(x: .value("day", day.id), y: .value("length", day.driven)).interpolationMethod(.catmullRom).symbol(by: .value("Day", "int")).foregroundStyle( Color.black)
                            }
                        }            
                  }.chartXAxis(.hidden).chartYAxis(.hidden).frame(width: widgetMode ? 120 : 100, height: chartHeight).chartYScale(domain: [0, chartYAxisHeight]).chartLegend(.hidden).chartXScale(domain: [days.first?.id ?? 0, days.last?.id ?? 7])
                }
                Spacer()
            }
           
        }.ifCondition(!self.widgetMode, then: {view in
            view.frame(height: 80).padding().background(Color.cardBG).card()
        }).ifCondition(widgetMode, then: {view in
            view.padding(10)
        })
    }
   
    
}
