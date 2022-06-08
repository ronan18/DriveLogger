//
//  GraphsNeediOS16.swift
//  
//
//  Created by Ronan Furuta on 6/8/22.
//

import SwiftUI

struct GraphsNeediOS16: View {
    var smallScreen = false
    var body: some View {
        if (smallScreen) {
            Text("Update to **iOS 16** to view Graphs").multilineTextAlignment(.center)
        } else {
            VStack {
                
                if #available(iOS 15.0, *) {
                    InternalContent().background(.thinMaterial).cornerRadius(5)
                } else {
                    InternalContent().background(Color.gray).cornerRadius(5)
                }
            }
        }
    }
}

struct GraphsNeediOS16_Previews: PreviewProvider {
    static var previews: some View {
        GraphsNeediOS16().frame(height: 250).padding()
    }
}

private struct InternalContent: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill").renderingMode(.original)
            Text("Graphs require iOS 16").font(.headline).padding(.vertical, 2)
            HStack {
                
                Spacer()
                
                Text("Drive Logger uses features introduced in iOS 16 to render graphs. Please **update iOS to use all Drive Logger features.** For more information please view **[Apple Support](https://stomprocket.link/hljFab)**").multilineTextAlignment(.center).font(.subheadline)
                Spacer()
            }
            Spacer()
        }
    }
}
