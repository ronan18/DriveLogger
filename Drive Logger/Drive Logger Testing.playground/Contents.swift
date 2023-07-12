import WeatherKit
import MapKit
let weatherService = WeatherService()
func suntimes(for locatation: CLLocation) async -> (Date?, Date?) {
    print("fetching weather for", locatation)
    do {
        let weather = try await weatherService.weather(for: locatation)
        print(weather, "got weather")
        print(weather.dailyForecast, "day weather")
        guard let sun = weather.dailyForecast.forecast.first?.sun else {
            return (nil, nil)
        }
        return (sun.civilDawn, sun.civilDusk)
      
    } catch {
        print("error getting weather", error)
        return (nil, nil)
    }
    
}

Task {
   await suntimes(for: CLLocation(latitude: 44.47438, longitude: 73.21403))
}
