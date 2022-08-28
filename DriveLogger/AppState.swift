//
//  AppState.swift
//  DriveLogger
//
//  Created by Ronan Furuta on 9/24/20.
//

import Foundation
import DriveLoggerServicePackage
import CoreLocation
import WeatherKit
import Intents
import FirebaseAnalytics
enum AppScreen {
    case onboard
    case home
    case drive
}

@MainActor
class AppState: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var appScreen = AppScreen.home
    @Published var dlService = DriveLoggerService()
    @Published var state: DriveLoggerAppState = DriveLoggerAppState()
    @Published var recentDrives: [Drive] = []
    @Published var currentDriveStart = Date()
    @Published var locationAllowed = true
    @Published var currentLocation: CLLocation? = nil
    @Published var currentSun: SunriseSunset? = nil
    @Published var currentWeather: DLWeatherResults? = nil
    @Published var startLocation: CLLocation? = nil
    @Published var startCityName: String = ""
    @Published var currentCity: String = ""
    @Published var driveEditor = false
    @Published var presentedDrive: Drive? = nil
    @Published var driving = false
    @Published var defaults = UserDefaults.standard
    @Published var viewAllDrivesScreen: Int? = nil
    @Published var currentDrive: CurrentDrive? = nil
    @Published var dataExport: DLStateDocument = DLStateDocument(data: "")
    
    var drivesWatcher: Any? = nil
    var WS = DLWeather()
    var defaultSunriseSunset = SunriseSunset(sunriseTime: Date(), sunsetTime: Date())
    private let locationManager = CLLocationManager()
    override init() {
        super.init()
        if (self.defaults.bool(forKey: "onboarded")) {
            self.start()
            Analytics.logEvent("startingup", parameters: [:])
        } else {
            self.appScreen = .onboard
            Analytics.logEvent("onboarding", parameters: [:])
        }
        
        
    }
    func startFromOnboard(_ goal: Int) {
        self.requestLocation()
        self.state = self.dlService.retreiveState()
        self.state.goalTime = Double(goal * 60 * 60)
        self.state = self.dlService.computeStatistics(self.state)
        self.appScreen = .home
        self.defaults.setValue(true, forKey: "onboarded")
        // self.dlService.upateWidgets()
        
    }
    
    func start() {
        self.state = self.dlService.retreiveState()
        self.dataExport = DLStateDocument(data: self.dlService.exportData(state: self.state))
        self.state = self.dlService.computeStatistics(self.state)
        self.currentDrive = self.dlService.retreiveCurrentDrive()
        print("currentDrive from startup", self.currentDrive ?? "none")
        if (self.currentDrive != nil) {
            self.driving = true
            self.startLocationUpdating()
            
            self.appScreen = .drive
        } else {
            self.appScreen = .home
            
        }
        
        self.requestLocation()
        Analytics.setUserProperty(String(self.state.drives.count), forName: "driveCount")
        //self.dlService.upateWidgets()
    }
    func computeStatistics() {
        self.state = self.dlService.computeStatistics(self.state)
    }
    func viewAllDrives() {
        if (!self.driving && self.appScreen != .onboard) {
            self.appScreen = .home
            self.viewAllDrivesScreen = 1
        }
        Analytics.logEvent("viewAllDrivesIntent", parameters: [:])
    }
    func logDrive(_ drive: Drive) {
        var drive = drive
        if (drive.endTime < drive.startTime) {
            drive.endTime = drive.startTime
        }
        self.state.drives.append(drive)
        self.state = self.dlService.computeStatistics(self.state)
        self.dlService.saveState(self.state, updateWidgets: true)
        Analytics.logEvent("logDrive", parameters: [:])
        Analytics.setUserProperty(String(self.state.drives.count), forName: "driveCount")
    }
    func updateGoalTime(_ time: Int) {
        self.state.goalTime = TimeInterval(time * 60 * 60)
        self.computeStatistics()
        self.dlService.saveState(self.state, updateWidgets: true)
    }
    func updateDrive(_ drive: Drive) {
        var drive = drive
        if (drive.endTime < drive.startTime) {
            drive.endTime = drive.startTime
        }
        self.state = dlService.updateDrive(drive, state: self.state)
        dlService.saveState(self.state, updateWidgets: true)
        Analytics.logEvent("updateDrive", parameters: [:])
        
    }
    func deleteDrive(_ drive: Drive) {
        self.state = dlService.deleteDrive(drive, state: self.state)
        dlService.saveState(self.state, updateWidgets: true)
        Analytics.logEvent("deleteDrive", parameters: [:])
        Analytics.setUserProperty(String(self.state.drives.count), forName: "driveCount")
        
    }
    func logDrivesViewed() {
        let intent = ViewAllDrivesIntent()
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate(completion: {response in
            print("SIRI view all drives donation:", response as Any)
        })
        Analytics.logEvent("viewingAllDrives", parameters: [:])
    }
    func saveCurrentDrive() {
        print("saving currentDrive", self.currentDrive ?? "none")
        self.dlService.saveCurrentDrive(self.currentDrive)
    }
    func startDrive() {
        if (self.appScreen != .onboard) {
            
            self.driving = true
            self.startLocationUpdating()
            self.currentDriveStart = Date()
            
            self.currentDrive = CurrentDrive(startLocation: self.currentCity, startTime: Date(), sun: self.currentSun ?? self.defaultSunriseSunset )
            print("current drive started", self.currentDrive ?? "none")
            self.appScreen = .drive
            
            self.startLocation = self.currentLocation
            
            self.saveCurrentDrive()
            self.startCityName = self.currentCity
            let intent = StartDriveIntent()
            let interaction = INInteraction(intent: intent, response: nil)
            interaction.donate(completion: {response in
                print("SIRI start drive donation:", response as Any)
            })
            Analytics.logEvent("startDrive", parameters: [:])
        }
        
        
    }
    func endDrive() {
        guard (self.driving)  else {
            return
        }
        guard let currentDrive = self.currentDrive  else {
            return
        }
        
        
        self.driving = false
        let endTime = Date()
        let endLocation = self.currentCity
        
        var location = ""
        if currentDrive.startLocation != "" {
            if (currentDrive.startLocation != endLocation) {
                location = "\(currentDrive.startLocation) --> \(endLocation)"
            } else {
                location = currentDrive.startLocation
            }
        }
        self.presentedDrive = Drive(startTime: currentDrive.startTime, endTime: endTime, location: location)
        self.driveEditor = true
        self.currentDrive = nil
        self.appScreen = .home
        self.saveCurrentDrive()
        locationManager.stopUpdatingLocation()
        let intent = StopDriveIntent()
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate(completion: {response in
            print("SIRI stop drive donation:", response as Any)
        })
        Analytics.logEvent("endDrive", parameters: [:])
        
        
        
    }
    // MARK: Location delegates
    func startLocationUpdating() {
        if self.locationAllowed{
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
            print("location access after start")
            Analytics.setUserProperty("true", forName: "locationAccess")
        } else {
            print("no location access")
            Analytics.setUserProperty("false", forName: "locationAccess")
            self.requestLocation()
            
        }
    }
    func  requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LOCATION: update")
        if let location = locations.first {
            //print(location.coordinate, "location", location)
            
            self.currentLocation = location
           
            dlService.cityName(from: location, result: {locationStr in
                self.currentCity = locationStr
                print("set current city", locationStr)
              
                if (self.driving && self.currentDrive?.startLocation == "") {
                    self.startCityName = locationStr
                    self.currentDrive?.startLocation = locationStr
                    self.currentDrive?.sun = self.currentSun ?? self.defaultSunriseSunset
                    self.saveCurrentDrive()
                }
            })
            if #available(iOS 16, *) {
                Task {
                    self.currentWeather = await self.WS.weather(for: location)
                    let sunData = self.currentWeather?.sunriseSunset
                    
                    if let civilDawn = sunData?.sunriseTime, let civilDusk = sunData?.sunsetTime {
                        self.currentSun = SunriseSunset(sunriseTime: civilDawn, sunsetTime: civilDusk)
                    }
                    
                }
            }
           
            
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        print("location auth status updated")
        switch status {
        case .notDetermined:
            print("location access not determined")
            
            break
        case .authorizedWhenInUse, .authorizedAlways:
            //if CLLocationManager.locationServicesEnabled() {
                self.locationAllowed = true
                Analytics.logEvent("locationAccess", parameters: ["value": true])
                Analytics.setUserProperty("true", forName: "locationAccess")
                print(" location access")
                
           // }
        case .restricted, .denied:
            self.locationAllowed = false
            Analytics.logEvent("locationAccess", parameters: ["value": false])
            Analytics.setUserProperty("false", forName: "locationAccess")
            print("no location access")
            
        @unknown default:
            self.locationAllowed = false
        }
    }
    
}
