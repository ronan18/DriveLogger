//
//  BorderView.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 9/24/20.
//

import Foundation
import SwiftUI
public enum BorderType {
    case top
    case bottom
}
public struct Border: View {
    var type: BorderType
    public init(_ type: BorderType = .top) {
        self.type = type
    }
   public var body: some View {
        VStack {
            if (self.type == .bottom) {
            Spacer()
            }
            Rectangle().frame(height: 1).foregroundColor(Color.gray)
            if (self.type == .top) {
            Spacer()
            }
        }
    }
}
