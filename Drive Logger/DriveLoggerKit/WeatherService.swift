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
    public enum DLWeatherServiceError: Error {
        case noSunEvent
    }
    public func suntimes(for locatation: CLLocation) async throws -> SunEvents {
        print("fetching weather for", locatation)
        do {
            let weather = try await weatherService.weather(for: locatation)
            print(weather, "got weather")
            print(weather.dailyForecast, "day weather")
           guard let sun = weather.dailyForecast.forecast.first?.sun else {
               throw DLWeatherServiceError.noSunEvent
            }
            return sun
          
        } catch {
            print("error getting weather", error)
           throw error
        }
        
    }

}
