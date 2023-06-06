//
//  ContetView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/3/23.
//

import SwiftUI
import DriveLoggerCore
struct ContentView: View {
    var body: some View {
        NavigationView {
           HomeView()
        }
    }
}

struct ContetView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
