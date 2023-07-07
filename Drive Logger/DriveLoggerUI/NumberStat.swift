//
//  TimeLeftView.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 6/10/23.
//

import SwiftUI
import DriveLoggerCore

public struct NumberStat: View {
    var value: String
    var label: String
    public init(time: TimeInterval, label: String) {
        self.value = time.formatedForDrive()
        self.label = label
    }
    public init (value: String, label: String) {
        self.value = value
        self.label = label
        
    }
    public var body: some View {
        VStack(alignment: .center) {
            Spacer()
            GeometryReader {g in
                HStack {
                    Spacer()
                    Text(value).font(.largeTitle).minimumScaleFactor(0.4).font(.system(size: 200))
                        .lineLimit(1).bold()
                    Spacer()
                }
            }.frame(height: 25)
            
           
            Text(label).font(.caption).multilineTextAlignment(.center)
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.cardBG).card()
    }
}

#Preview {
    Grid(horizontalSpacing: 15,
         verticalSpacing: 15) {
        GridRow {
            NumberStat(time: 100, label: "left").previewLayout(.sizeThatFits)
            NumberStat(time: 900, label: "left").previewLayout(.sizeThatFits)
            NumberStat(time: 50000, label: "left").previewLayout(.sizeThatFits)
        }.frame(height: 150)
    }.padding()
    
}
