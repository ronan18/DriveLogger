//
//  DriveLoggerStatistics.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 7/7/23.
//

import Foundation
public class DriveLoggerStatistics {
    var drives: [Drive] = []
    public var totalDriveTime: TimeInterval = 0
    public var averageDriveDuration: TimeInterval = 0
    public var timeDrivenToday: TimeInterval = 0
    public var longestDriveLength: TimeInterval = 0
    public var nightDriveTime: TimeInterval = 0
    public var dayDriveTime: TimeInterval = 0
    public init (drives: [Drive]) {
        
        self.updateStatistics(drives: drives)
    }
    public func updateStatistics(drives: [Drive]) {
        
        let start = Date()
        self.drives = drives
        var totalDriveTimeResult: TimeInterval = 0
        var timeDrivenTodayResult: TimeInterval = 0
        var longestDriveResult: TimeInterval = 0
        var nightDriveResult: TimeInterval = 0
        var dayDriveResult: TimeInterval = 0
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
        }
        self.totalDriveTime = totalDriveTimeResult
        self.averageDriveDuration = totalDriveTimeResult / Double(drives.count)
        self.timeDrivenToday = timeDrivenTodayResult
        self.longestDriveLength = longestDriveResult
        self.dayDriveTime = dayDriveResult
        self.nightDriveTime = nightDriveResult
        let end = Date()
        print("DLSTAT stat update time",  end.timeIntervalSince(start))
    }
}
