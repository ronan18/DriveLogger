//
//  CurrentDrive.model.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/8/23.
//

import Foundation
import CoreLocation


public struct CurrentDrive: Codable, Equatable, Hashable {
  
    
    public var start: Date
    
    public var route: DLRouteStore?
    public init(start: Date,startLocation: DLLocationPointStore?, route: DLRouteStore?) {
        self.start = start
       
        self.route = route
        if let startLocation = startLocation {
            self.placeName = startLocation.placeName
            self.lat = startLocation.lat
            self.lon = startLocation.lon
           
            
        }
    }
    
    public var placeName: String? = nil
    public var lat: Double? = nil
    public var lon: Double? = nil
    
    public var startLocation: DLLocationPointStore? {
        set {
            if let startLocation = newValue {
                self.placeName = startLocation.placeName
                self.lat = startLocation.lat
                self.lon = startLocation.lon
            }
        }
        get {
            guard let placeName = placeName else {
                return nil
            }
            guard let lat = lat else {
                return nil
            }
            guard let lon = lon else {
                return nil
            }
         
            return DLLocationPointStore(placeName: placeName, lat: lat, lon: lon)
        }
        
    }
}
