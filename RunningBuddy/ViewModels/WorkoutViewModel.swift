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
    var selectedType: WorkoutType = .outdoorWalk
    var selectedEmotion: Emotion? = .easy
    var selectedWorkout: WorkoutModel = .init(difficulty: .init(level: "", image: .easy, color: .pink), type: .running)
    var backgroundColor: Color = .green
    
    var currentTotalTime: Int = 0
    
    
    var workoutRunArray: [WorkoutModel] = [
        .init(difficulty: .init(level: "Easy", image: .easy, color: .blue), type: .running,
              start: WorkoutActivity(time: 1*10, type: .walking, repeats: 0),
              core: [
                WorkoutActivity(time: 1*10, type: .running),
                WorkoutActivity(time: 1*10, type: .walking),
                WorkoutActivity(time: 1*10, type: .running),
                WorkoutActivity(time: 13, type: .walking),
              ], coreRepeats: 1,
              end: WorkoutActivity(time: 27, type: .running)),
        .init(difficulty: .init(level: "Medium", image: .mid, color: .yellow), type: .running,
              start: WorkoutActivity(time: 5*60, type: .walking, repeats: 0),
              core: [
                WorkoutActivity(time: 4*60, type: .running),
                WorkoutActivity(time: 2*60, type: .walking),
                WorkoutActivity(time: 6*60, type: .running),
                WorkoutActivity(time: 2*60, type: .walking),
              ], coreRepeats: 2,
              end: WorkoutActivity(time: 5*60, type: .running)),
        .init(difficulty: .init(level: "Hard", image: .hard, color: .red), type: .running,
              start: WorkoutActivity(time: 5*60, type: .walking, repeats: 0),
              core: [
                WorkoutActivity(time: 10*60, type: .running),
                WorkoutActivity(time: 3*60, type: .walking),
                WorkoutActivity(time: 10*60, type: .running),
              ],
              end: WorkoutActivity(time: 5*60, type: .walking)),
    ]
    
    var workoutWalk: WorkoutModel = .init(difficulty: .init(level: "Walk", image: .easy, color: .green),
                                          type: .walking,
                                          start: .init(time: 0, type: .walking),
                                          core: nil,
                                          end: nil)
    
    
    func createWalkingWorkout() {
        //        workoutWalk.start?.time = time * 60
        workoutWalk.start?.time = time
    }
    
    func calculateTime(_ workout: WorkoutModel) {
        var temp: Int = 0
        
        guard let start = workout.start, let core = workout.core, let end = workout.end else {
            return
        }
        
        temp += start.time
        let repeats = workout.coreRepeats ?? 0
        for _ in 0...repeats{
            for i in core {
                temp += i.time
            }
        }
        temp += end.time
        print(temp)
        withAnimation {
            time = temp
        }
        
    }
    
    func getWorkoutData(_ workout: WorkoutModel) {
        
        guard let core = workout.core else {
            print("no core to get data to")
            return
        }
        
        withAnimation {
            numberOfRepeats = workout.coreRepeats ?? 0
            startingBlock = workout.start
            endBlock = workout.end
            mainBlock = core
            
        }
        
        
    }
    
    
    func changeWorkoutType(_ type: WorkoutType) {
        if type == .outdoorRun {
           selectedWorkout = workoutRunArray.indices.contains(selectedIndex) ? workoutRunArray[selectedIndex] : workoutRunArray.first!
            
        } else {
            selectedWorkout = workoutWalk
        }
        
    }
    
    
    
}


