//
//  DriveEditor.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 9/24/20.
//

import SwiftUI
import DriveLoggerServicePackage

public struct DriveEditor: View {
    let dlService = DriveLoggerService()
    let save: ((Drive) -> ())
    let delete: ((Drive) -> ())
    let cancel: (()->())
    var loadedDrive: Drive
    var title = "New Drive"
    var editMode = false
    @State var driveLoaded = false
    @State var drive: Drive = Drive(startTime: Date(timeIntervalSinceNow: (0 - (45*60))), endTime: Date(), location: "testingLoad")
    @State var nightHours: TimeInterval? = nil
    @State var dayHours: TimeInterval? = nil
    @State var dayHoursDisplay: TimeDisplay? = nil
    @State var nightHoursDisplay: TimeDisplay? = nil
    @State var totalTime: String? = nil
    public init(_ drive: Drive?, save: @escaping ((Drive) -> ()), cancel: @escaping (()->()), delete: @escaping ((Drive) -> ()) = {drive in}, editDrive: Bool = false) {
        self.save = save
        self.cancel = cancel
        self.loadedDrive = drive ?? Drive(startTime: Date(timeIntervalSinceNow: (0 - (45*60))), endTime: Date(), location: "")
     
        if (editDrive) {
            self.title = "Edit Drive"
            self.editMode = true
        }
        self.delete = delete
    }
    public var body: some View {
        
        VStack {
            
            HStack{
                ZStack {
                    VisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
                    VStack {
                        Spacer()
                        Border(.bottom)
                    }
                    
                    HStack {
                        Button( "cancel", action: cancel)
                        Spacer()
                        Text(title).font(.headline)
                        Spacer()
                        if (self.editMode) {
                            Button("delete", action: {delete(self.drive)})
                        } else {
                            Button("save", action: {save(self.drive)})
                        }
                    }.padding()
                }
            }.frame(height: 50)
            VStack {
                VStack(spacing: 0) {
                    HStack {
                        Text("Location").font(.headline)
                        Spacer()
                    }.padding(.bottom, 3)
                    TextField("Location", text: self.$drive.location).textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding(.vertical)
                
                
                DatePicker("Start Time", selection: self.$drive.startTime, in: ...Date()).padding(.vertical)
                DatePicker("End Time", selection: self.$drive.endTime, in: self.drive.startTime...Date()).padding(.vertical)
                HStack {
                    Text("Total Time")
                    Spacer()
                    Text(self.totalTime ?? "")
                    //   Image(systemName: self.dlService.isNightDrive(self.drive) ? "moon.stars" : "sun.max")
                    Image(systemName: "sun.max")
                    Text("\(self.dayHoursDisplay?.value ?? "") \(self.dayHoursDisplay?.unit ?? "")")
                    Image(systemName: "moon.stars")
                    Text("\(self.nightHoursDisplay?.value ?? "") \(self.nightHoursDisplay?.unit ?? "")")
                }
                Spacer()
                BlackButton("Save", action: {self.save(self.drive)}, stayBlack: true)
            }.padding()//.background(Color.white)
            if #available(iOS 15.0, *) {
                Text("Running new loading")
                Text("").task(priority: .background) {
                    guard (!self.driveLoaded) else {
                        return
                    }
                    let (day, night) = await self.dlService.driveTimeClassification(self.drive)
                    self.dayHours = day
                    self.nightHours = night
                    self.dayHoursDisplay = self.dlService.displayTimeInterval(day)
                    self.nightHoursDisplay = self.dlService.displayTimeInterval(night)
                    self.totalTime = "\(self.dlService.displayTimeInterval(self.drive.endTime.timeIntervalSince(self.drive.startTime)).value)\(self.dlService.displayTimeInterval(self.drive.endTime.timeIntervalSince(self.drive.startTime)).unit)"
                    self.driveLoaded = true
                    
                }
            } else {
                Text("Running old loading")
                Text("").onAppear{
                    guard (!self.driveLoaded) else {
                        return
                    }
                    let (day, night) = self.dlService.getDriveTimeClassification(self.drive)
                    self.dayHours = day
                    self.nightHours = night
                    self.dayHoursDisplay = self.dlService.displayTimeInterval(day)
                    self.nightHoursDisplay = self.dlService.displayTimeInterval(night)
                    self.totalTime = "\(self.dlService.displayTimeInterval(self.drive.endTime.timeIntervalSince(self.drive.startTime)).value)\(self.dlService.displayTimeInterval(self.drive.endTime.timeIntervalSince(self.drive.startTime)).unit)"
                    self.driveLoaded = true
                }
            }
        }.onAppear {
            
            if (!self.driveLoaded) {
                self.drive = self.loadedDrive
               
                
                
                
            }
            
        }
        
        
    }
}

struct DriveEditor_Previews: PreviewProvider {
    static var previews: some View {
        DriveEditor(nil, save: {drive in}, cancel: {})
    }
}
