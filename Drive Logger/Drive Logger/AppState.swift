//
//  AppState.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/6/23.
//

import Foundation
import Observation
import DriveLoggerCore
import SwiftData
import CoreLocation


@Observable
public final class AppState {
  //  public var drivingState: DrivingState = DrivingState(from)
  public var context: ModelContext? = nil
    public var currentDrive: CurrentDrive? = nil
    var lastLocation: DLLocationStore? = nil
   
    public var goal: TimeInterval? = 50*60*60
    public var driveEditorPresented = false
    public var driveToBeEdited: Drive = Drive(sampleData: true)
    
    private let manager: CLLocationManager
    private var locationsUpdating = false
    private var service = DLDiskService()
    private var weatherService = DLWeather()
    
    public init(context: ModelContext) {
        self.manager = CLLocationManager()
        
        self.context = context
        
    }
    
    public init(firstBoot: Bool = false) {
     //   self.start()
        self.manager = CLLocationManager()
        
        self.currentDrive = service.readCurrentDrive()
        if (self.currentDrive != nil) {
            Task {
                await self.monitorLocation()
            }
        }
    }
    
    

   
     public func startDrive() {
         let drive = CurrentDrive(start: Date(), startLocation: nil)
         self.currentDrive = drive
         service.saveCurrentDrive(drive)
         Task {
             await self.monitorLocation()
         }
       
      
    }
    @MainActor
     public func stopDrive() async {
         print("stoping drive")
         guard let context = context else {
             print("no context to stop drive")
            
             return
         }
       let currentDriveEnd = Date()
         let drive = currentDrive
        self.currentDrive = nil
         let endLocation = lastLocation
        
         service.deleteCurrentDrive()
         self.locationsUpdating = false
       
         guard let currentDriveStart = drive?.start else {
            print("no drive start")
            return
        }
         
         var sunSetTime = SunTime(hour: 19, minute: 30).date()
         var sunRiseTime = SunTime(hour: 7, minute: 45).date()
         if let startLocation = drive?.startLocation {
             
             let (sunrise, sunset) = await weatherService.suntimes(for: CLLocation(latitude: startLocation.lat, longitude: startLocation.lon))
             if let sunrise = sunrise {
                 sunRiseTime = sunrise
             }
             if let sunset = sunset {
                 sunSetTime = sunset
             }
             print("sun rise sunset time for drive", sunrise, sunset)
         }
         let newDrive = Drive(id: UUID(), startTime: currentDriveStart, endTime: currentDriveEnd, startLocation: drive?.startLocation?.normal(), endLocation: endLocation, startLocationName: drive?.startLocation?.normal().placeName ?? "", endLocationName: endLocation?.placeName, sunsetTime: sunSetTime, sunriseTime: sunRiseTime)
         print("new drive", newDrive)
        context.insert(newDrive)
         do {
             try context.save()
         } catch {
             print("error saving new drive context")
         }
         
    }
    
    public func monitorLocation() async {
        if self.manager.authorizationStatus == .notDetermined {
            self.manager.requestWhenInUseAuthorization()
        }
        print("starting to monitor location")
        self.locationsUpdating = true
        let updates = CLLocationUpdate.liveUpdates()
        
        do {
            for try await update in updates {
                print(update, "location update")
                if let location = update.location {
                    if let locationName = await DriveLoggerData().cityName(from: location) {
                        print(locationName, "location name")
                        let storeLoc = DLLocationStore(placeName: locationName, lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                        self.lastLocation = storeLoc
                        if (self.currentDrive?.startLocation == nil && self.currentDrive != nil) {
                            self.currentDrive?.startLocation = DLLocationStoreCodable(placeName: storeLoc.placeName, lat: storeLoc.lat, lon: storeLoc.lon)
                            if let drive = self.currentDrive {
                                self.service.saveCurrentDrive(drive)
                            }
                            
                        }
                     //  let (_,_) = await self.weatherService.suntimes(for: location)
                        
                    }
                   
                    
                }
                if (!locationsUpdating) {
                    break
                }
                
            }
        } catch {
            print("error getting location")
        }
        
    }
}
