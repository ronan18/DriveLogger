//
//  DriveLoggerData.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/6/23.
//

import Foundation
import CoreLocation
public class DriveLoggerData {
    public init () {
        
    }
    /*
    public func totalDriveTime(drives: [Drive]) -> TimeInterval {
        var time: TimeInterval = 0
        drives.forEach { drive in
            time += drive.driveLength
        }
        return time
        
    }
    public func averageDriveDuration(drives: [Drive]) -> TimeInterval {
        return self.totalDriveTime(drives: drives) / Double(drives.count)
    }
    public func timeDrivenToday(drives: [Drive]) -> TimeInterval {
        var result: TimeInterval = 0
        drives.forEach({drive in
            guard Calendar.current.isDateInToday(drive.startTime) else {
                return
            }
            result += drive.driveLength
        })
        return result
    }
    public func longestDrive(drives: [Drive]) -> TimeInterval {
        var result: TimeInterval = 0
        drives.forEach({drive in
            if (drive.driveLength > result) {
                result = drive.driveLength
            }
        })
        return result
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
        
    }*/
    
    public func cityName(from: CLLocation) async -> String? {
        return await withCheckedContinuation{cont in
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(from, completionHandler: {
                placemarks, error in
                if let placemarks = placemarks {
                    if error == nil && placemarks.count > 0 {
                        let placeMark = placemarks.last
                        debugPrint(placeMark ?? "")
                        debugPrint(placeMark?.administrativeArea ?? "")
                        debugPrint("subAdminArea",placeMark?.subAdministrativeArea ?? "")
                        debugPrint("locality",placeMark?.locality ?? "")
                        debugPrint("subLocality",placeMark?.subLocality ?? "")
                        debugPrint("thuroughFare",placeMark?.thoroughfare ?? "")
                        debugPrint("subThoroughfare", placeMark?.subThoroughfare ?? "")
                        debugPrint("name", placeMark?.name ?? "")
                        
                        var resultString = placeMark?.locality ?? ""
                        if let subLocality =  placeMark?.subLocality {
                            print("sublocality")
                            resultString = subLocality
                        }
                        cont.resume(returning: resultString)
                        
                    } else {
                        cont.resume(returning: nil)
                    }
                    
                } else {
                    cont.resume(returning: nil)
                }
            })
        }
      
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
