//
//  WorkoutViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 23.05.25.
//

import SwiftUI

@Observable class WorkoutViewModel {
    
    var selectedIndex: Int = 0
    var time: Int = 0
    var numberOfRepeats: Int = 0
    var startingBlock: WorkoutActivity?
    var mainBlock: [WorkoutActivity] = []
    var endBlock: WorkoutActivity?
    var dificultyArray: [WorkoutDifficulty] = [
        .init(level: "easy", image: .easy, color: .green),
        .init(level: "mid", image: .mid, color: .yellow),
        .init(level: "hard", image: .hard, color: .red),
    ]
    var selectedDifficulty: WorkoutDifficulty = .init(level: "easy", image: .easy, color: .green)
    var selectedType: WorkoutType = .outdoorRun
    var backgroundColor: Color = .green
    var selectedEmotion: Emotion? = .easy
    var currentTotalTime: Int = 0
    
    var selectedWorkout: WorkoutModel {
        workoutRunArray.indices.contains(selectedIndex) ? workoutRunArray[selectedIndex] : workoutRunArray.first!
    }
    var workoutRunArray: [WorkoutModel] = [
        .init(difficulty: .init(level: "Easy", image: .easy, color: .blue),
              start: WorkoutActivity(time: 1*10, type: .walking, repeats: 0),
              core: [
                WorkoutActivity(time: 1*10, type: .running),
                WorkoutActivity(time: 1*10, type: .walking),
                WorkoutActivity(time: 1*10, type: .running),
                WorkoutActivity(time: 1*10, type: .walking),
              ], coreRepeats: 1,
              end: WorkoutActivity(time: 1*10, type: .walking)),
        .init(difficulty: .init(level: "Medium", image: .mid, color: .yellow),
              start: WorkoutActivity(time: 5*60, type: .walking, repeats: 0),
              core: [
                WorkoutActivity(time: 4*60, type: .running),
                WorkoutActivity(time: 2*60, type: .walking),
                WorkoutActivity(time: 6*60, type: .running),
                WorkoutActivity(time: 2*60, type: .walking),
              ], coreRepeats: 2,
              end: WorkoutActivity(time: 5*60, type: .running)),
        .init(difficulty: .init(level: "Hard", image: .hard, color: .red),
              start: WorkoutActivity(time: 5*60, type: .walking, repeats: 0),
              core: [
                WorkoutActivity(time: 10*60, type: .running),
                WorkoutActivity(time: 3*60, type: .walking),
                WorkoutActivity(time: 10*60, type: .running),
              ],
              end: WorkoutActivity(time: 5*60, type: .walking)),
    ]
    
    func calculateTime(_ workout: WorkoutModel) {
        var temp: Int = 0
        temp += workout.start.time
        let repeats = workout.coreRepeats ?? 0
        for _ in 0...repeats{
            for i in workout.core {
                temp += i.time
            }
        }
        temp += workout.end.time
        print(temp)
        withAnimation {
            time = temp
        }
        
    }
    
    func getWorkoutData(_ workout: WorkoutModel) {
        withAnimation {
            numberOfRepeats = workout.coreRepeats ?? 0
            startingBlock = workout.start
            endBlock = workout.end
            mainBlock = workout.core
        }
        
        
    }
    
    
    
}


