//
//  HomeView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/3/23.
//

import SwiftUI
import DriveLoggerUI
import DriveLoggerKit
import SwiftData
struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State var appState: AppState
    var body: some View {
        ScrollView {
            VStack {
                HomeHeaderSection(appState: appState)
                RecentDrivesSection(appState: appState)
                StatisticsSection(appState: appState)
              
            }.padding()
            
        }.toolbar {
            ToolbarItem(placement: .bottomBar) {
                VStack {
                   // Spacer()
                    Button(action: {
                      
                        appState.startDrive()
                    }) {
                        Text("Start Drive")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent).ignoresSafeArea().padding(.top).tint(Color("btnColor"))
                }
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(appState: AppState()).modelContainer(previewContainer)
        }.ignoresSafeArea()
    }
}


