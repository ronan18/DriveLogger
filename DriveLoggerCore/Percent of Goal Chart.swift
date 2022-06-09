//
//  Percent of Goal Charge.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 6/8/22.
//
import SwiftUI
import DriveLoggerServicePackage

#if canImport(Charts)
import Charts
#endif
var graphGradient = Gradient(stops: [.init(color: Color("GraphGradientStart"), location: 0), .init(color: Color("GraphGradientEnd"), location: 0.99)])
public struct PercentOfGoalChart: View {
    var data: [DriveLengthDay]
    
    var average = true
    var axis = true
    var dailyAverage: TimeInterval
    var averageDriveLength: TimeInterval
    var label: String
    var yLimit: Int = 110
    var goalTime: Double
    var domain: ClosedRange<Int>
    
    public init(data: DriveLoggerAppState, average: Bool = true, axis: Bool = true, label: String? = nil) {
        /* self.data = data.driveLengthByDay.map({drive in
         return DriveLengthDay(date: drive.date, length: drive.length/data.goalTime * 100)
         })*/
        var currentTotalTime = 0.0
        var result: [DriveLengthDay] = []
        var totalPercentage = 0.0
        data.driveLengthByDay.reversed().forEach({drive in
            
            // print("ITTERATING OVER DRIVES FOR WIDGET", drive.date.formatted(), drive.length,drive.length/data.goalTime * 100, data.goalTime)
            currentTotalTime += drive.length
            //print("ITTERATING OVER DRIVES FOR WIDGET: current total time\(currentTotalTime) of \(data.goalTime) \((currentTotalTime/data.goalTime)*100)%")
            let percentage = (currentTotalTime/data.goalTime)*100
            totalPercentage += (drive.length/data.goalTime)*100
            result.append(DriveLengthDay(date: drive.date, length: percentage))
            
        })
        self.dailyAverage = round(totalPercentage/Double(data.driveLengthByDay.count))
        print("daily average", self.dailyAverage, totalPercentage, data.driveLengthByDay.count)
        self.data = result
        self.averageDriveLength = data.averageDriveDuration
        self.label = label ?? "goal completion over time"
        self.average = average
        self.axis = axis
       
       // self.dailyAverage = (sumAverage / Double(data.driveLengthByDay.count))
        
        if (data.percentComplete > 100) {
            yLimit = Int(data.percentComplete + 10)
        }
        self.domain =  0 ... self.yLimit
        self.goalTime = round(data.goalTime / 60 / 60)
        print("computed range for graph", self.domain, self.yLimit, data.percentComplete)
    }
    
    public var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                
                
                HStack {
                    VStack(alignment:.leading) {
                        Text(label).font(.headline)
                        if (axis && false) {
                            Text("time in minutes").font(.caption).foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                }
                Chart {
                    ForEach(data) { data in
                        AreaMark(
                            x: .value("Date", data.date, unit: .day),
                            y: .value("Duration", data.length)
                        ).foregroundStyle(graphGradient).interpolationMethod(.catmullRom)//.symbol(by: .value("Length", data.length))
                        LineMark(
                            x: .value("Date", data.date, unit: .day),
                            y: .value("Duration", data.length)
                        ).foregroundStyle(Color("BlackColor")).interpolationMethod(.catmullRom)
                        if (self.average) {
                            RuleMark(y: .value("Driving Goal", 100)).foregroundStyle(.green).annotation(position: .bottom, alignment: .leading) {
                                RuleMarkAnnotation(label: "Goal: **\(Int(self.goalTime))**hr", color: .green)
                            }
                            RuleMark(y: .value("Average Daily Percentage", self.dailyAverage)).foregroundStyle(.orange).annotation(position: .top, alignment: .trailing) {
                                RuleMarkAnnotation(label: self.axis ? "Average **\(Int(self.dailyAverage))**% increase a day" :"Avg **\(Int(self.dailyAverage))**% a day", color: .orange)
                            }
                            
                        }
                    }
                    
                    
                }.chartYScale(domain: 0 ... 114).chartLegend(self.axis ? .visible : .hidden).chartYAxis(self.axis ? .visible : .hidden).chartXAxis(self.axis ? .visible : .hidden)
            } else {
                HStack {
                    
                    VStack(alignment:.leading) {
                        Text(label + " graph").font(.headline)
                        if (axis) {
                            Text("Graphical representation of the goal completion per day").font(.caption).foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
                GraphsNeediOS16(smallScreen: axis ? false : true).padding(.top)
            }
            
            
            
            
            
            
            
        }
    }
}

