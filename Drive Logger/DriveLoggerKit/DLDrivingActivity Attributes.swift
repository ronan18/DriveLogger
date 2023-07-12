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
        public init (emoji: String, currentDrive: CurrentDrive) {
            self.emoji = emoji
            self.currentDrive = currentDrive
        }
        public var emoji: String
        public var currentDrive: CurrentDrive
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
    public init ( name: String) {
      
        self.name = name
    }
   
}
