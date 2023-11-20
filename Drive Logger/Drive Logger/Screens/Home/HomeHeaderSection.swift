//
//  HomeHeaderView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/4/23.
//

import SwiftUI
import DriveLoggerUI
import DriveLoggerKit
import SwiftData


struct HomeHeaderSection: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DLDrive.startTime, order: .reverse) private var drives: [DLDrive]
    
    @State var isShowingNavView: Bool = false
    
    var appState: AppState
    var body: some View {
        Group {
            
            
            HStack {
              
               
                Spacer()
                if (self.appState.statistics.updating) {
                    ProgressView().progressViewStyle(.circular)
                }
                NavigationLink(destination: SettingsView(appState: appState
                                                        ), isActive: $isShowingNavView, label:{ Text("\(Image(systemName: "gearshape.fill"))").padding(.horizontal)
                    .font(.title)}).buttonStyle(.borderless).foregroundColor(.black)
            }
            Spacer().frame(height: 20)
            VStack() {
                
                GeometryReader {g in
                    HStack {
                        Spacer()
                        TimeDisplayView(time: self.appState.statistics.totalDriveTime, mainFont: .system(size: (g.size.height > g.size.width ? g.size.width * 0.4: g.size.height) * 0.8), labelFont: .system(size: (g.size.height > g.size.width ? g.size.width * 0.4: g.size.height) * 0.6), weight: .heavy, lableWeight: .bold)
                        /*Text("\(self.appState.statistics.totalDriveTime.format(using: [.hour, .minute]) ?? "0m")").minimumScaleFactor(0.4).font(.system(size: g.size.height > g.size.width ? g.size.width * 0.4: g.size.height))
                            .lineLimit(1).fontWeight(.heavy)*/
                    Spacer()
                    }
                }.frame(height: 100)
               
                Text("time driven").font(.title).bold().frame(height: 20)
                
                HStack(spacing: 9) {
                    HStack(spacing: 3) {
                        Text("\(Image(systemName: "sun.max.circle.fill"))")
                        TimeDisplayView(time: self.appState.statistics.dayDriveTime, weight: .regular)
                    }
                    HStack(spacing: 3) {
                        Text("\(Image(systemName: "moon.stars.circle.fill"))")
                        TimeDisplayView(time: self.appState.statistics.nightDriveTime, weight: .regular)
                    }
                   
                }.symbolRenderingMode(.hierarchical).padding(.top)
                Spacer().frame(height: 50)
                ProgressBar(percentComplete: (self.appState.statistics.totalDriveTime / (self.appState.goal)))
                
            }
            
        }.onChange(of: self.isShowingNavView, {_, new in
            guard !new else {
                return
            }
            self.appState.updatePreferences()
        })
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
