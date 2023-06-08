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


 public struct DLLocationStore: Codable {
    public let name: String
    public let lat: Double
    public let lon: Double
    
}
public struct SunTime: Codable {
    public let hour: Int
    public let minute: Int
    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
}

@Model
final public class Drive: Identifiable {
    @Attribute(.unique) public let id: String
    public var startTime: Date = Date()
    public var endTime: Date = Date()
    public var startLocation: String?
    public var endLocation: String?
    public var startLocationName: String
    public var endLocationName: String
    public var sunsetTime: Date
    public var sunriseTime: Date
  ///
    public init(id: UUID, startTime: Date, endTime: Date, startLocation: DLLocationStore?, endLocation: DLLocationStore?, startLocationName: String?, endLocationName: String?, sunsetTime: SunTime, sunriseTime: SunTime) {
        self.startTime = startTime
        self.endTime = endTime
        self.startLocation = nil
        self.endLocation = nil
        self.startLocationName = startLocationName ?? ""
        self.endLocationName = endLocationName ?? ""
        self.id = UUID().uuidString
        self.sunsetTime = Date()
        self.sunriseTime = Date()
       
 
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
        self.sunsetTime = Date()
        self.sunriseTime = Date()
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
}
