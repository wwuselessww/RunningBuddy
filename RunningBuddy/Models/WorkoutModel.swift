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

struct WorkoutDifficulty: Hashable, Identifiable {
    let id: UUID = UUID()
    let level: String
    let image: Emotion
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


enum Emotion: String {
    case easy = "easy"
    case mid = "mid"
    case hard = "hard"
}
