//
//  WorkoutResultsModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.06.25.
//

import Foundation
import CoreLocation

struct WorkoutResultsModel: Hashable {
    let pace: Double
    let distance: Double
    let duration: Int
    let path: [CLLocation]
    let calories: Int?
    let avgHeartRate: Int?
    let maxHeartRate: Int?
}
