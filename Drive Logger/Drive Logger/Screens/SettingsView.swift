//
//  SettingsView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/8/23.
//

import SwiftUI
import Combine
struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
   // @Query(sort: \.startTime, order: .reverse) private var drives: [Drive]
    @State var appState: AppState
    @State var goal: Double = 50
    @State var defaultSunrise: Date = Date()
    @State var defaultSunset: Date = Date()
    var body: some View {
        Form {
            Section {
                HStack() {
                    
                        Text("Driving goal: ").font(.headline).frame(width: 100)
                    Spacer()
                    HStack (alignment: .firstTextBaseline) {
                        Spacer()
                        TextField("hours", value: $goal, formatter: NumberFormatter()).frame(width: 25).multilineTextAlignment(.trailing).keyboardType(.decimalPad)
                        
                        Text("hours").font(.caption)
                    }
                   Stepper(value: $goal, in: 1...10000) {
                        EmptyView()
                    }
                }
            }
            Section {
                DatePicker("\(Image(systemName: "sunrise.fill")) Default Sunrise", selection: self.$defaultSunrise, displayedComponents: [ .hourAndMinute])
                DatePicker("\(Image(systemName: "sunset.fill")) Default Sunset", selection: self.$defaultSunset, displayedComponents: [ .hourAndMinute])
                //TODO: Limit date sunset to after sunrise
              /*  HStack {
                    Text("\(Image(systemName: "sun.max.circle.fill")) \(self.drive.dayDriveTime.formatedForDrive())")
                    Text("\(Image(systemName: "moon.stars.circle.fill")) \(self.drive.nightDriveTime.formatedForDrive())")
                }*/
            } header: {
                Text("\(Image(systemName: "sun.max")) Sunrise Defaults")
            } footer: {
                Text("If weather and location data are unavailable, Drive Logger will default to these times.")
            }
            
        }.navigationTitle("Settings").onChange(of: self.goal, {old, new in
            self.appState.goal = new * 60 * 60
        }).onAppear {
            self.goal = self.appState.goal / 60 / 60
            self.defaultSunset = self.appState.defaultSunset.date()
            self.defaultSunrise = self.appState.defaultSunrise.date()
        }.onChange(of: self.defaultSunrise, {_, new in
            do {
                self.appState.defaultSunrise = try .init(from: self.defaultSunrise)
            } catch {
                print("error", error)
            }
            
        }).onChange(of: self.defaultSunset, {_, new in
            do {
                self.appState.defaultSunset = try .init(from: self.defaultSunrise)
            } catch {
                print("error", error)
            }
            
        })
       
    }
}

#Preview {
    NavigationView {
        SettingsView(appState: AppState())
    }
}
