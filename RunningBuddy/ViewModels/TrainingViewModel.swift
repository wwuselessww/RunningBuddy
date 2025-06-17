//
//  TrainingViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.05.25.
//

import SwiftUI
@MainActor
class TrainingViewModel: ObservableObject {
    
    
    @Published var workout: Workout?
    @Published var isActive: Bool = true
    @Published var timerDisplay: Int = 300
    @Published var isPlayPausePressed: Bool = false
    @Published var activities: [Activity] = []
    @Published var currentAcitivity: Activity?
    @Published var currentAcitivityIndex: Int = 0
    @Published var isActivityInProgress: Bool = false
    
    @Published var showAlert: Bool = false
    @Published var alertText: String = ""
    @Published var speed: Double = 0
    @Published var pace: Double = 0
    @Published var distance: Double = 0
    @Published var canProceed: Bool = false
    var locationManager: LocationManager = LocationManager()
    var workoutManager = WorkoutManager()
    var totalTime: Int = 0
    var calendar = Calendar.current
    var firstStart: Bool = true
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
        if firstStart {
            firstStart = false
            //MARK: start workout
        }
    }
    
    func getSpeed() {
        withAnimation {
            speed = locationManager.speed
        }
        recordLocation()
    }
    func getPace() {
        pace = 60 / speed
        if pace.isInfinite {
            pace = 0
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

    
    func createActivitiesArray() {
        guard var workout = workout else {
            print("no workout?")
            return
        }
        let repeats = workout.coreRepeats ?? 0
        var tempArray: [Activity] = []
        workout.start.id = UUID()
        tempArray.append(workout.start)
        for i in 0...repeats {
            print("repeat \(i)")
            for activity in workout.core {
                var tempActivity = activity
                tempActivity.id = UUID()
                tempArray.append(tempActivity)
            }
        }
        workout.end.id = UUID()
        tempArray.append(workout.end)
        
        activities = tempArray
        currentAcitivityIndex = 0
        print(tempArray)
        
    }

    func selectActivity() {
        guard workout != nil else {
            print("no workout?")
            return
        }
        let tempActivity = activities[currentAcitivityIndex]
        withAnimation {
            timerDisplay = tempActivity.time
            
        }
        currentAcitivity = tempActivity
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let newSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, newSeconds)
    }
    
    func nextActivity() {
        if currentAcitivityIndex < activities.count - 1 {
            currentAcitivityIndex += 1
        } else {
            //MARK: catch if ended
//            currentAcitivityIndex = 0
            stopActivity()
        }
        selectActivity()
    }
    
    func skipHolded() {
        totalTime -= timerDisplay
        nextActivity()
    }
    
    func stopActivity() {
        timer.upstream.connect().cancel()
        showAlert = true
        alertText = "Workout finished!"
        canProceed = true
    }
    
    //MARK: alerts
    
    func backPressed() {
        showAlert = true
        alertText = "End Workout"
    }
    func recordLocation() {
        guard let location = locationManager.currentLocation else {
            print("no lcoation")
            return
        }
        workoutManager.recordLocation(location)
        workoutManager.getTottalDistance()
        print("DISTANCE \(workoutManager.distance.description)")
        withAnimation {
            distance = Double(workoutManager.distance / 1000)
        }
    }
    
    
}
