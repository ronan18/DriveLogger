//
//  CardModifier.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 6/3/23.
//

import Foundation
import SwiftUI

public struct CardModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.cornerRadius(10).shadow(color: Color.shadow, radius: 3)
           
    }
}


public extension View {
    func card() -> some View {
        return self.modifier(CardModifier())
    }
}

#Preview {
    HStack {
        Spacer()
        Text("Card testing")
        Spacer()
    }.padding().card()
}
