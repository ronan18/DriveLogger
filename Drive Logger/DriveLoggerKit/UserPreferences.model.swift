//
//  UserPreferences.model.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/8/23.
//

import Foundation

public class UserPreferences: Codable {
    public var goal: TimeInterval
    public var defaultSunrise: SunTime
    public var defaultSunset: SunTime
    
    public init(goal: TimeInterval, defaultSunrise: SunTime, defaultSunset: SunTime) {
        self.goal = goal
        self.defaultSunrise = defaultSunrise
        self.defaultSunset = defaultSunset
    }
}
