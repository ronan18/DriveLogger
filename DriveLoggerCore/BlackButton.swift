//
//  BlackButton.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 9/24/20.
//

import SwiftUI

public struct BlackButton: View {
    let text: String
    let action: (()->())
    public init(_ text: String, action: @escaping (()->()) = {}) {
        self.text = text
        self.action = action
    }
    public var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(text).fontWeight(.bold).foregroundColor(.white)
                Spacer()
            }.padding().background(Color("BlackBG")).cornerRadius(10)
        }
        
    }
}

struct BlackButton_Previews: PreviewProvider {
    static var previews: some View {
        BlackButton("Start Drive").previewLayout(.sizeThatFits).padding()
    }
}
