//
//  DriveLoggerService.swift
//  DriveLoggerServicePackage
//
//  Created by Ronan Furuta on 9/24/20.
//

import Foundation
import Disk
import CoreLocation
import Combine
import WidgetKit
import UIKit
public struct Drive: Codable, Identifiable {
    public init (startTime: Date, endTime: Date,location: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
    }
    public var id = UUID()
    public var startTime: Date
    public var endTime: Date
    public var location: String
}
public struct DriveLengthDay: Codable, Identifiable {
    public var id = UUID()
    public var date: Date
    public var length: Double
    public init(id: UUID = UUID(), date: Date, length: TimeInterval) {
        self.id = id
        self.date = date
        self.length = length
    }
}
public struct DriveLoggerAppState: Codable {
    public init (drives: [Drive] = [], totalTime: TimeInterval = 0, dayDriveTime: TimeInterval = 0, nightDriveTime: TimeInterval = 0, averageDriveDuration: TimeInterval = 0, percentComplete: Int = 0,goalTime: TimeInterval = (50*60*60), timeToday: TimeInterval? = nil, driveLengthByDay: [DriveLengthDay]? = []) {
        self.drives = drives
        self.totalTime = totalTime
        self.dayDriveTime = dayDriveTime
        self.nightDriveTime = nightDriveTime
        self.averageDriveDuration = averageDriveDuration
        self.percentComplete = percentComplete
        self.goalTime = goalTime
        self.timeToday = timeToday ?? 0
    }
    public var drives: [Drive] = []
    public var drivesSortedByDate: [Drive] = []
    public var totalTime: TimeInterval = 0
    public var dayDriveTime: TimeInterval = 0
    public var nightDriveTime: TimeInterval = 0
    public var timeBreakdown: String = ""
    public var averageDriveDuration: TimeInterval = 0
    public var percentComplete: Int = 0
    public var goalTime: TimeInterval = (50*60*60)
    public var timeToday: TimeInterval? = 0
    public var driveLengthByDay: [DriveLengthDay] = []
    
    private enum CodingKeys: String, CodingKey {
            case drives, drivesSortedByDate,totalTime,dayDriveTime,nightDriveTime,timeBreakdown,averageDriveDuration,percentComplete,timeToday,goalTime
        }
}

public class DriveLoggerService {
    
    
    var encoder: JSONEncoder = JSONEncoder()
    var decoder: JSONDecoder = JSONDecoder()
    var searchTimer: Timer? = nil
    var debounceWidgets = false
    public init () {
        encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "0", negativeInfinity: "0", nan: "0")
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "0", negativeInfinity: "0", nan: "0")
        
    }
   public func hapticResponse() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
    }
    public func exportData(state: DriveLoggerAppState) -> String {
        print("Starting encode")
     
            let encoder = JSONEncoder()
            do {
            let data = try encoder.encode(state)
            // 2
            let string = String(data: data, encoding: .utf8)!
           // let data = stateData.encode(to: String)
           // let string = String(decoding: data, as: UTF8.self)
            print("encode", string)
                return string
            } catch {
                print("error encode", error)
                return ""
            }
        
    }
    public func retreiveCurrentDrive() -> CurrentDrive? {
        var attemptedRetreival: CurrentDrive? = nil
        do {
            attemptedRetreival = try Disk.retrieve("currentDrive.json", from: .sharedContainer(appGroupName: "group.com.ronanfuruta.drivelogger"), as: CurrentDrive.self, decoder: decoder)
        } catch {
            print("Current Drive not retrieved from disk", error)
            attemptedRetreival = nil
        }
        print("retreived current drive", attemptedRetreival)
        return attemptedRetreival
    }
    public func saveCurrentDrive(_ currentDrive: CurrentDrive?) {
        print("DL serivice save current drive")
        if let currentDrive = currentDrive {
            print("saving current drive as a file", currentDrive)
            do {
                try Disk.save(currentDrive, to: .sharedContainer(appGroupName: "group.com.ronanfuruta.drivelogger"), as: "currentDrive.json", encoder: self.encoder)
                print("saved current Drive")
            } catch {
                print("error saving current Drive to disk", error)
            }
        } else {
            print("current drive removing")
            do {
                try Disk.remove("currentDrive.json", from: .sharedContainer(appGroupName: "group.com.ronanfuruta.drivelogger"))
                print("current drive removed")
            } catch {
                print("error removing current drive", error)
            }
        }
       
    }
    public func retreiveState() -> DriveLoggerAppState{
        let attemptedRetreval:DriveLoggerAppState?
        do {
            attemptedRetreval = try Disk.retrieve("applicationState.json", from: .sharedContainer(appGroupName: "group.com.ronanfuruta.drivelogger"), as: DriveLoggerAppState.self, decoder: decoder)
        } catch {
            print("AppState not retrieved from disk", error)
            attemptedRetreval = nil
        }
        if let state = attemptedRetreval {
            return self.computeStatistics(state)
            print("used disk state", state)
        } else {
            return DriveLoggerAppState()
        }
    }
    public func upateWidgets(_ force: Bool = false) {
        print("requested widget update")
        self.searchTimer?.invalidate()
        if (force && self.debounceWidgets) {
            WidgetCenter.shared.reloadAllTimelines()
            print("updateing widgets forced")
        } else if (!force) {
            self.debounceWidgets = true
            searchTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: false, block: { [weak self] (timer) in
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    //Use search text and perform the query
                    DispatchQueue.main.async {
                        //Update UI
                        WidgetCenter.shared.reloadAllTimelines()
                        print("updateing widgets")
                        
                        self?.debounceWidgets = false
                    }
                }
            })
        }
        
    }
    public func saveState(_ state: DriveLoggerAppState, updateWidgets: Bool = false) {
        do {
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try Disk.save(state, to: .sharedContainer(appGroupName: "group.com.ronanfuruta.drivelogger"), as: "applicationState.json", encoder: self.encoder)
                    
                } catch {
                    print("error saving state to disk", error)
                }
                DispatchQueue.main.async {
                    print("saved app state to disk")
                    if (updateWidgets) {
                        self.upateWidgets()
                    }
                    
                    
                }
            }
            
        } catch {
            print("AppState not saved to disk", error)
            
        }
    }
    public func isNightDrive(_ drive: Drive) -> Bool {
        let sunsetHour = 19
        let sunriseHour = 5
        var startDateComponents = Calendar.current.dateComponents([.hour, .minute, .day, .month, .year, .calendar],from: drive.startTime)
        let startHour = startDateComponents.hour!
        let endHour = Calendar.current.component(.hour, from: drive.endTime)
      
       
        var eveningDateComponents = DateComponents()
        var sunriseDateComponents = DateComponents()
        sunriseDateComponents = startDateComponents
        eveningDateComponents = startDateComponents
        eveningDateComponents.hour = sunsetHour
        eveningDateComponents.minute = 0
        sunriseDateComponents.hour = sunriseHour
        sunriseDateComponents.minute = 0
        var sunriseTime = Calendar.current.date(from: sunriseDateComponents)
        if (startHour > sunriseHour) {
            print("night drive time startHour", startHour, sunriseHour, drive.location)
            if let time = sunriseTime {
                sunriseTime = Calendar.current.date(byAdding: .day, value: 1, to: time)
            }
        }
      
         
        let eveningTime = Calendar.current.date(from: eveningDateComponents)
      
        if (startHour >= sunsetHour && (endHour <= sunriseHour || endHour >= sunsetHour) ) { // entire drive in side of night time
            print("night display all in", drive.location)
          return true
        } else if (startHour <= sunsetHour && (endHour <= sunriseHour || endHour >= sunsetHour)) { // drive starts outside of time and ends in side of time
            print("night display start out end in", drive.location)
          
                return true
            
        } else if ((startHour >= sunsetHour || startHour < sunriseHour) && endHour <= sunsetHour) { // drive starts in side of time and ends outside of time
            print("night display start in end out", drive.location)
            
            return true
        }
        return false
    }
    public func computeStatistics(_ state: DriveLoggerAppState) -> DriveLoggerAppState {
        print("compute drive statistics")
        var state = state
        var totalTime: TimeInterval = 0
        var dayDriveTime: TimeInterval = 0
        var nightDriveTime: TimeInterval = 0
        var averageDriveDuration: TimeInterval = 0
        var timeToday: TimeInterval = 0
        state.drives.forEach {drive in
            var driveTime:TimeInterval = 0
            print("drive times", drive.startTime, drive.endTime)
            if (drive.startTime == drive.endTime || drive.endTime < drive.startTime) {
                driveTime = 0
            } else {
                driveTime = drive.endTime.timeIntervalSince(drive.startTime)
                
            }
            totalTime += driveTime
            let sunsetHour = 19
            let sunriseHour = 5
            var startDateComponents = Calendar.current.dateComponents([.hour, .minute, .day, .month, .year, .calendar],from: drive.startTime)
            let startHour = startDateComponents.hour!
            let endHour = Calendar.current.component(.hour, from: drive.endTime)
          
           
            var eveningDateComponents = DateComponents()
            var sunriseDateComponents = DateComponents()
            sunriseDateComponents = startDateComponents
            eveningDateComponents = startDateComponents
            eveningDateComponents.hour = sunsetHour
            eveningDateComponents.minute = 0
            sunriseDateComponents.hour = sunriseHour
            sunriseDateComponents.minute = 0
            var sunriseTime = Calendar.current.date(from: sunriseDateComponents)
            if (startHour > sunriseHour) {
                print("night drive time startHour", startHour, sunriseHour, drive.location)
                if let time = sunriseTime {
                    sunriseTime = Calendar.current.date(byAdding: .day, value: 1, to: time)
                }
            }
          
             
            let eveningTime = Calendar.current.date(from: eveningDateComponents)
          
            if (startHour >= sunsetHour && (endHour <= sunriseHour || endHour >= sunsetHour) ) { // entire drive in side of night time
                print("night drive all in", drive.location)
                nightDriveTime += driveTime
            } else if (startHour <= sunsetHour && (endHour <= sunriseHour || endHour >= sunsetHour)) { // drive starts outside of time and ends in side of time
                print("night drive start out end in", drive.location)
                if let eveningTime = eveningTime {
                    let interval = drive.endTime.timeIntervalSince(eveningTime)
                    print("night drive SOEI added", interval / 60)
                nightDriveTime += interval
                } else {
                    print("night drive error")
                }
            } else if ((startHour >= sunsetHour || startHour < sunriseHour) && endHour <= sunsetHour) { // drive starts in side of time and ends outside of time
                print("night drive start in end out", drive.location)
                if let sunriseTime = sunriseTime {
                    let interval = sunriseTime.timeIntervalSince(drive.startTime)
                    print("night drive SIEO added", interval / 60)
                    nightDriveTime += interval
                } else {
                    print("night drive error")
                }
            }
            let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            let driveDay = Calendar.current.dateComponents([.year, .month, .day], from: drive.endTime)
            if (today == driveDay) {
                timeToday += driveTime
            }
            
            
        }
        averageDriveDuration = totalTime / Double(state.drives.count)
        dayDriveTime = totalTime - nightDriveTime
        state.totalTime = totalTime
        state.dayDriveTime = dayDriveTime
        state.nightDriveTime = nightDriveTime
        state.averageDriveDuration = averageDriveDuration
        state.percentComplete = Int((totalTime / state.goalTime)*100)
        state.drivesSortedByDate = state.drives.sorted(by: { (a, b) -> Bool in
            return a.startTime > b.startTime
        })
        state.timeToday = timeToday
        print("raw complete", totalTime / state.goalTime)
    
        var days: [Date: TimeInterval] = [:]
        print("TIME PER DAY COMPUTE: Running computer on days", state.drivesSortedByDate.count)
        state.drivesSortedByDate.forEach({drive in
            print("TIME PER DAY COMPUTE: running by day", drive.id)
            let components = Calendar.current.dateComponents([.year,
                                                              .month, .day], from: drive.startTime)
            let length = drive.endTime.timeIntervalSince(drive.startTime)
            print("TIME PER DAY COMPUTE: components for drive", components)
            let date = Calendar.current.date(from: components)!
            if var existing =  days[date] {
                existing += length
                days[date] = existing
                print("TIME PER DAY COMPUTE: exists", existing)
            } else {
                print("TIME PER DAY COMPUTE: does not exist", length)
                days[date] = length
            }
            
        })
        let result: [DriveLengthDay] =   days.map { key,value in
            return DriveLengthDay(date: key, length: value)
        }.sorted(by: { (a, b) -> Bool in
            return a.date > b.date
        })
        
        print("TIME PER DAY COMPUTE: result", result)
        state.driveLengthByDay = result
        return state
        
    }
    
    public func updateDrive(_ drive: Drive, state: DriveLoggerAppState) -> DriveLoggerAppState{
        let id = drive.id
        var drives = state.drives
        let index = drives.firstIndex(where: {drive in drive.id == id})
        if let index = index {
            drives[index] = drive
        } else {
            drives.append(drive)
        }
        var state = state
        state.drives = drives
        return self.computeStatistics(state)
    }
    public func deleteDrive(_ drive: Drive, state: DriveLoggerAppState) -> DriveLoggerAppState{
        let id = drive.id
        var drives = state.drives
        let index = drives.firstIndex(where: {drive in drive.id == id})
        if let index = index {
            drives.remove(at: index)
        }
        var state = state
        state.drives = drives
        return self.computeStatistics(state)
    }
    
    public func displayTimeInterval(_ timeInterval: TimeInterval) -> TimeDisplay{
        if (timeInterval > 60*60){
            return TimeDisplay(value: String(Int(timeInterval / (60*60))), unit: "hr")
        } else if (timeInterval > 60) {
            return TimeDisplay(value: String(Int(timeInterval / 60)), unit: "min")
        }  else {
            return TimeDisplay(value: "0", unit: "min")
            
        }
    }
    public func displayDateInterval(_ dateInterval: DateInterval) -> TimeDisplay {
        let timeInterval = dateInterval.duration
        print("date display", dateInterval, timeInterval)
        if (timeInterval > 60*60){
            return TimeDisplay(value: String(Int(timeInterval / (60*60))), unit: "hr")
        } else if (timeInterval > 60) {
            return TimeDisplay(value: String(Int(timeInterval / 60)), unit: "min")
        } else {
            
            return TimeDisplay(value: "0", unit: "min")
            
        }
    }
    
    public func displayDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: date)
    }
    public func cityName(from: CLLocation, result: @escaping ((String) -> ())) {
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
                 /*   if let thoroughfare = placeMark?.thoroughfare {
                        if let subLocality =  placeMark?.subLocality {
                            print("thuroughfare, sublocality")
                            resultString = "\(thoroughfare), \(subLocality)"
                        }
                        
                    } else {
                        if let subLocality =  placeMark?.subLocality {
                            print("sublocality")
                            resultString = subLocality
                        } else if let name = placeMark?.name {
                            if let locality = placeMark?.locality {
                                print("name, locality")
                                resultString = "\(name), \(locality)"
                            } else {
                                print("name")
                                resultString = "\(name)"
                            }
                            
                        }
                    }
                    */
                    result(resultString)
                    
                } else {
                    result("")
                }
                
            } else {
                result("")
            }
        })
    }
}
