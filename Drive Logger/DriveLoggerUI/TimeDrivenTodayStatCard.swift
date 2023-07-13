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
    var statistics: DriveLoggerStatistics
    var drives: [Drive] = []
    public init(statistics: DriveLoggerStatistics, drives: [Drive], daysInGraph: Int = 7) {
        self.statistics = statistics
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
                Text(self.statistics.timeDrivenToday.formatedForDrive()).font(.title).bold()
                Text("driven today").font(.subheadline)
            }
            Spacer()
            VStack (alignment: .trailing) {
                Spacer()
                Chart(drives, id: \.id) {
                  
                        BarMark(x: .value("day", $0.startTime, unit: .day), y: .value("length", $0.driveLength)).foregroundStyle(Calendar.current.isDateInToday($0.startTime) ? Color.black : Color.gray)
                    
                }.chartXAxis(.hidden).chartYAxis(.hidden).frame(width: 100, height: 60)
               // Spacer()
            }
           
        }.frame(height: 80).padding().background(Color.cardBG).card()
    }
}
