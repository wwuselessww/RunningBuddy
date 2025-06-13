//
//  TrainingViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.05.25.
//

import SwiftUI

class TrainingViewModel: ObservableObject {
    
    
    @Published var workout: Workout?
    @Published var isActive: Bool = true
    @Published var timerDisplay: Int = 300
    @Published var isPlayPausePressed: Bool = false
    
//    @Published var now: Date = Date.now
//    @Published var plusSecond: Date = Date.now
    @Published var activities: [Activity] = []
    @Published var currentAcitivity: Activity?
    @Published var currentAcitivityIndex: Int = 0
    @Published var isActivityInProgress: Bool = false
    var locationManager: LocationManager = LocationManager()
    
    @Published var speed: Double = 0
    @Published var remainingTime: Int = 0
    var totalTime: Int = 0
    var calendar = Calendar.current
    
    
    
    var image: Image = Image(systemName: "play.fill")
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func stopTimer() {
        timer.upstream.connect().cancel()
        image = Image(systemName: "play.fill")
        isActivityInProgress = false
    }
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        image = Image(systemName: "pause.fill")
        isActivityInProgress = true
    }
    
    func getSpeed() {
        withAnimation {
            speed = locationManager.speed
        }
    }
    
    func getTotalTime() {
        var time: Int = 0
        for index in 0..<activities.count {
            if index >= currentAcitivityIndex {
                time += activities[index].time
            }
        }
        print("total time \(time / 60)")
        totalTime = time
    }
    
    func getRemaingTime() {
       remainingTime = totalTime - timerDisplay
    }
    
    func createActivitiesArray() {
        guard let workout = workout else {
            print("no workout?")
            return
        }
        let repeats = workout.coreRepeats ?? 0
        var tempArray: [Activity] = []
        tempArray.append(workout.start)
        for _ in 0...repeats {
            for activity in workout.core {
                tempArray.append(activity)
            }
        }
        tempArray.append(workout.end)
        activities = tempArray
        print(tempArray.count)
    }
    func selectActivity() {
        guard let workout = workout else {
            print("no workout?")
            return
        }
        currentAcitivity = activities[currentAcitivityIndex]
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let newSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, newSeconds)
    }
    
    
    
}
