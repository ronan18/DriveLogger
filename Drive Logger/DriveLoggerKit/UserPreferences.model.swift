//
//  UserPreferences.model.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/8/23.
//

import Foundation

public class UserPreferences: Codable {
    public var goal: TimeInterval
    public var defaultSunrise: DateComponents
    public var defaultSunset: DateComponents
    
    
}
