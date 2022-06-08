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
    var stayBlack: Bool
    public init(_ text: String, action: @escaping (()->()) = {}, stayBlack: Bool) {
        self.text = text
        self.action = action
        self.stayBlack = stayBlack
    }
    public init(_ text: String, action: @escaping (()->()) = {}) {
        self.text = text
        self.action = action
        self.stayBlack = false
    }
    public var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(text).fontWeight(.bold).foregroundColor(.white)
                Spacer()
            }.padding().background(stayBlack ? Color.black : Color("blackBG")).cornerRadius(10)
        }
        
    }
}

struct BlackButton_Previews: PreviewProvider {
    static var previews: some View {
        BlackButton("Start Drive").previewLayout(.sizeThatFits).padding()
    }
}
