//
//  Item.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/5/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
