//
//  TrainingViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.05.25.
//

import SwiftUI
@Observable class TrainingViewModel {
    var workout: WorkoutModel?
    var isActive: Bool = true
    var currentObjectiveTime: Int = 0
    var isPaused: Bool = false {
        didSet {
            if isPaused == true {
                startTimer()
            } else {
                stopTimer()
            }
        }
    }
    var activities: [WorkoutActivity] = []
    var currentAcitivity: WorkoutActivity?
    var currentAcitivityIndex: Int = 0
    var isActivityInProgress: Bool = false
    
    var showAlert: Bool = false
    var alertText: String = ""
    
    var speed: Double = 0
    var pace: Double = 0
    var distance: Double = 0
    var duration: Int = 0
    
    var canProceed: Bool = false
    var workoutResult: WorkoutResultsModel?
    var firstStart: Bool = true
    var progressBarHeight: CGFloat = 0
    var progressText: Int = 0
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
    
    func getCurrentActivityTime() {
        guard let timeForFirstActivity = activities.first?.time else {
            print("No first activity to get time from")
            return
        }
        currentObjectiveTime = timeForFirstActivity
    }

    
    func createActivities() {
        guard let workout = workout else {
            print("no workout?")
            return
        }
        
        if workout.type == .running {
            
            guard var start = workout.start, let core = workout.core, var end = workout.end else {
                print("no core or start or end to create activity array")
                return
            }
            
            let repeats = workout.coreRepeats ?? 0
            var tempArray: [WorkoutActivity] = []
            start.id = UUID()
            tempArray.append(start)
            for i in 0...repeats {
                for activity in core {
                    var tempActivity = activity
                    tempActivity.id = UUID()
                    tempArray.append(tempActivity)
                }
            }
            end.id = UUID()
            tempArray.append(end)
            
            activities = tempArray
            currentAcitivityIndex = 0
            
            
        } else {
            
            guard let walkingWorkout = workout.start else {
                print("no walking workout to start")
                return
            }
            activities.append(walkingWorkout)
                
        }
    }

    func selectActivity() {
        guard let workout = workout else {
            return
        }
       
        if workout.type == .walking {
            guard let tempActivity = workout.start else {
                print("no selected activity for walking")
                return
            }
            withAnimation {
                currentObjectiveTime = tempActivity.time
            }
            currentAcitivity = tempActivity
            
        } else {
            let tempActivity = activities[currentAcitivityIndex]
        
            withAnimation {
                currentObjectiveTime = tempActivity.time
                
            }
            currentAcitivity = tempActivity
        }
    }
    
    func nextActivity() {
        guard let workout = workout else {
            print("no workout for next activity")
            return
        }
        
        if workout.type == .running {
            if currentAcitivityIndex < activities.count - 1 {
                currentAcitivityIndex += 1
            } else {
                stopActivity()
            }
            selectActivity()
        } else {
            stopActivity()
        }
    }
    
    func skipHolded() {
        let timeCheck = totalTime - currentObjectiveTime
        if timeCheck > 0 {
            totalTime -= currentObjectiveTime
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
            maxHeartRate: nil,
            type: workout?.type
            )
        
        canProceed = true
        stopLiveActivity()
    }
    
    func calculateProgress() {
       
        withAnimation {
            progressBarHeight = Double(currentAcitivityIndex) / Double(activities.count) * screenHeight
            
            print("")
            print("currentAcitivityIndex \(currentAcitivityIndex) and activities.count \(activities.count)")
            print("")
            
            progressText = Int(Double(currentAcitivityIndex) / Double(activities.count) * 100)
        }
    }
    
    func checkActivity() {
        if currentObjectiveTime == 0 {
            nextActivity()
        }
    }
    
    func handleTimerOnRecive() {
        withAnimation {
            checkActivity()
            getSpeed()
            getPace()
            calculateProgress()
            
            totalTime = max(0, totalTime - 1)
            currentObjectiveTime -= 1
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
                await LiveActivityManager.shared.updateActivity(currentActivity: currentAcitivity.type.rawValue, nextActivity: ActivityType.walking.rawValue, remainingTime: currentObjectiveTime, speed: speed, pace: pace, stages: [])
            }
        }
        
        
    }
    
   
    
    
    
    
}
