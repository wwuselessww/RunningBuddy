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
            LockScreenLiveActivity(with: context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    WorkoutLiveActivityExpanded(with: context.state)
                }

                
            } compactLeading: {
                HStack {
                    Image(systemName: context.state.activityName == "Run" ? "figure.run" : "figure.walk")
                    Text(context.state.activityName.capitalized)
                }
            } compactTrailing: {
                Text(Double(context.state.remainingTime).timeString())
                    .contentTransition(.numericText())
            } minimal: {
                HStack {
                    Image(systemName: context.state.activityName == ActivityType.running.rawValue ? "figure.run" : "figure.walk")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}


#Preview("Expanded", as: .dynamicIsland(.compact), using: WorkoutAttributes(activityName: "gg", estimatedDuration: 100)) {
    WorkoutLiveActivity()
} contentStates: {
    WorkoutAttributes.ContentState(activityName: "running", nextActivity: "walking", remainingTime: 0, speed: 10, pace: 0, stages: [])
}

