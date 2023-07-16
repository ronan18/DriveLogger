//
//  DriveLoggerStatistics.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 7/7/23.
//

import Foundation
import Observation
import SwiftUI
@Observable
public class DriveLoggerStatistics {
    var drives: [Drive] = []
    public var totalDriveTime: TimeInterval = 0
    public var averageDriveDuration: TimeInterval = 0
    public var timeDrivenToday: TimeInterval = 0
    public var longestDriveLength: TimeInterval = 0
    public var nightDriveTime: TimeInterval = 0
    public var dayDriveTime: TimeInterval = 0
    public var percentageStatChartData: PercentageStatChartData = .init(data: [], chartYAxisHeight: 0)
    public init (drives: [Drive]) {
        
        self.updateStatistics(drives: drives)
    }
    public func updateStatistics(drives: [Drive]) {
        let start = Date()
        
        self.drives = drives.sorted(by: { a, b in
            a.startTime < b.startTime
        })
        var totalDriveTimeResult: TimeInterval = 0
        var timeDrivenTodayResult: TimeInterval = 0
        var longestDriveResult: TimeInterval = 0
        var nightDriveResult: TimeInterval = 0
        var dayDriveResult: TimeInterval = 0
        
        var drivingPerDay: [Int: TimeInterval] = [:]
        var suggestedChartYAxisHeight: TimeInterval = 0
        let todaysDay: Int = Calendar.current.dateComponents([.day], from: Date()).day ?? 1
        var buildingDays: [DayPercentageStat] = []
        
        drives.forEach {drive in
         
            totalDriveTimeResult += drive.driveLength
            nightDriveResult += drive.nightDriveTime
            dayDriveResult += drive.dayDriveTime
            if (Calendar.current.isDateInToday(drive.startTime)) {
                timeDrivenTodayResult += drive.driveLength
            }
            if (drive.driveLength > longestDriveResult) {
                longestDriveResult = drive.driveLength
            }
            let driveDay = Calendar.current.dateComponents([.day], from: drive.startTime)
            if let day = driveDay.day {
                if let currentLength = drivingPerDay[day] {
                    drivingPerDay[day] = currentLength + drive.driveLength
                } else {
                    drivingPerDay[day] = drive.driveLength
                }
                
            }
            
        }
        
        
        let daysIncluded = drivingPerDay.keys.sorted { a, b in
            return a < b
        }
        for i in 0..<daysIncluded.count {
            
            if (i == 0) {
                buildingDays.append(.init(id: daysIncluded[i], driven: drivingPerDay[daysIncluded[i]] ?? 0, today: daysIncluded[i] == todaysDay))
                
            } else {
            
                let yesterdays: TimeInterval = buildingDays[i-1].driven
                let totalDriven: TimeInterval = yesterdays + (drivingPerDay[daysIncluded[i]] ?? 0)
             
                buildingDays.append(.init(id: daysIncluded[i], driven: totalDriven, today: daysIncluded[i] == todaysDay))
                if ((totalDriven + 60*60) > suggestedChartYAxisHeight) {
                    suggestedChartYAxisHeight = totalDriven + 60*60
                }
              
               // print(totalDriven.formatedForDrive(), "percent stat driven", yesterdays.formatedForDrive(), (data[daysIncluded[i]] ?? 0).formatedForDrive())
            }
            
        }
      
        withAnimation {
            self.percentageStatChartData = .init(data: buildingDays, chartYAxisHeight: suggestedChartYAxisHeight)
            self.totalDriveTime = totalDriveTimeResult
            self.averageDriveDuration = totalDriveTimeResult / Double(drives.count)
            self.timeDrivenToday = timeDrivenTodayResult
            self.longestDriveLength = longestDriveResult
            self.dayDriveTime = dayDriveResult
            self.nightDriveTime = nightDriveResult
        }
        let end = Date()
        print("DLSTAT stat update time",  end.timeIntervalSince(start))
    }
}
public struct DayPercentageStat: Identifiable {
    public var id: Int
    public var driven: TimeInterval
    public var today: Bool
    public init(id: Int, driven: TimeInterval, today: Bool) {
        self.id = id
        self.driven = driven
        self.today = today
    }
}
public struct PercentageStatChartData {
    public let data: [DayPercentageStat]
    public let suggestedChartYAxisHeight: TimeInterval
    public init(data: [DayPercentageStat], chartYAxisHeight: TimeInterval) {
        self.data = data
        self.suggestedChartYAxisHeight = chartYAxisHeight
    }
}
