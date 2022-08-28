//
//  ChartView.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/8/22.
//

import SwiftUI
import DriveLoggerServicePackage

#if canImport(Charts)
import Charts
#endif

public struct DriveByDayChart: View {
    var data: [DriveLengthDay]
    
    var average = true
    var axis = true
    var dailyAverage: TimeInterval
    var averageDriveLength: TimeInterval
    var label: String
    public init(data: DriveLoggerAppState, average: Bool = true, axis: Bool = true, label: String? = nil) {
        self.data = data.driveLengthByDay
        self.averageDriveLength = data.averageDriveDuration
        self.label = label ?? "amount of driving per day"
        self.average = average
        self.axis = axis
        var sumAverage = 0
        data.driveLengthByDay.forEach({drive in
            sumAverage += Int(drive.length)
        })
        if (data.driveLengthByDay.count > 0) {
            self.dailyAverage = TimeInterval(sumAverage / data.driveLengthByDay.count)
        } else {
            self.dailyAverage = TimeInterval(0)
        }
    }
    
    public var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                
                
                HStack {
                    VStack(alignment:.leading) {
                        Text(label).font(.headline)
                        if (axis) {
                            Text("time in minutes").font(.caption).foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                }
                Chart {
                    ForEach(data) { data in
                        BarMark(
                            x: .value("Date", data.date, unit: .day),
                            y: .value("Duration", data.length / 60)
                        ).foregroundStyle(Color("BlackColor")).interpolationMethod(.catmullRom)//.symbol(by: .value("Length", data.length))
                        if (self.average) {
                            RuleMark(y: .value("Average time driving per day", self.dailyAverage / 60)).foregroundStyle(.blue).annotation(position: .top, alignment: .trailing) {
                                RuleMarkAnnotation(label: self.axis ? "Daily average: **\(Int(self.dailyAverage / 60))**m" : "**\(Int(self.dailyAverage / 60))**m avg day ", color: .blue)
                              
                            }
                            RuleMark(y: .value("Average drive length", self.averageDriveLength / 60)).foregroundStyle(.orange).annotation(position: .top, alignment: .leading) {
                                RuleMarkAnnotation(label: self.axis ? "Average drive: **\(Int(self.averageDriveLength / 60))**m" : "**\(Int(self.averageDriveLength / 60))**m avg drive", color: .orange)
                       
                            }
                        }
                    }
                    
                    
                }.chartLegend(self.axis ? .visible : .hidden).chartYAxis(self.axis ? .visible : .hidden).chartXAxis(self.axis ? .visible : .hidden)
            } else {
                HStack {
                    
                    VStack(alignment:.leading) {
                        Text(label + " graph").font(.headline)
                        if (axis) {
                            Text("Graphical representation of the amount of driving per day").font(.caption).foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
                GraphsNeediOS16(smallScreen: axis ? false : true).padding(.top)
            }
            
            
            
            
            
            
            
        }
    }
}
