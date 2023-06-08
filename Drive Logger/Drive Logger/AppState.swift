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

@Observable
public final class AppState {
  //  public var drivingState: DrivingState = DrivingState(from)
  public var context: ModelContext? = nil
    public var driving = false
    public var currentDriveStart: Date? = nil
    public var currentDriveEnd: Date? = nil
    public var goal: TimeInterval? = 50*60*60
    public var driveEditorPresented = false
    public var driveToBeEdited: Drive = Drive(sampleData: true)
    
    public init(context: ModelContext) {
        self.context = context
    }
    
    public init(firstBoot: Bool = false) {
     //   self.start()
    }
    
    

   
     public func startDrive() {
        self.driving = true
        self.currentDriveStart = Date()
       
      
    }
    @MainActor
     public func stopDrive() {
         print("stoping drive")
         guard let context = context else {
            
             return
         }
        self.currentDriveEnd = Date()
        self.driving = false
        guard let currentDriveEnd = currentDriveEnd else {
            print("no drive end")
            return
        }
        guard let currentDriveStart = currentDriveStart else {
            print("no drive start")
            return
        }
         let newDrive = Drive(id: UUID(), startTime: currentDriveStart, endTime: currentDriveEnd, startLocation: nil, endLocation: nil, startLocationName: "new", endLocationName: nil, sunsetTime: SunTime(hour: 19, minute: 30), sunriseTime: SunTime(hour: 7, minute: 45))
         print("new drive", newDrive)
        context.insert(newDrive)
         do {
             try context.save()
         } catch {
             print("error saving new drive")
         }
         
    }
}
