//
//  DriveLoggerData.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/6/23.
//

import Foundation

public class DriveLoggerData {
    public init () {
        
    }
    public func totalDriveTime(drives: [Drive]) -> TimeInterval {
        var time: TimeInterval = 0
        drives.forEach { drive in
            time += drive.driveLength
        }
        return time
        
    }
    public func totalNightTime(drives: [Drive]) -> TimeInterval {
        var time: TimeInterval = 0
        drives.forEach { drive in
            time += drive.nightDriveTime
        }
        return time
        
    }
    public func totalDayTime(drives: [Drive]) -> TimeInterval {
        var time: TimeInterval = 0
        drives.forEach { drive in
            time += drive.dayDriveTime
        }
        return time
        
    }
    
}


extension TimeInterval {
    public func format(using units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: self)
    }
    public func format(using units: NSCalendar.Unit, unitStyle: DateComponentsFormatter.UnitsStyle) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = unitStyle
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: self)
    }
    public func formatedForDrive() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll

        return formatter.string(from: self) ?? ""
    }
   
}
