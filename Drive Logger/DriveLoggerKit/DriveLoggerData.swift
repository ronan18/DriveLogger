//
//  DriveLoggerData.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/6/23.
//

import Foundation
import CoreLocation
public class DriveLoggerData {
    public init () {
        
    }
    public func cityName(from: CLLocation) async -> String? {
        return await withCheckedContinuation{cont in
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(from, completionHandler: {
                placemarks, error in
                if let placemarks = placemarks {
                    if error == nil && placemarks.count > 0 {
                        let placeMark = placemarks.last
                        debugPrint(placeMark ?? "")
                        debugPrint(placeMark?.administrativeArea ?? "")
                        debugPrint("subAdminArea",placeMark?.subAdministrativeArea ?? "")
                        debugPrint("locality",placeMark?.locality ?? "")
                        debugPrint("subLocality",placeMark?.subLocality ?? "")
                        debugPrint("thuroughFare",placeMark?.thoroughfare ?? "")
                        debugPrint("subThoroughfare", placeMark?.subThoroughfare ?? "")
                        debugPrint("name", placeMark?.name ?? "")
                        
                        var resultString = placeMark?.locality ?? ""
                        if let subLocality =  placeMark?.subLocality {
                            print("sublocality")
                            resultString = subLocality
                        }
                        cont.resume(returning: resultString)
                        
                    } else {
                        cont.resume(returning: nil)
                    }
                    
                } else {
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
