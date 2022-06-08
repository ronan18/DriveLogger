//
//  ChartView.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/8/22.
//

import SwiftUI
import DriveLoggerServicePackage

#if canImport(Charts)
import Charts
#endif
public enum ChartMode {
    case standard
    case minimal
}
public struct ChartView: View {
    var data: [DriveLengthDay]
    
    var average = true
    var axis = true
    var averageLength: TimeInterval
    var label: String
    public init(data: DriveLoggerAppState, average: Bool = true, axis: Bool = true, label: String? = nil) {
        self.data = data.driveLengthByDay
        self.averageLength = data.averageDriveDuration
        self.label = label ?? "duration of previous drives"
        self.average = average
        self.axis = axis
    }
    
    public var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                
                
                HStack {
                    VStack(alignment:.leading) {
                        Text(label).font(.headline)
                        if (axis) {
                            Text("time in minutes").font(.caption).foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                }
                Chart {
                    ForEach(data) { data in
                        BarMark(
                            x: .value("Date", data.date, unit: .day),
                            y: .value("Duration", data.length / 60)
                        ).foregroundStyle(Color("BlackColor")).interpolationMethod(.catmullRom)//.symbol(by: .value("Length", data.length))
                        if (self.average) {
                            RuleMark(y: .value("Average drive length", self.averageLength / 60)).foregroundStyle(.blue).annotation(position: .top, alignment: .trailing) {
                                VStack {
                                    Text("Average \(Int(self.averageLength / 60))m").font(.caption2).foregroundColor(.blue)//.shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.025), radius: 2, x: 0.0, y: 3)
                                }.padding(2).background(.ultraThinMaterial).cornerRadius(5)
                            }
                        }
                    }
                    
                    
                }.chartLegend(self.axis ? .visible : .hidden).chartYAxis(self.axis ? .visible : .hidden).chartXAxis(self.axis ? .visible : .hidden)
            } else {
                HStack {
                    
                    VStack(alignment:.leading) {
                        Text(label + " graph").font(.headline)
                        if (axis) {
                            Text("Graphical representation of the length of previous drive").font(.caption).foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
                GraphsNeediOS16(smallScreen: axis ? false : true).padding(.top)
            }
            
            
            
            
            
            
            
        }
    }
}
