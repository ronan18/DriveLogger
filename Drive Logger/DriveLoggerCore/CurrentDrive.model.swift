//
//  CurrentDrive.model.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/8/23.
//

import Foundation
import CoreLocation

public struct DLLocationStoreCodable: Codable {
    public let placeName: String
    public let lat: Double
    public let lon: Double
     public init(placeName: String, lat: Double, lon: Double) {
         self.placeName = placeName
         self.lat = lat
         self.lon = lon
     }
    
    public func normal() -> DLLocationStore {
        return DLLocationStore(placeName: placeName, lat: lat, lon: lon)
    }
    
    
}

public struct CurrentDrive: Codable {
    public var start: Date
    public var startLocation: DLLocationStoreCodable?
    public init(start: Date,startLocation: DLLocationStore?) {
        self.start = start
        if let startLocation = startLocation {
            self.startLocation = DLLocationStoreCodable(placeName: startLocation.placeName, lat: startLocation.lat, lon: startLocation.lon)
        }
    }
}
