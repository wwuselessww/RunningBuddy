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
                let initialContentState = WorkoutAttributes.ContentState(activityName: ActivityType.running.rawValue, nextActivity: ActivityType.walking.rawValue, remainingTime: 0, speed: 10, pace: 0, stages: [])
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
    
    func updateActivity(currentActivity activityName: String, nextActivity: String, remainingTime: Int, speed: Double, pace: Double, stages: [Stage]) async {
        
        let updatedContent: WorkoutAttributes.ContentState = .init(activityName: activityName, nextActivity: nextActivity, remainingTime: remainingTime, speed: speed, pace: pace, stages: stages)
        guard let activity = activity else {
            print("no activity ***")
            return
        }
        if #available(iOS 16.2, *) {
               await activity.update(ActivityContent(state: updatedContent, staleDate: nil))
           } else {
               await activity.update(using: updatedContent)
           }
        
    }
    
    func stopActivity() async {
        let initialContentState = WorkoutAttributes.ContentState(activityName: ActivityType.running.rawValue, nextActivity: ActivityType.walking.rawValue, remainingTime: 0, speed: 10, pace: 0, stages: [])
        
        await activity?.end(ActivityContent(state: initialContentState, staleDate: nil), dismissalPolicy: .default)
        print("activity stopped")
    }
}
