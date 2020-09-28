//
//  ProgressStat.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 9/27/20.
//

import Foundation


import SwiftUI
struct RingBackgroundShape: Shape {
    
    var thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.width / 2, y: rect.height / 2),
            radius: rect.width / 2 - thickness,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 360),
            clockwise: false
        )
        return path
            .strokedPath(.init(lineWidth: thickness, lineCap: .round, lineJoin: .round))
    }
    
}
struct RingShape: Shape {
    
    var currentPercentage: Double
    var thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.addArc(
            center: CGPoint(x: rect.width / 2, y: rect.height / 2),
            radius: rect.width / 2 - thickness,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 360 * currentPercentage),
            clockwise: false
        )
        
        return path
            .strokedPath(.init(lineWidth: thickness, lineCap: .round, lineJoin: .round))
    }
    
    var animatableData: Double {
        get { return currentPercentage }
        set { currentPercentage = newValue }
    }
    
}
struct RingTipShape: Shape {
    
    var currentPercentage: Double
    var thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let angle = CGFloat((360 * currentPercentage) * .pi / 180)
        let controlRadius: CGFloat = rect.width / 2 - thickness
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let x = center.x + controlRadius * cos(angle)
        let y = center.y + controlRadius * sin(angle)
        let pointCenter = CGPoint(x: x, y: y)
        
        path.addEllipse(in:
            CGRect(
                x: pointCenter.x - thickness / 2,
                y: pointCenter.y - thickness / 2,
                width: thickness,
                height: thickness
            )
        )
        
        return path
    }
    
    var animatableData: Double {
        get { return currentPercentage }
        set { currentPercentage = newValue }
    }
    
}
struct RingView: View {
    
    @State var currentPercentage: Double = 0
    
    var percentage: Double
    var backgroundColor: Color
    var startColor: Color
    var endColor: Color
    var thickness: CGFloat

    var animation: Animation {
        Animation.easeInOut(duration: 1)
    }
    
    var body: some View {
        let gradient = AngularGradient(gradient: Gradient(colors: [startColor, endColor]), center: .center, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360 * currentPercentage))
        return ZStack {
            RingBackgroundShape(thickness: thickness)
                .fill(backgroundColor)
            RingShape(currentPercentage: self.currentPercentage, thickness: thickness)
                .fill(gradient)
                .rotationEffect(.init(degrees: -90))
                .shadow(radius: 2)
                .drawingGroup()
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(self.animation) {
                            self.currentPercentage = self.percentage
                            
                        }
                    }
                }
            RingTipShape(currentPercentage: self.currentPercentage, thickness: thickness)
                .fill(currentPercentage > 1 ? endColor : .clear)
                .rotationEffect(.init(degrees: -90))
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(self.animation) {
                            self.currentPercentage = self.percentage
                        }
                    }
                }
        }
    }
    
}
public struct ProgressStat: View {
    var width: CGFloat
    var value: String
    var unit: String
    var description: String
    var progress: Double
    public init(width: CGFloat? = nil, value: Double, unit: String, description: String) {
        if let width = width {
            self.width = (width / 2) - 30
        } else {
            self.width =  150
        }
        self.progress = (Double(value) / 100)
        print("PROGRESS:", value, self.progress)
        self.value = String(Int(value))
        self.unit = unit
        self.description = description
    }
    public var body: some View {
        ZStack {
            RingView(currentPercentage: self.progress, percentage: self.progress, backgroundColor: Color.gray, startColor: Color("LightBlack"), endColor: Color("Text"), thickness: 10)
        VStack {
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text(self.value).font(.largeTitle).fontWeight(.bold)
                Text(self.unit).font(.headline)
            }
            Text(self.description).font(.caption)
        }
        }
    }
}
