//
//  EndDrive.intent.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 7/9/23.
//

import Foundation
import AppIntents
struct EndDrive: AppIntent {
    static var title: LocalizedStringResource = "End Drive"

    @MainActor
    func perform() async throws -> some IntentResult {
      //  Navigator.shared.openShelf(.currentlyReading)
        Task {
            await AppState.shared.stopDrive()
           
        }
        return .result()
    }
  
    static var openAppWhenRun: Bool = true
}
