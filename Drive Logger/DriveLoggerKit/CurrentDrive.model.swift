//
//  CurrentDrive.model.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/8/23.
//

import Foundation
import CoreLocation


public struct CurrentDrive: Codable, Equatable, Hashable {
    public var start: Date
    public var startLocation: DLLocationPointStore?
    public init(start: Date,startLocation: DLLocationPointStore?) {
        self.start = start
        self.startLocation = startLocation
    }
}
