//
//  WorkoutViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 23.05.25.
//

import SwiftUI

class WorkoutViewModel: ObservableObject {
//    @Published var selectedDifficulty: WorkoutDifficulty = .init(level: "Easy", image: "🥰", color: .blue)
    
//    var difficultyArray: [WorkoutDifficulty] = [
//        .init(level: "Easy", image: "🥰", color: .blue),
//        .init(level: "Medium", image: "🫡", color: .yellow),
//        .init(level: "Hard", image: "😔", color: .red),
//        .init(level: "Free run", image: "😌", color: .green),
//    ]
    
    @Published var selectedIndex: Int = 0
    @Published var time: Int = 0
    @Published var numberOfRepeats: Int = 0
    var selectedWorkout: Workout {
        workoutArray.indices.contains(selectedIndex) ? workoutArray[selectedIndex] : workoutArray.first!
    }
    var workoutArray: [Workout] = [
        .init(difficulty: .init(level: "Easy", image: "🥰", color: .blue),
              start: Activity(time: 5, type: .walking, repeats: 0),
              core: [
                Activity(time: 1, type: .running),
                Activity(time: 2, type: .walking),
                Activity(time: 6, type: .running),
                Activity(time: 2, type: .walking),
              ], coreRepeats: 6,
              end: Activity(time: 5, type: .walking)),
        .init(difficulty: .init(level: "Medium", image: "🫡", color: .yellow),
              start: Activity(time: 5, type: .walking, repeats: 0),
              core: [
                Activity(time: 4, type: .running),
                Activity(time: 2, type: .walking),
                Activity(time: 6, type: .running),
                Activity(time: 2, type: .walking),
              ], coreRepeats: 3,
              end: Activity(time: 5, type: .walking)),
        .init(difficulty: .init(level: "Hard", image: "😔", color: .red),
              start: Activity(time: 5, type: .walking, repeats: 0),
              core: [
                Activity(time: 4, type: .running),
                Activity(time: 2, type: .walking),
                Activity(time: 6, type: .running),
                Activity(time: 2, type: .walking),
              ],
              end: Activity(time: 5, type: .walking)),
        .init(difficulty: .init(level: "Free Run", image: "😌", color: .green),
              start: Activity(time: 5, type: .walking, repeats: 0),
              core: [
                Activity(time: 4, type: .running),
                Activity(time: 2, type: .walking),
                Activity(time: 6, type: .running),
                Activity(time: 2, type: .walking),
              ],
              end: Activity(time: 5, type: .walking)),
    ]
    
    func calculateTime() {
//        guard let workout = selectedWorkout else {return}
        let workout = selectedWorkout
        var temp: Double = 0
        temp += workout.start.time
        for i in workout.core {
            temp += i.time
        }
        temp += workout.end.time
        time = Int(temp)
        
    }
    
    func getWorkoutData() {
//        guard let workout = selectedWorkout else {return}
        let workout = selectedWorkout
        withAnimation {
            numberOfRepeats = workout.coreRepeats ?? 0
        }
    }
    
    
}


