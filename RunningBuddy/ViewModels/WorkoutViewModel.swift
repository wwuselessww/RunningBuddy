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
    var selectedWorkout: WorkoutModel {
        workoutArray.indices.contains(selectedIndex) ? workoutArray[selectedIndex] : workoutArray.first!
    }
    var workoutArray: [WorkoutModel] = [
        .init(difficulty: .init(level: "Easy", image: "🥰", color: .blue),
              start: Activity(time: 5*60, type: .walking, repeats: 0),
              core: [
                Activity(time: 1*60, type: .running),
                Activity(time: 2*60, type: .walking),
                Activity(time: 6*60, type: .running),
                Activity(time: 2*60, type: .walking),
              ], coreRepeats: 1,
              end: Activity(time: 5*60, type: .walking)),
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
    
    func calculateTime(_ workout: WorkoutModel) {
        var temp: Int = 0
        temp += workout.start.time
        let repeats = workout.coreRepeats ?? 0
        print("repeats \(repeats)")
        print(temp)
        for _ in 0...repeats{
            for i in workout.core {
                temp += i.time
                print(temp)
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


