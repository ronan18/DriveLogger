//
//  SettingsView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/8/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
   // @Query(sort: \.startTime, order: .reverse) private var drives: [Drive]
    var appState: AppState
    var body: some View {
        VStack {
            Text("settings")
        }.navigationTitle("Settings")
    }
}

#Preview {
    NavigationView {
        SettingsView(appState: AppState())
    }
}
