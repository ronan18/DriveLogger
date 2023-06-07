//
//  DriveEditorView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/6/23.
//

import SwiftUI
import DriveLoggerCore
import DriveLoggerUI
import SwiftData

struct DriveEditorView: View {
    @Binding var drive: Drive
    var body: some View {
        NavigationView {
            VStack {
                Text(drive.backupDriveString)
            }
        }
    }
}

struct DriveEditor_Previews: PreviewProvider {
    static var previews: some View {
        DriveEditorView(drive: .constant(Drive(sampleData: true)))
    }
}
