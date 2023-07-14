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

public struct TimeDrivenTodayStatCard: View {
    var drivenToday: String
    var drives: [Drive] = []
    var widgetMode: Bool
    public init(drivenToday: String, drives: [Drive], daysInGraph: Int = 7, widgetMode: Bool = false) {
        self.drivenToday = drivenToday
        self.widgetMode = widgetMode
        drives.forEach {drive in
            
            guard Calendar.current.dateComponents([.day], from: drive.startTime, to: Date()).day ?? 0 < daysInGraph else {
                return
            }
            self.drives.append(drive)
    
        }
      
       
    }
    public var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Spacer()
                Text(drivenToday).font(.title).bold()
                Text("driven today").font(.subheadline)
            }
            Spacer()
            VStack (alignment: .trailing) {
                Spacer()
               
                Chart(drives, id: \.id) {
                  
                        BarMark(x: .value("day", $0.startTime, unit: .day), y: .value("length", $0.driveLength)).foregroundStyle(Calendar.current.isDateInToday($0.startTime) ? Color.black : Color.gray)
                    
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
