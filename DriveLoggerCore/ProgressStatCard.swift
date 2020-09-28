//
//  ProgressStatCard.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 9/27/20.
//

import SwiftUI

public struct ProgressStatCard: View {
    var width: CGFloat
    var value: Double
    var unit: String
    var description: String

    public init(width: CGFloat? = nil, value: Double, unit: String, description: String) {
        if let width = width {
            self.width = (width / 2) - 30
        } else {
            self.width =  150
        }
    
        self.value = value
        self.unit = unit
        self.description = description
    }
    public var body: some View {
        ZStack {
            ProgressStat(value: self.value, unit: self.unit, description: self.description)
        }.multilineTextAlignment(.center).padding(5).frame(width: width, height: width).card()
    }
}

struct ProgressStatCard_Previews: PreviewProvider {
    static var previews: some View {
        ProgressStatCard(width: 500, value: 4, unit: "%", description: "complete").previewLayout(.sizeThatFits).padding()
    }
}
