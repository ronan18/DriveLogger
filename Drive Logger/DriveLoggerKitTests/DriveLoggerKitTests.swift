//
//  DriveLoggerKitTests.swift
//  DriveLoggerKitTests
//
//  Created by Ronan Furuta on 7/9/23.
//

import XCTest
@testable import DriveLoggerKit
import CoreLocation

final class DriveLoggerKitTests: XCTestCase {

    var sampleDrives: [Drive] = []
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        for _ in 1...500 {
            sampleDrives.append(Drive(sampleData: true))
        }
       
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWeatherService() async throws {
        var didFailWithError: Error?
        do {
            let sunEvents = try await DLWeather().suntimes(for: CLLocation(latitude: 44.47438, longitude: 73.21403))
            print("XC Test Weather kit", sunEvents)
            print("XC Test weather")
            XCTAssertNotNil(sunEvents.civilDawn)
        } catch {
            didFailWithError = error
            XCTAssertFalse(true)
            // Here you could do more assertions with the non-nil error object
        }
      
   
            
           
        
    }

    func testDriveLoggerStatisticsGenerationPerformance() throws {
        // This is an example of a performance test case.
        self.measure {
            DriveLoggerStatistics(drives: []).updateStatistics(drives: sampleDrives)
            // Put the code you want to measure the time of here.
        }
    }

}
