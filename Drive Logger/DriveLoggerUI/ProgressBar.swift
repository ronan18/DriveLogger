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
                RoundedRectangle(cornerSize: CGSize(width: height, height: height)).frame(width: geo.size.width, height: height).foregroundColor( percentComplete < 1 ? Color.lightBG : Color.black)
                HStack {
                    if (percentComplete * geo.size.width > 17 && percentComplete < 1) {
                        RoundedRectangle(cornerSize: CGSize(width: height, height: height)).frame(width: percentComplete * geo.size.width, height: height).foregroundColor(Color("btnColor"))
                    }
                    Spacer()
                }
                if (percentComplete > 1) {
                    HStack() {
                        Spacer().frame(width: 1 * geo.size.width - ((height + 10) / 2))
                        ZStack {
                            Circle().frame(height: height+6).foregroundColor(.white).card()
                            Image(systemName: "car.circle.fill").resizable().scaledToFit().frame(height: height+6).symbolRenderingMode(.monochrome).foregroundColor(.black)
                        }
                        Spacer()
                    }
                } else {
                    HStack() {
                        Spacer().frame(width: percentComplete * geo.size.width - ((height + 10) / 2))
                        ZStack {
                            Circle().frame(height: height+6).foregroundColor(.white).card()
                            Image(systemName: "car.circle.fill").resizable().scaledToFit().frame(height: height+6).symbolRenderingMode(.monochrome).foregroundColor(.black)
                        }
                        Spacer()
                    }
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
