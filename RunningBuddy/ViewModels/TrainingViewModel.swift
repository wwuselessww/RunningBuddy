//
//  TrainingViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.05.25.
//

import SwiftUI
@MainActor
class TrainingViewModel: ObservableObject {
    
    
    @Published var workout: WorkoutModel?
    @Published var isActive: Bool = true
    @Published var timerDisplay: Int = 300
    @Published var isPaused: Bool = false {
        didSet {
            if isPaused == true {
                startTimer()
            } else {
                stopTimer()
            }
        }
    }
    @Published var activities: [WorkoutActivity] = []
    @Published var currentAcitivity: WorkoutActivity?
    @Published var currentAcitivityIndex: Int = 0
    @Published var isActivityInProgress: Bool = false
    
    @Published var showAlert: Bool = false
    @Published var alertText: String = ""
    
    @Published var speed: Double = 0
    @Published var pace: Double = 0
    @Published var distance: Double = 0
    @Published var duration: Int = 0
    
    @Published var canProceed: Bool = false
    @Published var workoutResult: WorkoutResultsModel?
    @Published var firstStart: Bool = true
    @Published var progressBarHeight: CGFloat = 0
    @Published var progressText: Int = 0
    var paceArray: [Double] = []
    
    var locationManager: LocationManager = LocationManager()
    var workoutManager = WorkoutManager()
    var totalTime: Int = 0
    var image: Image = Image(systemName: "play.circle.fill")
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var screenHeight: CGFloat = 0
    
    func stopTimer() {
        timer.upstream.connect().cancel()
        image = Image(systemName: "play.circle.fill")
        withAnimation {
            isActivityInProgress = false
        }
    }
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        image = Image(systemName: "pause.circle.fill")
        locationManager.startTracking()
        withAnimation {
            isActivityInProgress = true
        }
        if firstStart {
            firstStart = false
            startLiveActivity()
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
        paceArray.append(pace)
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
        var tempArray: [WorkoutActivity] = []
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
    
    func nextActivity() {
        if currentAcitivityIndex < activities.count - 1 {
            currentAcitivityIndex += 1
        } else {
            stopActivity()
        }
        selectActivity()
        //MARK: check for time in minus 
    }
    
    func skipHolded() {
        let timeCheck = totalTime - timerDisplay
        if timeCheck > 0 {
            totalTime -= timerDisplay
        }
        
        nextActivity()
        calculateProgress()
    }
    
    func stopActivity() {
        timer.upstream.connect().cancel()
        locationManager.stopTracking()
        showAlert = true
        alertText = "Workout finished!"
        var paceCounter = 0.0
        for i in paceArray {
            paceCounter += i
        }
       let avgPace = paceCounter / Double(paceArray.count)
        //FIXME: pace should be avg not last recorded
        workoutResult = WorkoutResultsModel(
            pace: avgPace,
            distance: distance,
            duration: duration,
            path: workoutManager.locationArray,
            calories: nil,
            avgHeartRate: nil,
            maxHeartRate: nil
            )
        
        canProceed = true
        stopLiveActivity()
    }
    
    func calculateProgress() {
       
        withAnimation {
            progressBarHeight = Double(currentAcitivityIndex) / Double(activities.count) * screenHeight
            progressText = Int(Double(currentAcitivityIndex) / Double(activities.count) * 100)
        }
        print("progressBarHeight\(progressBarHeight)")
        print("progressText\(progressText)")
    }
    
    func checkActivity() {
        if timerDisplay == 0 {
            nextActivity()
        }
    }
    
    func handleTimerOnRecive() {
        withAnimation {
            checkActivity()
            getSpeed()
            getPace()
            calculateProgress()
            timerDisplay -= 1
            totalTime -= 1
            duration += 1
        }
    }
    
    //MARK: alerts
    
    func backPressed() {
        showAlert = true
        alertText = "End Workout"
    }
    func recordLocation() {
        guard let location = locationManager.currentLocation else {
            print("no location")
            return
        }
        workoutManager.recordLocation(location)
        workoutManager.getTottalDistance()
        updateLiveActivity()
        
        withAnimation {
            distance = Double(workoutManager.distance / 1000)
        }
    }
    func handleCancel() {
        showAlert = false
    }
    
    //MARK: live activity
    func startLiveActivity() {
        LiveActivityManager.shared.startActivity()
    }
    
    func stopLiveActivity() {
        Task {
            await LiveActivityManager.shared.stopActivity()
        }
    }
    
    
    func updateLiveActivity() {
        
        if let currentAcitivity = currentAcitivity {
            Task {
                await LiveActivityManager.shared.updateActivity(currentActivity: currentAcitivity.type.rawValue, nextActivity: ActivityType.walking.rawValue, remainingTime: timerDisplay, speed: speed, pace: pace, stages: [])
            }
        }
        
        
    }
    
   
    
    
    
    
}
