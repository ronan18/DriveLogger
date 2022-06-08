//
//  ChartCard.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/8/22.
//

import SwiftUI
import DriveLoggerServicePackage


public struct ChartCard: View {
    var data: DriveLoggerAppState
   
    public init(data: DriveLoggerAppState) {
        self.data = data
       
    }
    public var body: some View {
        ChartView(data: data).padding().card()
    }
}
/*
struct ChartCard_Previews: PreviewProvider {
    static var previews: some View {
       /* ChartCard(data: [Drive(startTime: Date(timeIntervalSinceNow: -500), endTime: Date(timeIntervalSinceNow: 5200), location: "Here"),Drive(startTime: Date(timeIntervalSinceNow: -5000), endTime: Date(timeIntervalSinceNow: 100), location: "Here"),Drive(startTime: Date(timeIntervalSinceNow: -103030303), endTime: Date(timeIntervalSinceNow: -14000), location: "Here")]).padding()*/
    }
}*/
