//
//  WorkoutModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 08.05.25.
//

import Foundation
import HealthKit

struct HKWorkoutModel: Hashable {
    var workout: HKWorkout
    var date: Date
    var distance: Double
    var avgPulse: Int
    var type: WorkoutType
}
