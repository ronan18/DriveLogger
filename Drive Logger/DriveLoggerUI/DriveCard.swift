//
//  DriveCard.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 6/3/23.
//

import SwiftUI
import DriveLoggerCore
import CoreData

public struct DriveCard: View {
    let drive: FetchedResults<Drive>.Element
    public init(_ drive: FetchedResults<Drive>.Element) {
        self.drive = drive
    }
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(spacing: 4) {
                    Text("East Side")
                    Image(systemName: "arrow.forward").font(.caption).bold()
                    Text("San Luis Obispo")
                }.font(.headline)
                HStack {
                    Text(Date(timeIntervalSinceNow: -500099).formatted(date: .abbreviated, time: .shortened))
                    HStack(spacing: 0) {
                        Image(systemName: "sun.max.circle.fill")
                        Image(systemName: "moon.stars.circle.fill")
                    }.symbolRenderingMode(.hierarchical)
                    
                }.font(.subheadline)
                
            }
            Spacer()
            VStack {
                Text("23").font(.headline)
                Text("minutes").font(.caption)
            }
        }.padding().background(Color.white).card()
        
    }
}

struct DriveCard_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let previewItem = Drive(context: viewContext)
        
      
            return DriveCard(previewItem).padding().previewLayout(.sizeThatFits)
        
    }
}
