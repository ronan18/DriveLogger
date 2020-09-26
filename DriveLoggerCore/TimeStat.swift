//
//  TimeStat.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 9/24/20.
//

import SwiftUI

public struct TimeStat: View {
    let value: String
    let unit: String
    let description: String
    var date: Date? = nil
    public init( value: String, unit: String, description: String, date: Date? = nil) {
        self.value = value
        self.unit = unit
        self.description = description
        self.date = date
    }
    public var body: some View {
        VStack {
            if (self.date != nil) {
                Text(self.date ?? Date(), style: .timer).font(.system(size: 60)).fontWeight(.bold)
            } else {
            HStack(alignment:.lastTextBaseline,spacing: 0) {
                Text(value).font(.system(size: 60)).fontWeight(.bold)
                Text(unit).font(.largeTitle)
            }
            }
            HStack(alignment:.lastTextBaseline,spacing: 0) {
                Text(description).font(.subheadline)
               
            }
        }

    }
}

struct TimeStat_Previews: PreviewProvider {
    static var previews: some View {
        TimeStat(value: "12", unit: "hr", description: "7hr day  5hr night").previewLayout(PreviewLayout.sizeThatFits)
            .padding()
   
    }
}
