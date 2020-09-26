//
//  StatCard.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 9/24/20.
//

import SwiftUI

public struct StatCard: View {
    var width: CGFloat
    var value: String
    var unit: String
    var description: String
    public init(width: CGFloat? = nil, value: String, unit: String, description: String) {
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
        VStack {
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text(self.value).font(.largeTitle).fontWeight(.bold)
                Text(self.unit).font(.headline)
            }
            Text(self.description).font(.caption)
        }.multilineTextAlignment(.center).padding(5).frame(width: width, height: width).card()
    }
}

struct StatCard_Previews: PreviewProvider {
    static var previews: some View {
        StatCard(width: nil, value: "40", unit: "%", description: "average drive duration").previewLayout(.sizeThatFits).padding()
    }
}
