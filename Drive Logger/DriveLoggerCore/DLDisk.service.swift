//
//  DLDisk.service.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/8/23.
//

import Foundation
import Disk


public class DLDiskService {
    var encoder: JSONEncoder = JSONEncoder()
    var decoder: JSONDecoder = JSONDecoder()
    public init () {
        encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "0", negativeInfinity: "0", nan: "0")
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "0", negativeInfinity: "0", nan: "0")
        
    }
    public func readCurrentDrive() -> CurrentDrive? {
        var attemptedRetreival: CurrentDrive? = nil
        do {
            attemptedRetreival = try Disk.retrieve("currentDrive.json", from: .sharedContainer(appGroupName: "group.com.ronanfuruta.drivelogger"), as: CurrentDrive.self, decoder: decoder)
        } catch {
            print("Current Drive not retrieved from disk", error)
            attemptedRetreival = nil
        }
        print("retreived current drive", attemptedRetreival as Any)
        return attemptedRetreival
   
    }
    public func saveCurrentDrive(_ drive: CurrentDrive) {
        print("DL serivice save current drive")
      
            print("saving current drive as a file", drive)
            do {
                try Disk.save(drive, to: .sharedContainer(appGroupName: "group.com.ronanfuruta.drivelogger"), as: "currentDrive.json", encoder: self.encoder)
                print("saved current Drive")
            } catch {
                print("error saving current Drive to disk", error)
            }
      
    }
    public func deleteCurrentDrive() {
    
        print("current drive removing")
        do {
            try Disk.remove("currentDrive.json", from: .sharedContainer(appGroupName: "group.com.ronanfuruta.drivelogger"))
            print("current drive removed")
        } catch {
            print("error removing current drive", error)
        }
    
    }
    public func readUserPreferences() -> UserPreferences? {
        var attemptedRetreival: UserPreferences? = nil
        do {
            attemptedRetreival = try Disk.retrieve("preferences.json", from: .sharedContainer(appGroupName: "group.com.ronanfuruta.drivelogger"), as: UserPreferences.self, decoder: decoder)
        } catch {
            print("Current Drive not retrieved from disk", error)
            attemptedRetreival = nil
        }
        print("retreived current preferences", attemptedRetreival as Any)
        return attemptedRetreival
   
    }
    public func saveUserPreferences(_ preferences: UserPreferences) {
        print("DL serivice save current preferences")
      
            print("saving current preferences as a file", preferences)
            do {
                try Disk.save(preferences, to: .sharedContainer(appGroupName: "group.com.ronanfuruta.drivelogger"), as: "preferences.json", encoder: self.encoder)
                print("saved current preferences")
            } catch {
                print("error saving current preferences to disk", error)
            }
      
    }
    
}
