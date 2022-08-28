//
//  WeatherService.swift
//  DriveLoggerServicePackage
//
//  Created by Ronan Furuta on 8/27/22.
//

import Foundation
import WeatherKit
import CoreLocation

public struct SavedWeatherData: Codable {
    let sunriseTime: Date
    let sunsetTime: Date
    let weatherIcon: String
    let weatherCondition: String
    let formattedTemp: String
    let rawValueTemp: Double
    public init(sunriseTime: Date, sunsetTime: Date, weatherIcon: String, weatherCondition: String, formattedTemp: String, rawValueTemp: Double) {
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
        self.weatherIcon = weatherIcon
        self.weatherCondition = weatherCondition
        self.formattedTemp = formattedTemp
        self.rawValueTemp = rawValueTemp
    }
}
#if canImport(WeatherKit)
@available(iOSApplicationExtension 16.0, *)
struct LastWeatherSearch {
    let location: CLLocation
    let time: Date
    var success: Bool
    var weather: DLWeatherResults?
    init(location: CLLocation, time: Date = Date(), success: Bool = false, weather: DLWeatherResults? = nil) {
        self.location = location
        self.time = time
        self.success = success
        self.weather = weather
    }
}
@available(iOSApplicationExtension 16.0, *)
public struct DLWeatherResults {
   public var current: CurrentWeather
    public var today: DayWeather
    public var time: Date
    public var sunriseSunset: SunriseSunset
}
@available(iOSApplicationExtension 16.0, *)
public class DLWeather {
    
    let WS = WeatherService()
    var lastSearch: LastWeatherSearch? = nil
    public var attributionInfo: WeatherAttribution? = nil
    
     public init() {
        
       
        Task {
            await self.getAttribution()
        }
    }
    
    func getAttribution() async -> WeatherAttribution{
        let attribution = try! await WeatherService.shared.attribution
        self.attributionInfo = attribution
        return attribution
    }
    public func weather(for location: CLLocation) async -> DLWeatherResults? {
        print("WS: get weather for loc \(location.hashValue)")
        //TODO: Fix this and make it more efficient
        print("WS: last search \(self.lastSearch?.weather != nil)")
        if let lastLoc = self.lastSearch?.location {
            guard ((location.distance(from: lastLoc) > 5) || self.lastSearch?.weather == nil) else {
                print("WS: search result for this location allready exists")
                return self.lastSearch?.weather
            }
        }
        self.lastSearch = LastWeatherSearch(location: location)
        do {
            let current = try await WS.weather(for: location, including: .current)
            let day = try await WS.weather(for: location, including: .daily)
            print("WS: Got weather")
            let res = DLWeatherResults(current: current, today: day.first!, time: Date(), sunriseSunset: SunriseSunset(sunriseTime: day.first!.sun.sunrise!, sunsetTime: day.first!.sun.sunset!))
            self.lastSearch = LastWeatherSearch(location: location, success: true, weather: res)

            return res
        } catch {
            print("WS: Error getting weather", error)
            self.lastSearch = nil
            return nil
        }
        
    }
    public func sunsetSunriseTime(for location: CLLocation) async -> SunEvents? {
        guard let weather = await self.weather(for: location) else {
            print("WS: Error getting weather internal func")
            return nil
        }
        print("WS Sun gotten \(String(describing: weather.today.sun.sunrise))")
        return weather.today.sun
        
    }
    
   
}
#else
public class DLWeather {
    public let attribution = nil
    public init() {
        
    }
    public func sunsetSunriseTime(for location: CLLocation) -> SunriseSunset? {
        return nil
    }
    
}

#endif
