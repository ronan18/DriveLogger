//
//  HomeView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/3/23.
//

import SwiftUI
import DriveLoggerUI

struct HomeView: View {
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
                        // Handle button tap
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
            HomeView()
        }.ignoresSafeArea()
    }
}


