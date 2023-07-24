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
import WeatherKit
import CoreLocation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

public func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
public enum DLLocationError: Error {
    case error
}


public struct SunTime: Codable {
    public let hour: Int
    public let minute: Int
    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
    public init(from date: Date) {
        let data = date.get(.hour, .minute)
        hour = data.hour ?? 19
        minute = data.minute ?? 45
    }
    
   public func date() -> Date {
        return Calendar.current.date(from:DateComponents(hour: self.hour, minute: self.minute)) ?? Date()
    }
}

@Model
final public class DLDrive: Identifiable, Hashable {
    @Attribute(.unique) public let id: String
    public var startTime: Date
    public var endTime: Date
    public var startLocationName: String
    public var endLocationName: String
    public var sunsetTime: Date
    public var sunriseTime: Date
    
    private var startLocationData: Data?
    private var endLocationData: Data?
    private var weatherStore: Data?

    public init(id: UUID, startTime: Date, endTime: Date, startLocation: DLLocationPointStore?, endLocation: DLLocationPointStore?, startLocationName: String?, endLocationName: String?, sunsetTime: Date, sunriseTime: Date, weather: CurrentWeather?) {
        self.startTime = startTime
        self.endTime = endTime
        self.startLocationData = try? startLocation?.storeValue()
        self.endLocationData = try? endLocation?.storeValue()
        self.startLocationName = startLocationName ?? ""
        self.endLocationName = endLocationName ?? ""
        self.id = UUID().uuidString
        
        self.sunsetTime = sunsetTime
        self.sunriseTime = sunriseTime
        if let weather = weather {
            self.weatherStore = try? WeatherData(from: weather).storeValue()
        } else {
            self.weatherStore = nil
        }
        
       
 
    }
    
    public init(sampleData: Bool ) {
        
        let startTime = Date(timeIntervalSinceNow: (0 - (Double.random(in: 1000...500000))))
        self.startTime = startTime
        self.endTime = Date(timeInterval: (Double.random(in: 100...9000)), since: startTime)
        self.startLocationData = nil
        self.endLocationData = nil
        self.startLocationName = SampleData.locations.randomElement() ?? ""
        self.endLocationName = SampleData.locations.randomElement() ?? ""
        self.id = UUID().uuidString
        print("creating new drive from sample data")
        self.sunsetTime = Calendar.current.date(from:DateComponents(hour:19, minute: 49)) ?? Date()
        self.sunriseTime = Calendar.current.date(from:DateComponents(hour:6, minute: 31)) ?? Date()
       // self.sunsetTime = SunTime(hour: 7, minute: 30)
       // self.sunriseTime =  SunTime(hour: 14, minute: 45)
        self.weatherStore = nil
        
       
    }
    public var startLocation: DLLocationPointStore? {
        guard let data = self.startLocationData else {
            return nil
        }
        return try? DLLocationPointStore.init(from: data)
    }
    public var endLocation: DLLocationPointStore? {
        guard let data = self.endLocationData else {
            return nil
        }
        return try? DLLocationPointStore.init(from: data)
    }

    public var backupDriveString: LocalizedStringResource {
        var result: LocalizedStringResource = LocalizedStringResource(stringLiteral: startTime.formatted(date: .abbreviated, time: .shortened))
        if !self.startLocationName.isEmpty {
            result = LocalizedStringResource(stringLiteral: self.startLocationName)
            
        }
        if !self.endLocationName.isEmpty {
            result = LocalizedStringResource(stringLiteral: self.endLocationName)
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
        
        return result
    }
    public var dayDriveTime: TimeInterval {
        
        return self.driveLength - self.nightDriveTime
    }
    public var valueHash: String {
        return MD5(string: "\(self.startTime.ISO8601Format())\(self.endTime.ISO8601Format())\(self.nightDriveTime.description)\(self.backupDriveString)").base64EncodedString()
    }
    public var weather: WeatherData? {
        guard let data = self.weatherStore else {
            return nil
        }
        return try? JSONDecoder().decode(WeatherData.self, from: data)
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
