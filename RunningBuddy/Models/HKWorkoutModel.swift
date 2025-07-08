//
//  WorkoutModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 08.05.25.
//

import Foundation
import HealthKit
import CoreLocation

struct HKWorkoutModel {
    var id = UUID()
    var workout: HKWorkout?
    var date: Date
    var distance: Double
    var avgPulse: Int?
    var type: WorkoutType
    var path: [CLLocationCoordinate2D]?
}
