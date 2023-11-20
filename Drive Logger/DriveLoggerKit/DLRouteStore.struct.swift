//
//  DLRouteStore.struct.swift
//  DriveLoggerKit
//
//  Created by Ronan Furuta on 7/24/23.
//

import Foundation
import MapKit

public struct DLRouteStore: Codable, Equatable, Hashable {
    public static func == (lhs: DLRouteStore, rhs: DLRouteStore) -> Bool {
        lhs.routePoints.count == rhs.routePoints.count
    }
    
    
    var routePoints: [DLRoutePoint]
    
    public init(routePoints: [DLRoutePoint]) {
        self.routePoints = routePoints
    }
    public init(from data: Data) throws {
        let result = try JSONDecoder().decode(DLRouteStore.self, from: data)
        self = result
    }
    
    public var tripPolyLine: MKPolyline {
        return MKPolyline(coordinates: self.routePoints.map {item in
            return .init(latitude: item.lat, longitude: item.lon)
        }, count: self.routePoints.count)
    }
    
    public var averageSpeed: Double {
        var result: CLLocationSpeed = 0
        self.routePoints.forEach({point in
            result += point.speed
        })
        return (result/Double(self.routePoints.count)).mph
    }
    func storeData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
}

public struct DLRoutePoint: Codable, Equatable, Hashable {
    let date: Date
    let lat: Double
    let lon: Double
    let speed: CLLocationSpeed
    let heading: CLLocationDirection
    
    public init(from location: CLLocation) {
        self.date = location.timestamp
        self.lat = location.coordinate.latitude
        self.lon = location.coordinate.longitude
        self.speed = location.speed
        self.heading = location.course
    }
}

public extension CLLocationSpeed {
    var mph: Double {
        return self * 2.23694
    }
}
