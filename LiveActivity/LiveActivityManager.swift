//
//  LiveActivityManager.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 15.08.25.
//

import Foundation
import ActivityKit

class LiveActivityManager {
    static let shared = LiveActivityManager()
    private var activity: Activity<WorkoutAttributes>?
    private init() {}
    func startActivity() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                let attributes = WorkoutAttributes(activityName: "running", estimatedDuration: 10)
                let initialContentState = WorkoutAttributes.ContentState(progress: 5.5, time: 10, currentActivity: "Walking")
                activity = try Activity<WorkoutAttributes>.request(
                    attributes: attributes,
                    content: .init(state: initialContentState, staleDate: nil),
                    pushType: nil
                )
                print("activity started")
            } catch {
                print("failed to start activity")
            }
        }
    }
    
    func updateActivity() {
        
    }
    func stopActivity() async {
        let initialContentState = WorkoutAttributes.ContentState(progress: 0.0, time: 0, currentActivity: "finished")
        
        await activity?.end(ActivityContent(state: initialContentState, staleDate: nil), dismissalPolicy: .default)
        print("activity stopped")
    }
}
