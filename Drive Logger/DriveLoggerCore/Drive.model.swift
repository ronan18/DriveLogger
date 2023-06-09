//
//  Drive.model.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/5/23.
//

import Foundation
import SwiftData
import CoreData
import MapKit
import CoreLocation

@Model
public class DLLocationStore {
    public let placeName: String
    public let lat: Double
    public let lon: Double
     public init(placeName: String, lat: Double, lon: Double) {
         self.placeName = placeName
         self.lat = lat
         self.lon = lon
     }
    
}
public struct SunTime: Codable {
    public let hour: Int
    public let minute: Int
    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
    
   public func date() -> Date {
        return Calendar.current.date(from:DateComponents(hour: self.hour, minute: self.minute)) ?? Date()
    }
}

@Model
final public class Drive: Identifiable {
    @Attribute(.unique) public let id: String
    public var startTime: Date = Date()
    public var endTime: Date = Date()
    public var startLocation: DLLocationStore?
    public var endLocation: DLLocationStore?
    public var startLocationName: String
    public var endLocationName: String
    public var sunsetTime: Date
    public var sunriseTime: Date

    public init(id: UUID, startTime: Date, endTime: Date, startLocation: DLLocationStore?, endLocation: DLLocationStore?, startLocationName: String?, endLocationName: String?, sunsetTime: Date, sunriseTime: Date) {
        self.startTime = startTime
        self.endTime = endTime
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.startLocationName = startLocationName ?? ""
        self.endLocationName = endLocationName ?? ""
        self.id = UUID().uuidString
        
        self.sunsetTime = sunsetTime
        self.sunriseTime = sunriseTime
       
 
    }
    
    public init(sampleData: Bool ) {
        
        let startTime = Date(timeIntervalSinceNow: (0 - (Double.random(in: 1000...500000))))
        self.startTime = startTime
        self.endTime = Date(timeInterval: (Double.random(in: 100...9000)), since: startTime)
        self.startLocation = nil
        self.endLocation = nil
        self.startLocationName = SampleData.locations.randomElement() ?? ""
        self.endLocationName = SampleData.locations.randomElement() ?? ""
        self.id = UUID().uuidString
        print("creating new drive from sample data")
        self.sunsetTime = Calendar.current.date(from:DateComponents(hour:19, minute: 49)) ?? Date()
        self.sunriseTime = Calendar.current.date(from:DateComponents(hour:6, minute: 31)) ?? Date()
       // self.sunsetTime = SunTime(hour: 7, minute: 30)
       // self.sunriseTime =  SunTime(hour: 14, minute: 45)
        
       
    }
    
    public var backupDriveString: String {
        var result: String = startTime.formatted(date: .abbreviated, time: .shortened)
        if !self.startLocationName.isEmpty {
            result = self.startLocationName
            
        }
        if !self.endLocationName.isEmpty {
            result = self.endLocationName
        }
        if !self.endLocationName.isEmpty && !self.startLocationName.isEmpty {
            result = "\(startLocationName) to \(endLocationName)"
        }
        return result
         
    }
    public var driveLength: TimeInterval {
        return endTime.timeIntervalSince(startTime)
    }
    public var sunsetTimeComponents: DateComponents {
        
        return self.sunsetTime.get(.hour, .minute)
    }
    public var sunriseTimeComponents: DateComponents {
        
        return self.sunriseTime.get(.hour, .minute)
    }
    public var nightDriveTime: TimeInterval {
      //  print("calc night drive for \(self.backupDriveString)")
        var result: TimeInterval = 0
    
       guard let sunriseTimeDate = Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: Calendar.current.timeZone, year: self.startTime.get(.year), month: self.startTime.get(.month), day: self.startTime.get(.day), hour: self.sunriseTime.get(.hour), minute: self.sunriseTime.get(.minute)) ) else {
            return 0
        }
        guard let sunsetTimeDate = Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: Calendar.current.timeZone, year: self.endTime.get(.year), month: self.endTime.get(.month), day: self.endTime.get(.day), hour: self.sunsetTime.get(.hour), minute: self.sunsetTime.get(.minute)) ) else {
            return 0
        }
        
        let timeBefore = sunriseTimeDate.timeIntervalSince(startTime)
       // print("timeBefore", timeBefore, sunriseTimeDate.formatted(), startTime.formatted())
        if (timeBefore > 0) {
            if (sunriseTimeDate.timeIntervalSince(endTime) >= 0) {
                result = driveLength
            } else {
                result += timeBefore
            }
        }
       // print("Sunset Time, end time", sunsetTimeDate.formatted(), endTime.formatted())
        let timeAfter = endTime.timeIntervalSince(sunsetTimeDate)
       // print("timeAfter", timeAfter, timeAfter.formatedForDrive(), sunsetTimeDate.formatted(), endTime.formatted())
        if (timeAfter > 0) {
            if (startTime.timeIntervalSince(sunsetTimeDate) >= 0) {
                result = driveLength
            } else {
                result += timeAfter
            }
            
        }
        
      //  print(result, backupDriveString)
        return result
    }
    public var dayDriveTime: TimeInterval {
        
        return self.driveLength - self.nightDriveTime
    }
}
extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
