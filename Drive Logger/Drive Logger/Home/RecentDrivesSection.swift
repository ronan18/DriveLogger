//
//  RecentDrivesSection.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/4/23.
//

import SwiftUI
import DriveLoggerUI
import DriveLoggerCore
import CoreData
struct RecentDrivesSection: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Drive.startTime, ascending: true)],
        animation: .default)
    private var drives: FetchedResults<Drive>
    var body: some View {
        VStack {
            HStack {
                Text("Recent Drives").font(.headline)
                Spacer()
                NavigationLink(destination: {}, label: {Text("View More \(Image(systemName: "chevron.right"))")})
            }
            if (drives.count > 0 ) {
                VStack {
                    ForEach (drives.prefix(3)) {drive in
                        DriveCard(drive).padding(.vertical, 2)
                        
                    }
                    
                    
                    
                }
            } else {
                VStack {
                    Spacer()
                    Text("No logged drives yet").font(.headline)
                    HStack {
                        Spacer()
                        Text("Hit the button below to start your first drive!").font(.subheadline)
                        Spacer()
                    }
                    Spacer()
                }.background(Color("LightGray")).cornerRadius(6).frame(height: 250).padding(.vertical, 2)
            }
           
        }.padding(.vertical)
    }
}

struct RecentDrivesSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
        RecentDrivesSection().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        Spacer()
    }.padding()
}.previewLayout(.sizeThatFits).previewDisplayName("With Drives")
        NavigationView {
            VStack {
        RecentDrivesSection()
        Spacer()
    }.padding()
}.previewLayout(.sizeThatFits).previewDisplayName("No Drives")
    }
}
