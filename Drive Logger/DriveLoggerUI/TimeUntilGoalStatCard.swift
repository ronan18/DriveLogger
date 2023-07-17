//
//  TimeUntilGoalStatCard.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 7/13/23.
//

import SwiftUI
import DriveLoggerKit
import WidgetKit
public struct TimeUntilGoalStatCard: View {
    var statistics: DriveLoggerStatistics
    var goal: TimeInterval
    var untilGoal: TimeInterval
    var passedGoal = false
    var percentComplete: CGFloat
    var widgetMode: Bool
    var widgetFamily: WidgetFamily? = nil
    var ringHeight: CGFloat = 52
    public init(statistics: DriveLoggerStatistics, goal: TimeInterval, widgetMode: Bool = false, widgetFamily: WidgetFamily? = nil) {
        self.statistics = statistics
        self.goal = goal
        self.widgetMode = widgetMode
        let timeTill = (goal - statistics.totalDriveTime)
        self.untilGoal = abs(timeTill)
        let number = (statistics.totalDriveTime / goal)
        if number.isNaN || number.isInfinite {
            self.percentComplete = 1
        } else {
            self.percentComplete = number
        }
        if timeTill < 0 {
            self.passedGoal = true
        }
        self.widgetFamily = widgetFamily
        if (widgetFamily == .systemMedium) {
            self.ringHeight = 70
        }
    }
    
    public var body: some View {
        if (self.widgetFamily == .systemSmall) {
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Spacer()
                        ActivityRingView(percentComplete: percentComplete, height: 40).frame(height: 40)
                    }
                    Spacer()
                    VStack {
                        Image("Icon").resizable().frame(width: iconWidth, height: iconWidth)
                        Spacer()
                    }
                    
                }.padding(.bottom)
                Spacer()
                TimeDisplayView(time: untilGoal, mainFont: .title, labelFont: .title2)
                //  Text(untilGoal).font(.title).bold()
                Text(passedGoal ? "past goal" :"until goal").font(.subheadline)
            }
        } else {
            HStack {
                
                VStack(alignment: .leading) {
                    if (self.widgetMode) {
                        Image("Icon").resizable().frame(width: iconWidth, height: iconWidth)
                    }
                    Spacer()
                    TimeDisplayView(time: untilGoal, mainFont: .title, labelFont: .title2)
                    //  Text(untilGoal).font(.title).bold()
                    Text(passedGoal ? "past goal" :"until goal").font(.subheadline)
                }
                Spacer()
                VStack (alignment: .trailing) {
                    Spacer()
                    
                    ActivityRingView(percentComplete: percentComplete, height: ringHeight).frame(height: ringHeight).padding(10)
                    //Spacer()
                }
                
            }.ifCondition(!self.widgetMode, then: {view in
                view.frame(height: 80).padding().background(Color.cardBG).card()
            }).ifCondition(self.widgetMode, then: {view in
                view.padding(10)
            })
        }
    }
}

/*#Preview {
    TimeUntilGoalStatCard()
}
*/
struct ActivityRingView: View {
  var percentComplete: CGFloat
    let width: CGFloat = 10
    var height: CGFloat = 52
    var colors: [Color] = [Color.black, Color.lightBlack]
    init(percentComplete: CGFloat, height: CGFloat = 52) {
        self.percentComplete = percentComplete
        self.height = height
    }
    var body: some View {
       
            
            ZStack {
                        Circle()
                            .stroke(lineWidth: width)
                            .foregroundColor(Color.lightBG)
                        
                 
                
                        Circle()
                               .trim(from: 0, to: percentComplete)
                               .stroke(
                                   AngularGradient(
                                       gradient: Gradient(colors: colors),
                                       center: .center,
                                       startAngle: .degrees(0),
                                       endAngle: .degrees(360)
                                   ),
                                   style: StrokeStyle(lineWidth: width, lineCap: .round)
                           ).rotationEffect(.degrees(-90))
               
                Circle()
                               .frame(width: width, height: width)
                               .foregroundColor(Color.black)
                               .offset(y: 0 - height / 2)
                Circle()
                                .frame(width: width, height: width)
                                .foregroundColor(percentComplete > 0.95 ? Color.lightBlack: Color.lightBlack.opacity(0))
                                .offset(y: 0 - height / 2)
                                .rotationEffect(Angle.degrees(360 * Double(percentComplete)))
                                .shadow(color: percentComplete > 0.96 ? Color.black.opacity(0.1): Color.clear, radius: 3, x: 4, y: 0)
                
              
                               
             
                            

                    
        }
        
    }
}
