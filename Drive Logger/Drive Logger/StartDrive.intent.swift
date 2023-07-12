//
//  StartDrive.intent.swift
//  DriveLoggerKit
//
//  Created by Ronan Furuta on 7/9/23.
//

import Foundation
import AppIntents
struct StartDrive: AppIntent {
    static var title: LocalizedStringResource = "Start Drive"

    @MainActor
    func perform() async throws -> some IntentResult {
      //  Navigator.shared.openShelf(.currentlyReading)
        AppState.shared.startDrive()
        return .result()
    }
  
    static var openAppWhenRun: Bool = true
}
