//
//  LiveActivityLiveActivity.swift
//  LiveActivity
//
//  Created by Alexander Kozharin on 27.08.25.
//

import ActivityKit
import WidgetKit
import SwiftUI



struct WorkoutLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WorkoutAttributes.self) { context in
            LockScreenLiveActivity()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    WorkoutLiveActivityExpanded()
                }

                
            } compactLeading: {
                HStack {
                    Image(systemName: "figure.run")
                    Text("Run")
                }
            } compactTrailing: {
               Text("30:99")
            } minimal: {
                HStack {
//                    Spacer()
                    Image(systemName: "figure.run")
                        .resizable()
                        .scaledToFit()
//                    Spacer()
                }
            }
        }
    }
}


#Preview("Expanded", as: .dynamicIsland(.compact), using: WorkoutAttributes(activityName: "gg", estimatedDuration: 100)) {
    WorkoutLiveActivity()
} contentStates: {
    WorkoutAttributes.ContentState(progress: 6, time: 9, currentActivity: "hhdd")
}

