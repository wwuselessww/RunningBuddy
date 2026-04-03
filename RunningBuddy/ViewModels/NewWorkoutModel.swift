//
//  NewWorkoutModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 03.03.26.
//

import SwiftUI

@Observable class NewWorkoutModel {
    var selectedWorkoutType: WorkoutType = .outdoorRun
    let workoutTypesArray: [WorkoutType] = [.outdoorRun, .outdoorWalk]
    var selectedDifficulty: String = ""
    let difficultyFacePositions: [FaceAnimation] = [.init(eyeSize: 0, eyeRotation: 0, mouthSize: 0, mouthRotation: 0    ), .init(eyeSize: 0, eyeRotation: 0, mouthSize: 0, mouthRotation: 0)]
    
    
}


struct FaceAnimation {
    let eyeSize: Double
    let eyeRotation: Double
    let mouthSize: Double
    let mouthRotation: Double
}

