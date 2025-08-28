//
//  WorkoutAttributes.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.08.25.
//

import Foundation
import ActivityKit

struct WorkoutAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        var progress: Double
        var time: TimeInterval
        var currentActivity: String
    }
    
    var activityName: String
    var estimatedDuration: TimeInterval
}
