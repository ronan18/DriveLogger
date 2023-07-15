//
//  AppState.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/6/23.
//

import Foundation
import Observation
import DriveLoggerKit
import SwiftData
import CoreLocation
import ActivityKit
import WeatherKit
import WidgetKit

@Observable
public final class AppState {
  //  public var drivingState: DrivingState = DrivingState(from)
    
    static let shared = AppState()
    let defaults = UserDefaults.standard
  public var context: ModelContext? = nil
    public var currentDrive: CurrentDrive? = nil
    var lastLocation: DLLocationStore? = nil
   
    public var goal: TimeInterval = 50*60*60
    public var driveEditorPresented = false
    public var driveToBeEdited: Drive = Drive(sampleData: true)
    
    public var statistics = DriveLoggerStatistics(drives: [])
    
    private let manager: CLLocationManager
    private var locationsUpdating = false
    private var service = DLDiskService()
    private var weatherService = DLWeather()
    private var activity: Activity<DL_Driving_ActivityAttributes>? = nil
    
    public init(context: ModelContext) {
        self.manager = CLLocationManager()
        
        self.context = context
        
    }
    
    public init(firstBoot: Bool = false) {
     //   self.start()
        self.manager = CLLocationManager()
        
        self.currentDrive = service.readCurrentDrive()
        if let currentDrive = self.currentDrive {
            Task {
                await self.monitorLocation()
            }
            let adventure = DL_Driving_ActivityAttributes(currentDrive: currentDrive)

            let initialState = DL_Driving_ActivityAttributes.ContentState(
             currentDrive: currentDrive
            )
            let content =  ActivityContent(state: initialState, staleDate: nil, relevanceScore: 0.0)
            print("start drive activity")
            do {
                self.activity = try Activity.request(
                   attributes: adventure,
                   content: content
                )
                print("activity created", activity?.id as Any, activity.debugDescription)
                self.observeLiveActivity(activity: activity!)
                
            } catch {
                print("error making activity", error.localizedDescription)
            }
        }
        
    }
    
    
    public func hashDrives(drives: [Drive]) -> String {
        var result: String = ""
        
        drives.forEach({drive in
            result += String(drive.valueHash)
        })
        return MD5(string: result).base64EncodedString() + self.goal.description
    }
    public func reloadWidgets(hash: String) {
        print("DL starting reload widget")
        if let lastHash = self.defaults.string(forKey: "drivesHash") {
            print("DL Drives", lastHash, hash)
            if (lastHash == hash) {
                print("DL Drives hash is same, cancling")
                return
            }
        }
        
        print("DL Drives hash different or doesn't exist, updating")
        WidgetCenter.shared.reloadAllTimelines()
        self.defaults.setValue(hash, forKey: "drivesHash")
        return
    }
     public func startDrive() {
         let drive = CurrentDrive(start: Date(), startLocation: nil)
         self.currentDrive = drive
         service.saveCurrentDrive(drive)
         Task {
             await self.monitorLocation()
         }
         let adventure = DL_Driving_ActivityAttributes(currentDrive: drive)

         let initialState = DL_Driving_ActivityAttributes.ContentState(
          currentDrive: drive
         )
         let content =  ActivityContent(state: initialState, staleDate: nil, relevanceScore: 0.0)
         print("start drive activity")
         do {
             self.activity = try Activity.request(
                attributes: adventure,
                content: content
             )
             print("activity created", activity?.id as Any, activity.debugDescription)
             self.observeLiveActivity(activity: activity!)
             
         } catch {
             print("error making activity", error.localizedDescription)
         }
         Task {
             do {
                try await StartDrive().donate()
             } catch {
                 print(error)
             }
         }
    }
    func observeLiveActivity(activity: Activity<DL_Driving_ActivityAttributes>) {
        Task {
            for await activityState in activity.activityStateUpdates {
                print("activity state", activityState)
            }
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
         var weather: CurrentWeather? = nil
         if let startLocation = drive?.startLocation {
             do {
                let sunEvents = try await weatherService.suntimes(for: CLLocation(latitude: startLocation.lat, longitude: startLocation.lon))
                 if let civilDawn = sunEvents.civilDawn {
                     sunRiseTime = civilDawn
                 }
                 
                 if let civilDusk = sunEvents.civilDusk {
                     sunSetTime = civilDusk
                 }
                
             } catch {
                 print(error, "weather")
             }
          
           
             print("sun rise sunset time for drive", sunSetTime, sunRiseTime)
            weather = await try? weatherService.condtitions(for: CLLocation(latitude: startLocation.lat, longitude: startLocation.lon))
         }
        
         let newDrive = Drive(id: UUID(), startTime: currentDriveStart, endTime: currentDriveEnd, startLocation: drive?.startLocation?.normal(), endLocation: endLocation, startLocationName: drive?.startLocation?.normal().placeName ?? "", endLocationName: endLocation?.placeName, sunsetTime: sunSetTime, sunriseTime: sunRiseTime, weather: weather)
         print("new drive", newDrive)
        context.insert(newDrive)
         do {
             try context.save()
         } catch {
             print("error saving new drive context")
         }
         Task {
             if self.activity != nil {
                 let dismissalPolicy: ActivityUIDismissalPolicy = .default
                 let final = DL_Driving_ActivityAttributes.ContentState(currentDrive: drive!)
                 await self.activity!.end(
                    ActivityContent(state: final, staleDate: nil),
                    dismissalPolicy: dismissalPolicy)
             }
             do {
                 try await EndDrive().donate()
             } catch {
                 print(error)
             }
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
