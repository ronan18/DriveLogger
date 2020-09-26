//
//  DriveCard.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 9/24/20.
//

import SwiftUI
import DriveLoggerServicePackage

public struct DriveCard: View {
    var drive: Drive
    var length: TimeDisplay
    var dlService = DriveLoggerService()
    var action: ((Drive)->())
    public init(_ drive: Drive, action:  @escaping ((Drive)->()) = {drive in}) {
        self.drive = drive
        if (self.drive.location.count == 0) {
            self.drive.location = "No Location"
        }
        self.length = dlService.displayDateInterval(DateInterval(start: drive.startTime, end: drive.endTime))
     
            self.action = action
   
    }
    public var body: some View {
        Button(action: {action(self.drive)}) {
            HStack {
                VStack(alignment: .leading) {
                    Text(drive.location).font(.headline)
                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                        Text(self.dlService.displayDate(drive.startTime)).font(.caption)
                    //    Text(drive.startTime, style: .relative)
                    }
                }
                Spacer()
                VStack (alignment: .trailing) {
                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                        Text(length.value).font(.headline)
                        Text(length.unit).font(.subheadline)
                    }
                    
                 
                }
            }.foregroundColor(Color("Text")).padding().card()
        }
        
    }
}

struct DriveCard_Previews: PreviewProvider {
    static var previews: some View {
        DriveCard(Drive(startTime: Date(timeIntervalSinceNow: -1500), endTime: Date(), location: "San Francisco, CA")).previewLayout(.sizeThatFits).padding()
    }
}
