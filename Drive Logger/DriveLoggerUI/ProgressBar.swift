//
//  ProgressBar.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 6/3/23.
//

import SwiftUI

public struct ProgressBar: View {
    let height: Double = 20
    @Binding var percentComplete:Double
    public init(percentComplete: Binding<Double>) {
        self._percentComplete = percentComplete
    }
    public var body: some View {
        GeometryReader { geo in
            
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: height, height: height)).frame(width: geo.size.width, height: height).foregroundColor(Color("LightGray"))
                HStack {
                    RoundedRectangle(cornerSize: CGSize(width: height, height: height)).frame(width: percentComplete * geo.size.width, height: height).foregroundColor(.black)
                    Spacer()
                }
                HStack() {
                    Spacer().frame(width: percentComplete * geo.size.width - ((height + 10) / 2))
                    ZStack {
                        Circle().frame(height: height+6).foregroundColor(.white).card()
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
            ProgressBar(percentComplete: .constant(0.34)).padding()
            Spacer()
        }.frame(width: 500, height: 100).previewLayout(.sizeThatFits)
        
    }
}
