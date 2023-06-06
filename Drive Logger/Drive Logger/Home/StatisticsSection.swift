//
//  StatisticsSection.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/4/23.
//

import SwiftUI
import DriveLoggerUI
struct StatisticsSection: View {
    var body: some View {
        VStack {
            HStack {
                Text("Statistics").font(.headline)
                Spacer()
                NavigationLink(destination: {}, label: {Text("View More \(Image(systemName: "chevron.right"))")})
            }
            VStack {
                DriveCard().padding(.vertical, 2)
                DriveCard().padding(.vertical, 2)
                DriveCard().padding(.vertical, 2)
              
                
            }
           
        }.padding(.vertical)
    }
}

struct StatisticsSection_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsSection()
    }
}
