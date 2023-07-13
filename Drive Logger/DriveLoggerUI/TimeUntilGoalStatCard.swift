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
    var percentComplete: CGFloat
    public init(statistics: DriveLoggerStatistics, goal: TimeInterval) {
        self.statistics = statistics
        self.goal = goal
        self.untilGoal = (goal - statistics.totalDriveTime).formatedForDrive()
        let number = (statistics.totalDriveTime / goal)
        if number.isNaN || number.isInfinite {
            self.percentComplete = 1
        } else {
            self.percentComplete = number
        }
    }
    
    public var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Spacer()
                Text(untilGoal).font(.title).bold()
                Text("until goal").font(.subheadline)
            }
            Spacer()
            VStack (alignment: .trailing) {
                Spacer()
                
                ActivityRingView(percentComplete: percentComplete ).padding(10)
                //Spacer()
            }
           
        }.frame(height: 80).padding().background(Color.cardBG).card()
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
                            .opacity(0.2)
                            .foregroundColor(Color.black)
                        
                      /*  Circle()
                            .trim(from: 0.0, to: CGFloat(min(percentComplete, 1.0)))
                            .stroke(style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
                            .foregroundColor(Color.black)
                            .rotationEffect(Angle(degrees: 270.0)) */
                
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
                                .offset(y: -150)
                                .rotationEffect(Angle.degrees(360 * Double(percentComplete)))
                                .shadow(color: percentComplete > 0.96 ? Color.black.opacity(0.1): Color.clear, radius: 3, x: 4, y: 0)
                            

                    
        }
        
    }
}
