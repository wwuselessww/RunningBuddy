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
    @Published var startingBlock: WorkoutActivity?
    @Published var mainBlock: [WorkoutActivity] = []
    @Published var endBlock: WorkoutActivity?
    var selectedWorkout: WorkoutModel {
        workoutArray.indices.contains(selectedIndex) ? workoutArray[selectedIndex] : workoutArray.first!
    }
    var workoutArray: [WorkoutModel] = [
        .init(difficulty: .init(level: "Easy", image: "🥰", color: .blue),
              start: WorkoutActivity(time: 1*10, type: .walking, repeats: 0),
              core: [
                WorkoutActivity(time: 1*10, type: .running),
                WorkoutActivity(time: 1*10, type: .walking),
                WorkoutActivity(time: 1*10, type: .running),
                WorkoutActivity(time: 1*10, type: .walking),
              ], coreRepeats: 1,
              end: WorkoutActivity(time: 1*10, type: .walking)),
        .init(difficulty: .init(level: "Medium", image: "🫡", color: .yellow),
              start: WorkoutActivity(time: 5*60, type: .walking, repeats: 0),
              core: [
                WorkoutActivity(time: 4*60, type: .running),
                WorkoutActivity(time: 2*60, type: .walking),
                WorkoutActivity(time: 6*60, type: .running),
                WorkoutActivity(time: 2*60, type: .walking),
              ], coreRepeats: 2,
              end: WorkoutActivity(time: 5*60, type: .running)),
        .init(difficulty: .init(level: "Hard", image: "😔", color: .red),
              start: WorkoutActivity(time: 5*60, type: .walking, repeats: 0),
              core: [
                WorkoutActivity(time: 10*60, type: .running),
                WorkoutActivity(time: 3*60, type: .walking),
                WorkoutActivity(time: 10*60, type: .running),
              ],
              end: WorkoutActivity(time: 5*60, type: .walking)),
        .init(difficulty: .init(level: "Free Run", image: "😌", color: .green),
              start: WorkoutActivity(time: 1*60, type: .walking, repeats: 0),
              core: [
                WorkoutActivity(time: 30*60, type: .running)
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


