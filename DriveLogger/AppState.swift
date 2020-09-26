//
//  AppState.swift
//  DriveLogger
//
//  Created by Ronan Furuta on 9/24/20.
//

import Foundation
import DriveLoggerServicePackage
import CoreLocation
import Intents
enum AppScreen {
    case onboard
    case home
    case drive
}
class AppState: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var appScreen = AppScreen.home
    @Published var dlService = DriveLoggerService()
    @Published var state: DriveLoggerAppState = DriveLoggerAppState()
    @Published var recentDrives: [Drive] = []
    @Published var currentDriveStart = Date()
    @Published var locationAllowed = true
    @Published var currentLocation: CLLocation? = nil
    @Published var startLocation: CLLocation? = nil
    @Published var startCityName: String = ""
    @Published var currentCity: String = ""
    @Published var driveEditor = false
    @Published var presentedDrive: Drive? = nil
    @Published var driving = false
    @Published var defaults = UserDefaults.standard
    var drivesWatcher: Any? = nil
    private let locationManager = CLLocationManager()
    override init() {
        super.init()
        if (self.defaults.bool(forKey: "onboarded")) {
            self.start()
        } else {
            self.appScreen = .onboard
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
        self.state = self.dlService.computeStatistics(self.state)
        self.appScreen = .home
        self.requestLocation()
        //self.dlService.upateWidgets()
    }
    func computeStatistics() {
        self.state = self.dlService.computeStatistics(self.state)
    }
    func logDrive(_ drive: Drive) {
        self.state.drives.append(drive)
        self.state = self.dlService.computeStatistics(self.state)
        self.dlService.saveState(self.state, updateWidgets: true)
    }
    func updateDrive(_ drive: Drive) {
        self.state = dlService.updateDrive(drive, state: self.state)
        dlService.saveState(self.state, updateWidgets: true)
        
    }
    func deleteDrive(_ drive: Drive) {
        self.state = dlService.deleteDrive(drive, state: self.state)
        dlService.saveState(self.state, updateWidgets: true)
        
    }
    func startDrive() {
        if (self.appScreen != .onboard) {
            self.driving = true
            self.startLocationUpdating()
            self.currentDriveStart = Date()
            self.appScreen = .drive
            
            self.startLocation = self.currentLocation
            
            
            self.startCityName = self.currentCity
            let intent = StartDriveIntent()
            let interaction = INInteraction(intent: intent, response: nil)
            interaction.donate(completion: {response in
                print("SIRI start drive donation:", response)
            })
            
        }
        
        
    }
    func endDrive() {
        if (self.driving) {
            self.driving = false
            let endTime = Date()
            let endLocation = self.currentCity
            
            var location = ""
            if startCityName != "" {
                if (startCityName != endLocation) {
                    location = "\(startCityName) --> \(endLocation)"
                } else {
                    location = startCityName
                }
            }
            self.presentedDrive = Drive(startTime: self.currentDriveStart, endTime: endTime, location: location)
            self.driveEditor = true
            self.appScreen = .home
            locationManager.stopUpdatingLocation()
            let intent = StopDriveIntent()
            let interaction = INInteraction(intent: intent, response: nil)
            interaction.donate(completion: {response in
                print("SIRI stop drive donation:", response)
            })
        }
        
    }
    // MARK: Location delegates
    func startLocationUpdating() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
            print("location access after start")
        } else {
            print("no location access")
            
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
            dlService.cityName(from: location, result: {location in
                self.currentCity = location
                if (self.driving && self.startCityName == "") {
                    self.startCityName = location
                }
            })
            
            
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
            if CLLocationManager.locationServicesEnabled() {
                self.locationAllowed = true
                
                print(" location access")
                
            }
        case .restricted, .denied:
            self.locationAllowed = false
            
            print("no location access")
            
        }
    }
    
}
