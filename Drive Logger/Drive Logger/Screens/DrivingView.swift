//
//  DrivingView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/4/23.
//

import SwiftUI
import DriveLoggerUI
import DriveLoggerKit
import SwiftData
import MapKit

struct DrivingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var drives: [DLDrive]
    @State var mapRect: MKMapRect = .world
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
     var placeHolderLocation = CLLocationCoordinate2D(latitude: 37.786487, longitude: -122.405303)
    var appState: AppState
    var body: some View {
        GeometryReader {geo in
     
                VStack {
                    Map(position: $position, interactionModes: []){
                       // MapPolyline(self.appState.tripPolyLine).stroke(.blue, lineWidth: 14)
                        Marker("start", monogram: Text("start"),coordinate: self.appState.currentDrive?.startLocation?.coordinate ?? placeHolderLocation)
                        UserAnnotation(anchor: .center).tint(.blue).annotationTitles(.hidden)
                      //  UserLocation()
                    }.mapStyle(.standard(elevation: .realistic, emphasis: .muted, pointsOfInterest: .excludingAll, showsTraffic: true)).frame(height: geo.size.height * 0.3)
                    Spacer()
                    VStack {
                        Text(self.appState.currentDrive?.start ?? Date(timeIntervalSince1970: 0), style: .timer).font(.system(size: 85)).fontWeight(.heavy).contentTransition(.numericText())
                        if (self.appState.lastLocation != nil) {
                            Text("\(Image(systemName: "location.fill")) \(self.appState.lastLocation?.placeName ?? "error")").font(.subheadline).foregroundColor(.gray)
                        } else {
                            Text("\(Image(systemName: "location.slash.fill")) location unavailable").font(.subheadline).foregroundColor(.gray)
                        }
                        
                        Spacer()
                        Grid(horizontalSpacing: 15,
                             verticalSpacing: 15) {
                            GridRow {
                                NumberStat(value: .init(stringLiteral: "\(Int(self.appState.lastLocationData?.speed.mph ?? 0))"), label: "mph")
                            }.frame(height: 130)
                            GridRow {
                                NumberStat(time: (self.appState.statistics.totalDriveTime), label: "driven")
                                NumberStat(time: (self.appState.statistics.dayDriveTime), label: "daytime")
                                NumberStat(time: (self.appState.statistics.nightDriveTime), label: "nighttime")
                            }.frame(height: 130)
                        }
                        Spacer()
                        ProgressBar(percentComplete: ((self.appState.statistics.totalDriveTime +  (0 - (self.appState.currentDrive?.start ?? Date(timeIntervalSince1970: 0)).timeIntervalSinceNow)) / (self.appState.goal)))
                        Button(action: {
                            // Handle button tap
                            Task {
                                await appState.stopDrive()
                            }
                        }) {
                            Text("End Drive")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                        .buttonStyle(.borderedProminent)
                    }.padding().background(Color.white)
                }.edgesIgnoringSafeArea(.top)
                
                 
                    
                }
                
            
        
        
     
    }
}

struct DrivingView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingView(appState: AppState()).modelContainer(for: [DLDrive.self])
    }
}
