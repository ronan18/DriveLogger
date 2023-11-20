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
import MapKit

@Observable
public final class AppState {
  //  public var drivingState: DrivingState = DrivingState(from)
    
    static let shared = AppState()
    let defaults = UserDefaults.standard
    public var context: ModelContext? = nil
    public var currentDrive: CurrentDrive? = nil
    var lastLocation: DLLocationPointStore? = nil
    var lastLocationData: CLLocation? = nil
    var locationList: [DLRoutePoint] = []
    
   
    public var goal: TimeInterval = 50*60*60
    public var defaultSunrise: SunTime = SunTime(hour: 6, minute: 26)
    public var defaultSunset: SunTime = SunTime(hour: 19, minute: 30)
    
    public var setUpFlow = false
    public var driveEditorPresented = false
    public var driveToBeEdited: DLDrive? = nil
    
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
        self.manager.allowsBackgroundLocationUpdates = true
        self.manager.showsBackgroundLocationIndicator = true
        let preferences = service.readUserPreferences()
        if let preferences = preferences {
            self.goal = preferences.goal
            self.defaultSunrise = preferences.defaultSunrise
            self.defaultSunset = preferences.defaultSunset
            print("DLPREF: set precerences", preferences)
        } else {
            print("DLPREF: No preferences")
            self.setUpFlow = true
        }
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
    
    public func updatePreferences() {
        self.service.saveUserPreferences(.init(goal: self.goal, defaultSunrise: self.defaultSunrise, defaultSunset: self.defaultSunset))
    }
    public func hashDrives(drives: [DLDrive]) -> String {
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
         let drive = CurrentDrive(start: Date(), startLocation: nil, route: nil)
         self.currentDrive = drive
         self.locationList = []
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
        var endLocation: DLLocationPointStore? = nil
        
        if let lastLoc = lastLocation {
            let item = DLLocationPointStore(placeName: lastLoc.placeName, lat: lastLoc.lat, lon: lastLoc.lon)
           context.insert(item)
            endLocation = item
            print("last location", lastLoc, lastLoc.context, lastLoc.hasChanges())
           
            print("end location", endLocation,  endLocation!.context, endLocation!.hasChanges())
            print("item location", item,  item.context, item.hasChanges())
        }
         
        
         service.deleteCurrentDrive()
         self.locationsUpdating = false
         self.manager.stopUpdatingLocation()
       
         guard let currentDriveStart = drive?.start else {
            print("no drive start")
            return
        }
         
         var sunSetTime =  self.defaultSunset.date()
         var sunRiseTime =  self.defaultSunrise.date()
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
                print("got sunrise and sunset times")
             } catch {
                 print(error, "weather")
             }
          
           
             print("sun rise sunset time for drive", sunSetTime, sunRiseTime)
             weather = try? await weatherService.condtitions(for: CLLocation(latitude: startLocation.lat, longitude: startLocation.lon))
         }
        
         let newDrive = DLDrive(id: UUID(), startTime: currentDriveStart, endTime: currentDriveEnd, startLocation: drive?.startLocation, endLocation: lastLocation, startLocationName: drive?.startLocation?.placeName ?? "", endLocationName: endLocation?.placeName, sunsetTime: sunSetTime, sunriseTime: sunRiseTime, weather: weather, route: self.locationList.count > 0 ? DLRouteStore(routePoints: self.locationList) : nil)
         print("new drive", newDrive)
         
        context.insert(newDrive)
         print("DL CONTEXT SAVE saved context new drive")
         do {
             try context.save()
            
         } catch {
             print("DL CONTEXT SAVE error saving new drive context", error)
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
                if (!locationsUpdating) {
                    break
                }
                if let location = update.location {
                    self.locationList.append(DLRoutePoint(from: location))
                    self.lastLocationData = location
                   // self.tripPolyLine = .init(coordinates: self.locationList, count: locationList.count)
                    if let locationName = await DLLocationService.shared.cityName(from: location) {
                        print(locationName, "location name")
                        let storeLoc = DLLocationPointStore(placeName: locationName, lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                        self.lastLocation = storeLoc
                      
                        if (self.currentDrive?.startLocation == nil && self.currentDrive != nil) {
                            self.currentDrive?.startLocation = DLLocationPointStore(placeName: storeLoc.placeName, lat: storeLoc.lat, lon: storeLoc.lon)
                            if let drive = self.currentDrive {
                                self.service.saveCurrentDrive(drive)
                            }
                            
                        }
                     //  let (_,_) = await self.weatherService.suntimes(for: location)
                        
                    }
                   
                    
                }
                
                
            }
        } catch {
            print("error getting location")
        }
        
    }
}
