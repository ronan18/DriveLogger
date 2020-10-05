//
//  TimeHelpers.swift
//  DriveLoggerServicePackage
//
//  Created by Ronan Furuta on 9/24/20.
//

import Foundation
import CoreLocation
public struct TimeDisplay {
    public var value: String
    public var unit: String
}



public struct CurrentDrive: Encodable, Decodable {
    public var startLocation: String
    public var startTime: Date
    public init (startLocation: String, startTime: Date) {
        self.startLocation = startLocation
        self.startTime = startTime
    }
}
