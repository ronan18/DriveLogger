//
//  PercentComplete.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 6/9/23.
//

import SwiftUI

public struct PercentageStat: View {
    var percentComplete: Double
    var lable: LocalizedStringResource
    public init(percentComplete: Double, lable: LocalizedStringResource) {
        if percentComplete.isNaN || percentComplete.isInfinite {
            self.percentComplete = 1
        } else {
            self.percentComplete = percentComplete
        }
        self.lable = lable
    }
   public var body: some View {
        VStack {
            Gauge(value: percentComplete, label: {
              
            },  currentValueLabel: {
                HStack(alignment: .firstTextBaseline,spacing: 0) {
                    Text("\(Int(percentComplete * 100))")
                    Text("%").font(.caption2)
                }
            }
            ).gaugeStyle(.accessoryCircular)
           /* HStack(alignment: .firstTextBaseline,spacing: 0) {
                Text("\(Int(percentComplete * 100))").font(.largeTitle).bold()
                Text("%")
            }
            Text("complete")*/
            Text(lable).multilineTextAlignment(.center).font(.caption)
        }.padding()
    }
}

#Preview {
    PercentageStat(percentComplete: 0.25, lable: "Percent Complete").previewLayout(.sizeThatFits)
}
