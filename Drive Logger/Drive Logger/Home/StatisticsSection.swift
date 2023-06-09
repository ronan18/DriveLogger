//
//  StatisticsSection.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/4/23.
//

import SwiftUI
import DriveLoggerUI
import DriveLoggerCore
import SwiftData
struct StatisticsSection: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        VStack {
            HStack {
                Text("Statistics").font(.headline)
                Spacer()
                NavigationLink(destination: {}, label: {Text("View More \(Image(systemName: "chevron.right"))")})
            }
            VStack {
                Spacer().frame(height: 100)
                Gauge(value: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/, label: {
                    Text("Label")
                }
                )
                
            }
           
        }.padding(.vertical)
    }
}

struct StatisticsSection_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsSection().modelContainer(previewContainer)
    }
}
