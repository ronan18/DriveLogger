//
//  VisualEffectView.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 9/24/20.
//
import SwiftUI
import UIKit
import Foundation
public struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    public init(effect: UIVisualEffect?) {
        self.effect = effect
    }
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    public func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
