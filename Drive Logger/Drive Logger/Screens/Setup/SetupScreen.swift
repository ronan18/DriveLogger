//
//  SetupScreen.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 7/16/23.
//

import SwiftUI

struct SetupScreen: View {
    @State var appState: AppState
    @State var goal: Double = 50
    var body: some View {
        GeometryReader {geo in
            VStack (alignment: .center) {
                Spacer().frame(height: geo.size.height * 0.025)
                HStack {
                    Spacer()
                    Image(.icon).resizable().scaledToFit().padding().frame(width: geo.size.width * 0.6)
                    Spacer()
                }.padding(.bottom)
                Text("Complete Your Driving Goal").font(.title).bold().padding(.bottom, 5)
           
                Text("Drive Logger makes it easy to keep track of your drives as you work to a goal.").font(.subheadline).padding(.horizontal)
                Spacer()
                HStack() {
                    
                        Text("I want to drive: ").font(.headline)
                    Spacer()
                    HStack (alignment: .firstTextBaseline) {
                        Spacer()
                        TextField("hours", value: $goal, formatter: NumberFormatter()).multilineTextAlignment(.trailing).keyboardType(.decimalPad).textFieldStyle(.roundedBorder)
                        
                        Text("hours").font(.caption)
                    }
                    
                }.padding(.horizontal)
                Text("set your driving goal").font(.subheadline).padding(.horizontal).foregroundColor(.gray)
                Spacer()
                Button(action: {
                    self.appState.goal = self.goal * 60 * 60
                    self.appState.updatePreferences()
                    self.appState.setUpFlow = false
                    
                }, label: {Text("Get Started").fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)}).buttonStyle(.borderedProminent)
                
            }.padding().multilineTextAlignment(.center)
        }
      
    }
}

#Preview {
    SetupScreen(appState: AppState())
}
