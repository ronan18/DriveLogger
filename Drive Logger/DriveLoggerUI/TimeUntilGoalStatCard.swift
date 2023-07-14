//
//  TimeUntilGoalStatCard.swift
//  DriveLoggerUI
//
//  Created by Ronan Furuta on 7/13/23.
//

import SwiftUI
import DriveLoggerKit
public struct TimeUntilGoalStatCard: View {
    var statistics: DriveLoggerStatistics
    var goal: TimeInterval
    var untilGoal: String
    var passedGoal = false
    var percentComplete: CGFloat
    var widgetMode: Bool
    public init(statistics: DriveLoggerStatistics, goal: TimeInterval, widgetMode: Bool = false) {
        self.statistics = statistics
        self.goal = goal
        self.widgetMode = widgetMode
        let timeTill = (goal - statistics.totalDriveTime)
        self.untilGoal = abs(timeTill).formatedForDrive()
        let number = (statistics.totalDriveTime / goal)
        if number.isNaN || number.isInfinite {
            self.percentComplete = 1
        } else {
            self.percentComplete = number
        }
        if timeTill < 0 {
            self.passedGoal = true
        }
    }
    
    public var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Spacer()
                Text(untilGoal).font(.title).bold()
                Text(passedGoal ? "passed goal" :"until goal").font(.subheadline)
            }
            Spacer()
            VStack (alignment: .trailing) {
                Spacer()
                
                ActivityRingView(percentComplete: percentComplete ).frame(height: 52).padding(10)
                //Spacer()
            }
           
        }.ifCondition(!self.widgetMode, then: {view in
            view.frame(height: 80).padding().background(Color.cardBG).card()
        }).ifCondition(widgetMode, then: {view in
            view.padding(10)
        })
    }
}

/*#Preview {
    TimeUntilGoalStatCard()
}
*/
struct ActivityRingView: View {
  var percentComplete: CGFloat
    let width: CGFloat = 10
    let height: CGFloat = 52
    var colors: [Color] = [Color.black, Color.lightBlack]
    
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
