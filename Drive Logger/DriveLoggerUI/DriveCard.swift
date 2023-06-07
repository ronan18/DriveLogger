//
//  DriveCard.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 6/3/23.
//
import Foundation
import SwiftUI
import DriveLoggerCore
import SwiftData

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
                        Text(drive.backupDriveString)
                    }
                    
                    
                }.font(.headline).lineLimit(1)
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
                Text(drive.driveLength.formatedForDrive()).font(.headline)
            }
        }.padding().background(Color.white).card()
        
    }
}

#Preview {
        DriveCard(Drive(sampleData: true)).padding().previewLayout(.sizeThatFits) .modelContainer(for: Drive.self, inMemory: true)
        
    
}
