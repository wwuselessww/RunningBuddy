//
//  WorkoutModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 08.05.25.
//

import SwiftUI

struct Workout: Hashable {
    var difficulty: WorkoutDifficulty
    var start: Activity
    var core: [Activity]
    var coreRepeats: Int?
    var end: Activity

}

struct WorkoutDifficulty: Hashable {
    let level: String
    let image: String
    let color: Color
}

struct Activity: Hashable {
    let id = UUID()
    var time: Int
    var type: ActivityType
    var repeats: Int?
}

enum ActivityType: String {
    case walking = "Walk"
    case running = "Run"
}
