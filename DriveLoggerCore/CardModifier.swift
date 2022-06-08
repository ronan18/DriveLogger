//
//  Card.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 9/24/20.
//

import SwiftUI
public struct CardModifierView: ViewModifier {
    public func body(content: Content) -> some View {
        
            content.background(Color("CardBG")).cornerRadius(10.0).shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: 6, x: 0.0, y: 1)
    
    }
}

public extension View {
    func card() -> some View {
        ModifiedContent(
            content: self,
            modifier: CardModifierView()
        )
    }
}

private struct CardTest: View {
    //  let content: Body
    
    var body: some View {
        VStack {
            Text("test").font(.headline)
            Text("testing again").font(.subheadline)
        }.padding().card()
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        CardTest().previewLayout(.sizeThatFits).padding()
    }
}
