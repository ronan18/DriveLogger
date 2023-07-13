//
//  DLDrivingActivity Attributes.swift
//  DriveLoggerKit
//
//  Created by Ronan Furuta on 7/9/23.
//

import Foundation
import ActivityKit
public struct DL_Driving_ActivityAttributes: ActivityAttributes {
   
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        public init (currentDrive: CurrentDrive) {
         
            self.currentDrive = currentDrive
        }
       
        public var currentDrive: CurrentDrive
    }

    // Fixed non-changing properties about your activity go here!
    var currentDrive: CurrentDrive
    public init ( currentDrive: CurrentDrive) {
      
        self.currentDrive = currentDrive
    }
   
}
