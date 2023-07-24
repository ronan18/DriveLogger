//
//  DriveLoggerData.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/6/23.
//

import Foundation
import CoreLocation
public final class DLLocationService {
    var lastLocation: CLLocation? = nil
    var lastName: String? = nil
    var threshHold: CLLocationDistance = 200

    var lastPoll: Date? = nil

     init () {
        
    }
    static public let shared = DLLocationService()
    
    public func cityName(from location: CLLocation) async -> String? {
        print("DLLoc City name request")

        guard lastPoll?.timeIntervalSinceNow ?? -50 < -30 else {
            print("DLLoc last poll time", lastPoll?.timeIntervalSinceNow as Any)
            return lastName
        }
        lastPoll = Date()
        if let lastLocation = lastLocation {
            if let lastName = lastName {
                if lastLocation.distance(from: location) > threshHold {
                    print("DLLoc last location with \(threshHold) meeters")
                    return lastName
                }
            }
        }

        self.lastLocation = location

        return await withCheckedContinuation{cont in
         
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location, completionHandler: {
                placemarks, error in
                if let placemarks = placemarks {
                    if error == nil && placemarks.count > 0 {
                        let placeMark = placemarks.last
                        debugPrint(placeMark ?? "")
                        debugPrint(placeMark?.administrativeArea ?? "")
                        debugPrint("DLLoc subAdminArea",placeMark?.subAdministrativeArea ?? "")
                        debugPrint("DLLoc locality",placeMark?.locality ?? "")
                        debugPrint("DLLoc subLocality",placeMark?.subLocality ?? "")
                        debugPrint("DLLoc thuroughFare",placeMark?.thoroughfare ?? "")
                        debugPrint("DLLoc subThoroughfare", placeMark?.subThoroughfare ?? "")
                        debugPrint("DLLoc name", placeMark?.name ?? "")
                        
                        var resultString = placeMark?.locality ?? ""
                        if let subLocality =  placeMark?.subLocality {
                            print("sublocality")
                            resultString = subLocality
                          
                        }
                        self.lastName = resultString
                        self.lastLocation = location
                        cont.resume(returning: resultString)
                        
                    } else {
                        self.lastName = nil
                        self.lastLocation = nil
                        cont.resume(returning: nil)
                    }
                    
                } else {
                    self.lastName = nil
                    self.lastLocation = nil
                    cont.resume(returning: nil)
                }
            })
        }
      
    }
    
}



extension TimeInterval {
    public func format(using units: NSCalendar.Unit) -> String? {
        guard !self.isNaN else {
            print("nan for format")
            return ""
        }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: self)
    }
    public func format(using units: NSCalendar.Unit, unitStyle: DateComponentsFormatter.UnitsStyle) -> String? {
        guard !self.isNaN else {
            print("nan for format")
            return ""
        }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = unitStyle
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: self)
    }
    public func formatedForDrive() -> String {
       // print("formatting for drive", self.debugDescription)
        guard !self.isNaN else {
            print("nan for format")
            return ""
        }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        
        return formatter.string(from: self) ?? ""
    }
   
}
