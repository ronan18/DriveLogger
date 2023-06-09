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
            let weather = try await weatherService.weather(for: locatation, including: .daily)
            print(weather, "got weather")
                //   print(weather.dailyForecast, "day weather")
         /*   guard let sun = weather.dailyForecast.forecast.first?.sun else {
                return (nil, nil)
            }
            return (sun.civilDawn, sun.civilDusk)*/
            return (nil, nil)
        } catch {
            print("error getting weather", error)
            return (nil, nil)
        }
        
    }

}
