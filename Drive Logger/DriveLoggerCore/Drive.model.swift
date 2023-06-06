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
final public class Drive {
    public let startTime: Date
    public let endTime: Date
    public let startLocation: String?
    public let endLocation: String?
    public let startLocationName: String?
    public let endLocationName: String?
    
    public init(startTime: Date, endTime: Date, startLocation: String?, endLocation: String?, startLocationName: String?, endLocationName: String?) {
        self.startTime = startTime
        self.endTime = endTime
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.startLocationName = startLocationName
        self.endLocationName = endLocationName
    }
    
    public init(sampleData: Bool ) {
        self.startTime = Date(timeIntervalSinceNow: -5000)
        self.endTime = Date(timeIntervalSinceNow: -9000)
        self.startLocation = nil
        self.endLocation = nil
        self.startLocationName = nil
        self.endLocationName = nil
    }
    
    public func backupDriveString() -> String {
        return startTime.formatted(date: .abbreviated, time: .shortened)
    }
}
