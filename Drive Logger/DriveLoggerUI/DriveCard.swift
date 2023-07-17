//
//  DriveCard.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 6/3/23.
//
import Foundation
import SwiftUI
import DriveLoggerKit
import SwiftData

public struct DriveCard: View {
    let drive: DLDrive
    let noShadow: Bool
    public init(_ drive: DLDrive, noShadow: Bool = false) {
        self.drive = drive
        self.noShadow = noShadow
    }
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
               
                HStack(spacing: 4) {
                    if (!drive.startLocationName.isEmpty) {
                        Text(drive.startLocationName)
                    }
                    if (!drive.startLocationName.isEmpty && !drive.endLocationName.isEmpty) {
                        Image(systemName: "arrow.forward").font(.caption).bold()
                        
                    }
                    if (!drive.endLocationName.isEmpty) {
                        Text(drive.endLocationName)
                    }
                    
                    if (drive.endLocationName.isEmpty && drive.startLocationName.isEmpty) {
                        Text(drive.backupDriveString)
                    }
                    
                    
                }.font(.headline).lineLimit(1)
                HStack {
                    if (!(drive.endLocationName.isEmpty && drive.startLocationName.isEmpty)) {
                        Text(drive.startTime.formatted(date: .abbreviated, time: .shortened))
                    }
                  
                    HStack(spacing: 0) {
                        if (self.drive.dayDriveTime > 0) {
                            Image(systemName: "sun.max.circle.fill")
                        }
                        if (self.drive.nightDriveTime > 0) {
                            Image(systemName: "moon.stars.circle.fill")
                        }
                    }.symbolRenderingMode(.hierarchical)
                    
                }.font(.subheadline)
                
            }
            Spacer()
            VStack {
                TimeDisplayView(time: self.drive.driveLength, mainFont: .headline)
            }
        }.ifCondition(!self.noShadow, then: {view in
            view.padding().background(Color.cardBG).card()
        })
        
    }
}

#Preview {
        DriveCard(DLDrive(sampleData: true)).padding().previewLayout(.sizeThatFits) .modelContainer(for: DLDrive.self, inMemory: true)
        
    
}

extension View {
    @ViewBuilder
    func ifCondition<TrueContent: View>(_ condition: Bool, then trueContent: (Self) -> TrueContent) -> some View {
        if condition {
            trueContent(self)
        } else {
            self
        }
    }
}
