//
//  HomeHeaderView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/4/23.
//

import SwiftUI
import DriveLoggerUI
import DriveLoggerCore
import SwiftData


struct HomeHeaderSection: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \.startTime, order: .reverse) private var drives: [Drive]
    var appState: AppState
    var body: some View {
        Group {
            
            HStack {
                Spacer()
                NavigationLink(destination: SettingsView(appState: appState
                                                        ), label:{ Text("\(Image(systemName: "gearshape.fill"))").padding(.horizontal)
                    .font(.title)}).buttonStyle(.borderless).foregroundColor(.black)
            }
            Spacer().frame(height: 20)
            VStack() {
                GeometryReader {g in
                    HStack {
                        Spacer()
                        Text("\(self.appState.statistics.totalDriveTime.format(using: [.hour, .minute]) ?? "0m")").minimumScaleFactor(0.4).font(.system(size: g.size.height > g.size.width ? g.size.width * 0.4: g.size.height))
                            .lineLimit(1).fontWeight(.heavy)
                    Spacer()
                    }
                }.frame(height: 100)
               
                Text("time driven").font(.title).bold().frame(height: 20)
                
                HStack {
                    Text("\(Image(systemName: "sun.max.circle.fill")) \(self.appState.statistics.dayDriveTime.formatedForDrive())")
                    Text("\(Image(systemName: "moon.stars.circle.fill")) \(self.appState.statistics.nightDriveTime.formatedForDrive())")
                }.symbolRenderingMode(.hierarchical).padding(.top)
                Spacer().frame(height: 50)
                ProgressBar(percentComplete: (self.appState.statistics.totalDriveTime / (self.appState.goal)))
                
            }
            
        }
    }
}

struct HomeHeaderSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                HomeHeaderSection(appState: AppState())
                Spacer()
            }.padding()
        }.previewLayout(.sizeThatFits).modelContainer(previewContainer)
    }
}
