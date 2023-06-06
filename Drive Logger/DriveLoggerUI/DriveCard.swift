//
//  DriveCard.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 6/3/23.
//

import SwiftUI
import DriveLoggerCore
import CoreData

public struct DriveCard: View {
    let drive: Drive
    public init(_ drive: Drive) {
        self.drive = drive
    }
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
               
                HStack(spacing: 4) {
                    if (drive.startLocationName != nil) {
                        Text(drive.startLocationName ?? "")
                    }
                    if (drive.startLocationName != nil && drive.endLocationName != nil) {
                        Image(systemName: "arrow.forward").font(.caption).bold()
                        
                    }
                    if (drive.endLocationName != nil) {
                        Text(drive.endLocationName ?? "")
                    }
                    
                    if (drive.endLocationName == nil && drive.startLocationName == nil) {
                        Text(drive.backupDriveString())
                    }
                    
                    
                }.font(.headline)
                HStack {
                    if (!(drive.endLocationName == nil && drive.startLocationName == nil)) {
                        Text(drive.startTime.formatted(date: .abbreviated, time: .shortened))
                    }
                  
                    HStack(spacing: 0) {
                        Image(systemName: "sun.max.circle.fill")
                        Image(systemName: "moon.stars.circle.fill")
                    }.symbolRenderingMode(.hierarchical)
                    
                }.font(.subheadline)
                
            }
            Spacer()
            VStack {
                Text("23").font(.headline)
                Text("minutes").font(.caption)
            }
        }.padding().background(Color.white).card()
        
    }
}

struct DriveCard_Previews: PreviewProvider {
    
    static var previews: some View {
        DriveCard(Drive(sampleData: true)).padding().previewLayout(.sizeThatFits)
        
    }
}
