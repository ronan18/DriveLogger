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
    public init(_ drive: Drive?, save: @escaping ((Drive) -> ()), cancel: @escaping (()->()), delete: @escaping ((Drive) -> ()) = {drive in}, editDrive: Bool = false) {
        self.save = save
        self.cancel = cancel
        self.loadedDrive = drive ?? Drive(startTime: Date(timeIntervalSinceNow: (0 - (45*60))), endTime: Date(), location: "")
        if let drive = drive {
            print("drive editor init with drive", drive.location)
            self.loadedDrive = drive
        } else {
            print("drive editor init without drive")
            self.loadedDrive = Drive(startTime: Date(timeIntervalSinceNow: (0 - (45*60))), endTime: Date(), location: "")
        }
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
                        Text("\(self.dlService.displayTimeInterval(self.drive.endTime.timeIntervalSince(self.drive.startTime)).value)\(self.dlService.displayTimeInterval(self.drive.endTime.timeIntervalSince(self.drive.startTime)).unit)")
                        Image(systemName: self.dlService.isNightDrive(self.drive) ? "moon.stars" : "sun.max")
                        
                    }
                    Spacer()
                    BlackButton("Save", action: {self.save(self.drive)})
                }.padding().background(Color.white)
            }.onAppear {
               
                if (!self.driveLoaded) {
                    self.drive = self.loadedDrive
                    self.driveLoaded = true
                }
               
            }.environment(\.colorScheme, .light).preferredColorScheme(.light)
        
        
    }
}

struct DriveEditor_Previews: PreviewProvider {
    static var previews: some View {
        DriveEditor(nil, save: {drive in}, cancel: {})
    }
}
