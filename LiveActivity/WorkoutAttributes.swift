//
//  WorkoutAttributes.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.08.25.
//

import Foundation
import ActivityKit
import UIKit

struct WorkoutAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        var activityName: String
        var nextActivity: String
        var remainingTime: Int
        var speed: Double
        var pace: Double
        var stages: [Stage]
    }
    
    var activityName: String
    var estimatedDuration: TimeInterval
}


/// activity
/// next activity
/// remaining time
/// speed
/// pace
/// stage array [Stage]
///
///
