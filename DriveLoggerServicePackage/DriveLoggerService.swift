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
public struct DriveLoggerAppState: Codable {
    public init (drives: [Drive] = [], totalTime: TimeInterval = 0, dayDriveTime: TimeInterval = 0, nightDriveTime: TimeInterval = 0, averageDriveDuration: TimeInterval = 0, percentComplete: Int = 0,goalTime: TimeInterval = (50*60*60)) {
        self.drives = drives
        self.totalTime = totalTime
        self.dayDriveTime = dayDriveTime
        self.nightDriveTime = nightDriveTime
        self.averageDriveDuration = averageDriveDuration
        self.percentComplete = percentComplete
        self.goalTime = goalTime
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
   public func computeStatistics(_ state: DriveLoggerAppState) -> DriveLoggerAppState {
        var state = state
        var totalTime: TimeInterval = 0
        var dayDriveTime: TimeInterval = 0
        var nightDriveTime: TimeInterval = 0
        var averageDriveDuration: TimeInterval = 0
        state.drives.forEach {drive in
            let driveTime = DateInterval(start: drive.startTime, end: drive.endTime).duration
            totalTime += driveTime
            let startHour = Calendar.current.component(.hour, from: drive.startTime)
            let endHour = Calendar.current.component(.hour, from: drive.endTime)
            
            if (startHour >= 19 || endHour >= 19) {
                nightDriveTime += driveTime
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
    print("raw complete", totalTime / state.goalTime)
    state.timeBreakdown = "\(displayTimeInterval(state.dayDriveTime).value)\(displayTimeInterval(state.dayDriveTime).unit) day \(displayTimeInterval(state.nightDriveTime).value)\(displayTimeInterval(state.nightDriveTime).unit) night"
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
                    result(placeMark?.locality ?? "")
                } else {
                    result("")
                }
                
            } else {
                result("")
                }
        })
    }
}
