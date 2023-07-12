//
//  DL_Driving_ActivityLiveActivity.swift
//  DL Driving Activity
//
//  Created by Ronan Furuta on 7/9/23.
//

import ActivityKit
import WidgetKit
import SwiftUI
import DriveLoggerKit



struct DL_Driving_ActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DL_Driving_ActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DL_Driving_ActivityAttributes {
    fileprivate static var preview: DL_Driving_ActivityAttributes {
        DL_Driving_ActivityAttributes(name: "World")
    }
}

extension DL_Driving_ActivityAttributes.ContentState {
    fileprivate static var smiley: DL_Driving_ActivityAttributes.ContentState {
        DL_Driving_ActivityAttributes.ContentState(emoji: "😀", currentDrive: CurrentDrive(start: Date(), startLocation: nil))
     }
     
     fileprivate static var starEyes: DL_Driving_ActivityAttributes.ContentState {
         DL_Driving_ActivityAttributes.ContentState(emoji: "🤩", currentDrive: CurrentDrive(start: Date(), startLocation: nil))
     }
}

#Preview("Notification", as: .content, using: DL_Driving_ActivityAttributes.preview) {
   DL_Driving_ActivityLiveActivity()
} contentStates: {
    DL_Driving_ActivityAttributes.ContentState.smiley
    DL_Driving_ActivityAttributes.ContentState.starEyes
}
