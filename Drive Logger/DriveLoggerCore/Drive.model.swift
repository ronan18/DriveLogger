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
}

@Model
final public class Drive: Identifiable {
   
    public let startTime: Date = Date()
    public let endTime: Date = Date()
    public let startLocation: DLLocationStore?
    public let endLocation: DLLocationStore?
    public let startLocationName: String?
    public let endLocationName: String?
    public let sunsetTime: SunTime = SunTime(hour: 19, minute: 46)
    public let sunriseTime: SunTime = SunTime(hour: 7, minute: 20)
    
    public init(id: UUID, startTime: Date, endTime: Date, startLocation: DLLocationStore?, endLocation: DLLocationStore?, startLocationName: String?, endLocationName: String?, sunsetTime: SunTime, sunriseTime: SunTime) {
        self.startTime = startTime
        self.endTime = endTime
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.startLocationName = startLocationName
        self.endLocationName = endLocationName
        self.sunsetTime = sunsetTime
        self.sunriseTime = sunriseTime
       
 
    }
    
    public init(sampleData: Bool ) {
        
        let startTime = Date(timeIntervalSinceNow: (0 - (Double.random(in: 1000...500000))))
        self.startTime = startTime
        self.endTime = Date(timeInterval: (Double.random(in: 100...9000)), since: startTime)
        print(startTime.formatted(), endTime.formatted(), "newdate")
        self.startLocation = nil
        self.endLocation = nil
        self.startLocationName = SampleData.locations.randomElement()
        self.endLocationName = SampleData.locations.randomElement()
        self.sunsetTime = SunTime(hour: 7, minute: 30)
        self.sunriseTime =  SunTime(hour: 14, minute: 45)
       
    }
    
    public var backupDriveString: String {
        return startTime.formatted(date: .abbreviated, time: .shortened)
    }
    public var driveLength: TimeInterval {
        return endTime.timeIntervalSince(startTime)
    }
}
