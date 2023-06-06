//
//  HomeHeaderView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/4/23.
//

import SwiftUI
import DriveLoggerUI

struct HomeHeaderSection: View {
    var body: some View {
        Group {
            
            HStack {
                Spacer()
                NavigationLink(destination: {}, label:{ Text("\(Image(systemName: "gearshape.fill"))").padding(.horizontal)
                    .font(.title)}).buttonStyle(.borderless).foregroundColor(.black)
            }
            Spacer().frame(height: 20)
            VStack() {
                Text("52").font(.system(size: 150)).fontWeight(.heavy).frame(height: 130)
                Text("hours").font(.title).bold().frame(height: 20)
                
                HStack {
                    Text("\(Image(systemName: "sun.max.circle.fill")) **40** hrs")
                    Text("\(Image(systemName: "moon.stars.circle.fill")) **10** hrs")
                }.symbolRenderingMode(.hierarchical).padding(.top)
                Spacer().frame(height: 50)
                ProgressBar(percentComplete: .constant(0.29))
                
            }
            
        }
    }
}

struct HomeHeaderSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                HomeHeaderSection()
                Spacer()
            }.padding()
        }.previewLayout(.sizeThatFits)
    }
}
