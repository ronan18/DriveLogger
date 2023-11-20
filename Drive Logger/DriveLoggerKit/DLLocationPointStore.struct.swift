//
//  DLLocationPointStore.struct.swift
//  DriveLoggerKit
//
//  Created by Ronan Furuta on 7/24/23.
//

import Foundation
import SwiftData

import MapKit


@Model
public class DLLocationPointStore: Equatable, Hashable {
    public static func == (lhs: DLLocationPointStore, rhs: DLLocationPointStore) -> Bool {
        return lhs.placeName == rhs.placeName && lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
    public func hash(into hasher: inout Hasher) {
          hasher.combine(placeName)
          hasher.combine(lat)
        hasher.combine(lon)
      }
    
    public let placeName: String
    public let lat: Double
    public let lon: Double
    
    @Transient
    public var coordinate: CLLocationCoordinate2D {
        return .init(latitude: lat, longitude: lon)
    }
    
     public init(placeName: String, lat: Double, lon: Double) {
         self.placeName = placeName
         self.lat = lat
         self.lon = lon
     }
    /* init (from data: Data) throws {
         guard let value = try? JSONDecoder().decode(DLLocationPointStore.self, from: data) else {
             throw DLLocationError.error
         }
         self.placeName = value.placeName
         self.lat = value.lat
         self.lon = value.lon
    }*/
    
    
}
