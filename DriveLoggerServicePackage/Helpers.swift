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

public struct SunriseSunset: Codable {
    public var sunriseTime: Date
    public var sunsetTime: Date
    public init(sunriseTime: Date, sunsetTime: Date) {
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
    }
}


public struct CurrentDrive: Encodable, Decodable {
    public var startLocation: String
    public var startTime: Date
    public var sun: SunriseSunset
    public init (startLocation: String, startTime: Date, sun: SunriseSunset) {
        self.startLocation = startLocation
        self.startTime = startTime
        self.sun = sun
    }
}
