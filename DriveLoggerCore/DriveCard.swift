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
    var nightDrive = false
    public init(_ drive: Drive, action:  @escaping ((Drive)->()) = {drive in}) {
        self.drive = drive
        if (self.drive.location.count == 0) {
            self.drive.location = "No Location"
        }
        self.length = dlService.displayTimeInterval(drive.endTime.timeIntervalSince(drive.startTime))
     
            self.action = action
        self.nightDrive = self.dlService.isNightDrive(drive)
   
    }
    public var body: some View {
        Button(action: {action(self.drive)}) {
            HStack {
                VStack(alignment: .leading) {
                    Text(drive.location).font(.headline).lineLimit(1)
                    HStack(alignment: .lastTextBaseline) {
                        Text(self.dlService.displayDate(drive.startTime)).font(.caption)
                        if (self.nightDrive) {
                            Image(systemName: "moon.stars").font(.caption)
                        } else {
                            Image(systemName: "sun.max").font(.caption)
                        }
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
