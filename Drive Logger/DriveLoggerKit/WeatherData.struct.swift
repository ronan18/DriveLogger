//
//  WeatherData.struct.swift
//  DriveLoggerKit
//
//  Created by Ronan Furuta on 7/24/23.
//

import Foundation
import WeatherKit
public struct WeatherData: Codable {
    let feelsLike: Measurement<UnitTemperature>
    let temp: Measurement<UnitTemperature>
    let wind: Wind
    let cloudCover: Double
    let condition: WeatherCondition
    let visibility: Measurement<UnitLength>
    let symbolName: String
    let metadata: WeatherMetadata
    
    public init(from currentWeather: CurrentWeather) {
        self.feelsLike = currentWeather.apparentTemperature
        self.temp = currentWeather.temperature
        self.wind = currentWeather.wind
        self.cloudCover = currentWeather.cloudCover
        self.condition = currentWeather.condition
        self.visibility = currentWeather.visibility
        self.symbolName = currentWeather.symbolName
        self.metadata = currentWeather.metadata
    }
    func storeValue() throws -> Data {
        let encoder = JSONEncoder()
        do {
          let encoded = try encoder.encode(self)
                return encoded
            
        } catch {
            throw(error)
        }
    }
}
