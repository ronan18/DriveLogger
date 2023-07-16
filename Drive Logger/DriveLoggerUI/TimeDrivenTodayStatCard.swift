//
//  TimeDrivenTodayStatCard.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 7/13/23.
//

import Foundation
import SwiftUI
import Charts
import DriveLoggerKit
public var iconWidth: CGFloat = 20
public struct TimeDrivenTodayStatCard: View {
    var drivenToday: TimeInterval
   
   var drives: [Drive] = []
    var widgetMode: Bool
    var label: LocalizedStringResource
    var daysInGraph: Int
    public init(drivenToday: TimeInterval, drives: [Drive], daysInGraph: Int = 7, widgetMode: Bool = false) {
        self.drivenToday = drivenToday
        self.widgetMode = widgetMode
        self.label = LocalizedStringResource(stringLiteral: "driven today")
        self.daysInGraph = daysInGraph
        self.drives = drives
      
       
    }
    public init(drivenTotal: TimeInterval, drives: [Drive], daysInGraph: Int = 7, widgetMode: Bool = false) {
        self.drivenToday = drivenTotal
        self.widgetMode = widgetMode
        self.label = LocalizedStringResource(stringLiteral: "driven")
        self.daysInGraph = daysInGraph
        self.drives = drives
       
    }
    public var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                if (self.widgetMode) {
                    Image("Icon").resizable().frame(width: iconWidth, height: iconWidth)
                }
                Spacer()
                TimeDisplayView(time: drivenToday, mainFont: .title, labelFont: .title2)
                Text(label).font(.subheadline)
            }
            Spacer()
            VStack (alignment: .trailing) {
                Spacer()
               
                Chart() {
                    ForEach(drives.filter({drive in
                        return Calendar.current.dateComponents([.day], from: drive.startTime, to: Date()).day ?? 0 < self.daysInGraph
                    })) {drive in
                        BarMark(x: .value("day", drive.startTime, unit: .day), y: .value("length", drive.driveLength)).foregroundStyle(Calendar.current.isDateInToday(drive.startTime) ? Color.black : Color.gray)
                    }
                  
                        
                    
                }.chartXAxis(.hidden).chartYAxis(.hidden).frame(width: widgetMode ? 120 : 100, height: widgetMode ? 80 : 60)
               
               // Spacer()
            }
           
        }.ifCondition(!self.widgetMode, then: {view in
            view.frame(height: 80).padding().background(Color.cardBG).card()
        }).ifCondition(widgetMode, then: {view in
            view.padding(10)
        })
        
        
    }
 
}
