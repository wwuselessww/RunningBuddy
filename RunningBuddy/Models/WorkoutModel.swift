//
//  WorkoutModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 08.05.25.
//

import SwiftUI

struct WorkoutModel: Hashable {
    var difficulty: WorkoutDifficulty
    var start: WorkoutActivity
    var core: [WorkoutActivity]
    var coreRepeats: Int?
    var end: WorkoutActivity

}

struct WorkoutDifficulty: Hashable {
    let level: String
    let image: String
    let color: Color
}

struct WorkoutActivity: Hashable {
    var id = UUID()
    var time: Int
    var type: ActivityType
    var repeats: Int?
}

enum ActivityType: String {
    case walking = "Walk"
    case running = "Run"
}
