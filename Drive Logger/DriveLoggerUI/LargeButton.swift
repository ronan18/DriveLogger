//
//  LargeButton.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 6/3/23.
//

import SwiftUI

public struct LargeButton: View {
    let label: String
    let action: ()->()
    public init(_ label: String, action: @escaping ()->()) {
        self.label = label
        self.action = action
    }
    public var body: some View {
        Button(label, action: action).padding(.vertical, 20).padding(.horizontal, 60).background(Color.black).foregroundColor(.white).bold().cornerRadius(6)
    }
}

struct LargeButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LargeButton("Press Me", action: {}).padding()
        }.previewLayout(.sizeThatFits)
    }
}
