//
//  ProgressBar.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 6/3/23.
//

import SwiftUI

public struct ProgressBar: View {
    let height: Double = 20
     var percentComplete:Double
    public init(percentComplete: Double) {
        if (percentComplete > 1) {
            self.percentComplete = 1.01
        } else {
            self.percentComplete = percentComplete
        }
    }
    public var body: some View {
        GeometryReader { geo in
            
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: height, height: height)).frame(width: geo.size.width, height: height).foregroundColor( Color.lightBG)
                HStack {
                    if (percentComplete * geo.size.width > 17 ) {
                        RoundedRectangle(cornerSize: CGSize(width: height, height: height)).frame(width: percentComplete * geo.size.width, height: height).foregroundColor(Color("btnColor"))
                    }
                    Spacer()
                }
            
                    HStack() {
                        Spacer().frame(width:percentComplete > 1 ? geo.size.width - ((height + 10) / 2) : percentComplete * geo.size.width - ((height + 10) / 2))
                        ZStack {
                            Circle().frame(width: height+6, height: height+6).foregroundColor(.white).card()
                            Image(systemName: "car.circle.fill").resizable().scaledToFit().frame(height: height+6).symbolRenderingMode(.monochrome).foregroundColor(.black)
                        }
                        Spacer()
                    }
                
            }
        }.frame(height: height + 6)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            Spacer()
            ProgressBar(percentComplete: 0.04).padding()
            Spacer()
        }.frame(width: 500, height: 100).previewLayout(.sizeThatFits)
        
    }
}
