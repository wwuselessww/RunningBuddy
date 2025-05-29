//
//  WorkoutViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 23.05.25.
//

import SwiftUI

class WorkoutViewModel: ObservableObject {
    @Published var selectedIndex: Int = 0
    @Published var time: Int = 0
    @Published var numberOfRepeats: Int = 0
    @Published var startingBlock: Activity?
    @Published var mainBlock: [Activity] = []
    @Published var endBlock: Activity?
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
              ], coreRepeats: 1,
              end: Activity(time: 5, type: .walking)),
        .init(difficulty: .init(level: "Medium", image: "🫡", color: .yellow),
              start: Activity(time: 5, type: .walking, repeats: 0),
              core: [
                Activity(time: 4, type: .running),
                Activity(time: 2, type: .walking),
                Activity(time: 6, type: .running),
                Activity(time: 2, type: .walking),
              ], coreRepeats: 2,
              end: Activity(time: 5, type: .running)),
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
    
    func calculateTime(_ workout: Workout) {
        var temp: Double = 0
        var core: Int = 0
        print("workout.start.time", workout.start.time)
        temp += workout.start.time
        for i in workout.core {
            core += Int(workout.end.time)
            print("core", i.time)
        }
        core *= workout.coreRepeats ?? 1
        temp += Double(core)
        print("workout.end.time",  workout.end.time)
        temp += workout.end.time
        print("result", temp)
        withAnimation {
            time = Int(temp)
        }
        
    }
    
    func getWorkoutData(_ workout: Workout) {
        withAnimation {
            numberOfRepeats = workout.coreRepeats ?? 0
        }
        
        withAnimation {
            startingBlock = workout.start
            endBlock = workout.end
        }
        
    }
    
    
    
}


