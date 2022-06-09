//
//  RuleMarkAnnotation.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/8/22.
//

import Foundation
import SwiftUI
public struct RuleMarkAnnotation: View {
    let label: String
    let color: Color
    public var body: some View {
        if #available(iOS 16.0, *) {
            VStack {
                Text(.init(label)).font(.caption).foregroundColor(color)
            }.padding(2).background(.thinMaterial).cornerRadius(5)
        } else {
            Text("Uh Oh")
        }
    }
}
