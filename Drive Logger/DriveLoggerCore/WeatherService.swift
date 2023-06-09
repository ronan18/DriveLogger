//
//  WeatherService.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/9/23.
//

import Foundation
import WeatherKit
import CoreLocation

public class DLWeather {
    
    let weatherService = WeatherService()
    
    public init() {
        
    }
    
    public func suntimes(for locatation: CLLocation) async -> (Date?, Date?) {
        print("fetching weather for", locatation)
        do {
            let weather = try await weatherService.weather(for: locatation)
            print(weather, "got weather")
            guard let sun = weather.dailyForecast.forecast.first?.sun else {
                return (nil, nil)
            }
            return (sun.civilDawn, sun.civilDusk)
        } catch {
            print("error getting weather", error)
            return (nil, nil)
        }
        
    }

}
