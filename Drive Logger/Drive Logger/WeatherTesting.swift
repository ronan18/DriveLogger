//
//  WeatherTesting.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 7/12/23.
//

import Foundation
import WeatherKit
import CoreLocation

func testWeather() async {
    do {
        let weather = try await WeatherService().weather(for: CLLocation(latitude: 44.47438, longitude: 73.21403))
        print("weather", weather)
    } catch {
        print(error)
    }
}
