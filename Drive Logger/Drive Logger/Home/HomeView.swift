//
//  HomeView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/3/23.
//

import SwiftUI
import DriveLoggerUI
import DriveLoggerCore
import SwiftData
struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var appState: [AppState]
    var body: some View {
        ScrollView {
            VStack {
                HomeHeaderSection()
                RecentDrivesSection()
                StatisticsSection()
              
            }.padding()
            
        }.toolbar {
            ToolbarItem(placement: .bottomBar) {
                VStack {
                   // Spacer()
                    Button(action: {
                        guard let appState = self.appState.first else {
                            print("no appstate exists starting drive")
                            return
                        }
                        appState.startDrive()
                    }) {
                        Text("Start Drive")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent).ignoresSafeArea().padding(.top)
                }
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView().modelContainer(previewContainer)
        }.ignoresSafeArea()
    }
}


