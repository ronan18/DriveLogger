//
//  TimeDisplayView.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 7/16/23.
//

import SwiftUI

public struct TimeDisplayView: View {
    public var time: TimeInterval
    public var mainFont: Font
    public var lableFont: Font
    public var hours: Int
    public var minutes: Int
    public var weight: Font.Weight
    public var lableWeight: Font.Weight
    public init(time: TimeInterval, mainFont: Font = .body, labelFont: Font = .subheadline, weight: Font.Weight = .bold, lableWeight: Font.Weight = .bold) {
        self.time = time
        self.mainFont = mainFont
        self.lableFont = labelFont
        self.weight = weight
        
        let startValue = (time / (60*60))
        self.hours = Int(startValue.rounded(.down))
        self.minutes = Int((modf(startValue).1) * 60)
        if (weight == .regular) {
            self.lableWeight = .regular
        } else {
            self.lableWeight = lableWeight
        }
        
    }
    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing:0) {
            if (self.hours > 0) {
                Text(String(hours)).font(mainFont).fontWeight(weight).contentTransition(.numericText())
                Text("h").font(lableFont).fontWeight(lableWeight)
                Text(" ").font(mainFont).fontWeight(weight)
            }
            Text(String(minutes)).font(mainFont).fontWeight(weight).contentTransition(.numericText())
            Text("m").font(lableFont).fontWeight(lableWeight)
        }
      
    }
}

#Preview {
    TimeDisplayView(time: 300000)
}
